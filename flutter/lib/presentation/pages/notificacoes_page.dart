import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/notificacao_dto.dart';
import '../../data/services/notificacao_service.dart';
import '../../data/services/chat_service.dart';
import '../../core/constants/storage_keys.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/common/bottom_navigation_achados.dart';

/// Página de notificações do sistema
class NotificacoesPage extends StatefulWidget {
  final UsuarioDTO? usuarioLogado;

  const NotificacoesPage({super.key, required this.usuarioLogado});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  late String _nomeUsuario;
  late String _iniciaisUsuario;
  bool _isLoading = true;
  List<NotificacaoDTO> _notificacoes = [];
  final NotificacaoService _notificacaoService = NotificacaoService();
  final ChatService _chatService = ChatService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _carregarNotificacoes();
    _configurarOneSignal();
  }

  void _initializeUserData() {
    if (widget.usuarioLogado != null) {
      _nomeUsuario = widget.usuarioLogado!.nome;
      final nomes = widget.usuarioLogado!.nome.split(' ');
      if (nomes.length > 1) {
        _iniciaisUsuario = nomes[0][0] + nomes[1][0];
      } else {
        _iniciaisUsuario = nomes[0].substring(0, nomes[0].length > 1 ? 2 : 1);
      }
      _iniciaisUsuario = _iniciaisUsuario.toUpperCase();
    } else {
      _nomeUsuario = 'Usuário';
      _iniciaisUsuario = 'U';
    }
  }

  /// Configura listeners do OneSignal para receber notificações em tempo real
  /// As notificações são gerenciadas globalmente no main.dart
  /// Quando uma notificação é clicada, ela é adicionada à lista aqui
  void _configurarOneSignal() {
    try {
      // O listener de clique já está configurado no main.dart
      // Quando uma notificação é clicada, podemos adicioná-la à lista
      // Por enquanto, as notificações aparecem quando o usuário clica nelas
      print('✅ OneSignal já configurado globalmente no main.dart');
      print('ℹ️ Notificações serão adicionadas quando o usuário interagir com elas');
    } catch (e) {
      print('❌ Erro ao configurar OneSignal: $e');
    }
  }

  Future<void> _carregarNotificacoes() async {
    setState(() => _isLoading = true);
    
    try {
      // Buscar userId do storage
      _userId = await _secureStorage.read(key: StorageKeys.userId);
      
      if (_userId == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _notificacoes = [];
          });
        }
        return;
      }

      // Buscar mensagens não lidas do tipo CHAT
      final mensagensNaoLidas = await _chatService.getUnreadMessages(_userId!);
      
      // Converter mensagens não lidas em notificações
      final notificacoesChat = mensagensNaoLidas.map((mensagem) {
        return NotificacaoDTO.fromChatMessage({
          'id': mensagem.id,
          'menssagem': mensagem.conteudo,
          'data_Hora_Menssagem': mensagem.dataEnvio.toIso8601String(),
          'status': mensagem.lida ? 'LIDA' : 'ENVIADA',
          'tipo': 'CHAT',
          'id_Usuario_Remetente': mensagem.idUsuarioRemetente,
          'id_Usuario_Destino': mensagem.idUsuarioDestino,
          'id_Chat': mensagem.conversaId,
        });
      }).toList();
      
      // As notificações de outros tipos (NOVO_ITEM, REIVINDICACAO, DEVOLUCAO)
      // chegam via OneSignal em tempo real quando ocorrem
      // Por isso, inicializamos com as mensagens não lidas de chat
      
      if (mounted) {
        setState(() {
          _notificacoes = notificacoesChat;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Erro ao carregar notificações: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _notificacoes = [];
        });
        AppSnackBar.showError(context, 'Erro ao carregar notificações');
      }
    }
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inMinutes < 1) {
      return 'Agora';
    } else if (diferenca.inMinutes < 60) {
      return '${diferenca.inMinutes}min atrás';
    } else if (diferenca.inHours < 24) {
      return '${diferenca.inHours}h atrás';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays}d atrás';
    } else {
      return '${data.day}/${data.month}/${data.year}';
    }
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'CHAT':
        return Icons.chat_bubble_outline;
      case 'NOVO_ITEM':
        return Icons.add_circle_outline;
      case 'REIVINDICACAO':
        return Icons.assignment_turned_in;
      case 'DEVOLUCAO':
        return Icons.check_circle_outline;
      case 'SISTEMA':
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColor(String tipo) {
    switch (tipo) {
      case 'CHAT':
        return Colors.green;
      case 'NOVO_ITEM':
        return Colors.blue;
      case 'REIVINDICACAO':
        return Colors.orange;
      case 'DEVOLUCAO':
        return Colors.purple;
      case 'SISTEMA':
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17603A),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                _iniciaisUsuario,
                style: const TextStyle(
                  color: Color(0xFF17603A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Notificações',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_notificacoes.any((n) => !n.lida))
            TextButton(
              onPressed: _marcarTodasComoLidas,
              child: const Text(
                'Marcar todas',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notificacoes.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _carregarNotificacoes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notificacoes.length,
                    itemBuilder: (context, index) {
                      return _buildNotificacaoCard(_notificacoes[index]);
                    },
                  ),
                ),
      bottomNavigationBar: widget.usuarioLogado != null
          ? BottomNavigationAchados(
              usuario: widget.usuarioLogado!,
              currentIndex: 0,
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Você não tem notificações no momento',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificacaoCard(NotificacaoDTO notificacao) {
    final color = _getColor(notificacao.tipo);
    final icon = _getIcon(notificacao.tipo);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notificacao.lida ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _abrirNotificacao(notificacao),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: notificacao.lida ? Colors.white : Colors.blue.shade50,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificacao.titulo ?? 'Notificação',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notificacao.lida
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!notificacao.lida)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notificacao.mensagem,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatarData(notificacao.data),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirNotificacao(NotificacaoDTO notificacao) {
    if (!notificacao.lida && _userId != null) {
      _notificacaoService.marcarComoLida(notificacao.id).then((_) {
        setState(() {
          // Atualizar na lista
          final index = _notificacoes.indexWhere((n) => n.id == notificacao.id);
          if (index != -1) {
            _notificacoes[index].lida = true;
          }
        });
      }).catchError((e) {
        print('❌ Erro ao marcar notificação como lida: $e');
        // Mesmo se falhar, marcar como lida localmente
        setState(() {
          final index = _notificacoes.indexWhere((n) => n.id == notificacao.id);
          if (index != -1) {
            _notificacoes[index].lida = true;
          }
        });
      });
    }

    // Navegar para a página específica baseada no tipo de notificação
    if (notificacao.dadosAdicionais != null) {
      final type = notificacao.dadosAdicionais!['type'] as String?;
      if (type == 'CHAT') {
        final remetenteId = notificacao.dadosAdicionais!['remetenteId']?.toString();
        if (remetenteId != null) {
          // TODO: Navegar para chat
          AppSnackBar.showInfo(context, 'Abrindo chat...');
        }
      } else if (type == 'NOVO_ITEM') {
        final itemId = notificacao.dadosAdicionais!['itemId']?.toString();
        if (itemId != null) {
          // TODO: Navegar para detalhes do item
          AppSnackBar.showInfo(context, 'Abrindo item...');
        }
      }
    }
  }

  void _marcarTodasComoLidas() {
    if (_userId == null) return;
    
    _notificacaoService.marcarTodasComoLidas(_userId!).then((_) {
      setState(() {
        for (var notificacao in _notificacoes) {
          notificacao.lida = true;
        }
      });
      AppSnackBar.showSuccess(context, 'Todas as notificações foram marcadas como lidas');
    }).catchError((e) {
      print('❌ Erro ao marcar notificações como lidas: $e');
      // Mesmo se falhar, marcar como lidas localmente
      setState(() {
        for (var notificacao in _notificacoes) {
          notificacao.lida = true;
        }
      });
      AppSnackBar.showSuccess(context, 'Notificações marcadas como lidas localmente');
    });
  }
}
