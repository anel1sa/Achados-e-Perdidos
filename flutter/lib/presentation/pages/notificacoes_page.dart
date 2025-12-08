import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/notificacao_dto.dart';
import '../../data/services/notificacao_service.dart';
import '../../data/services/chat_service.dart';
import '../../data/services/usuario_service.dart';
import '../../core/constants/storage_keys.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/common/bottom_navigation_achados.dart';
import 'chat_page.dart';

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
  final UsuarioService _usuarioService = UsuarioService();
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
      // Filtrar apenas mensagens realmente não lidas
      final notificacoesChat = mensagensNaoLidas
          .where((mensagem) => !mensagem.lida) // Garantir que apenas não lidas sejam incluídas
          .map((mensagem) {
        // Adicionar dados adicionais para navegação
        final dadosAdicionais = {
          'type': 'CHAT',
          'remetenteId': mensagem.idUsuarioRemetente.toString(),
          'chatId': mensagem.conversaId,
        };
        
        return NotificacaoDTO.fromChatMessage({
          'id': mensagem.id,
          'menssagem': mensagem.conteudo,
          'data_Hora_Menssagem': mensagem.dataEnvio.toIso8601String(),
          'status': 'ENVIADA', // Sempre ENVIADA pois já filtramos apenas não lidas
          'tipo': 'CHAT',
          'id_Usuario_Remetente': mensagem.idUsuarioRemetente,
          'id_Usuario_Destino': mensagem.idUsuarioDestino,
          'id_Chat': mensagem.conversaId,
          'dadosAdicionais': dadosAdicionais,
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                _iniciaisUsuario,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Notificações',
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_notificacoes.any((n) => !n.lida))
            TextButton(
              onPressed: _marcarTodasComoLidas,
              child: Text(
                'Marcar todas',
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
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
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
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
            color: notificacao.lida 
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primaryContainer,
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
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (!notificacao.lida)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatarData(notificacao.data),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
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
          // Remover notificação da lista após marcar como lida
          _notificacoes.removeWhere((n) => n.id == notificacao.id);
        });
        // Recarregar lista para sincronizar com backend
        _carregarNotificacoes();
      }).catchError((e) {
        print('❌ Erro ao marcar notificação como lida: $e');
        // Mesmo se falhar, remover da lista localmente
        setState(() {
          _notificacoes.removeWhere((n) => n.id == notificacao.id);
        });
      });
    }

    // Navegar para a página específica baseada no tipo de notificação
    if (notificacao.dadosAdicionais != null) {
      final type = notificacao.dadosAdicionais!['type'] as String?;
      if (type == 'CHAT') {
        _abrirChat(notificacao);
      } else if (type == 'NOVO_ITEM') {
        final itemId = notificacao.dadosAdicionais!['itemId']?.toString();
        if (itemId != null) {
          // TODO: Navegar para detalhes do item
          AppSnackBar.showInfo(context, 'Abrindo item...');
        }
      }
    } else if (notificacao.tipo == 'CHAT') {
      // Se não tiver dados adicionais mas for tipo CHAT, tentar extrair do ID
      _abrirChat(notificacao);
    }
  }

  Future<void> _abrirChat(NotificacaoDTO notificacao) async {
    if (_userId == null || widget.usuarioLogado == null) return;
    
    try {
      // Extrair remetente ID dos dados adicionais ou da notificação
      String? remetenteId;
      String? chatId;
      
      if (notificacao.dadosAdicionais != null) {
        remetenteId = notificacao.dadosAdicionais!['remetenteId']?.toString();
        chatId = notificacao.dadosAdicionais!['chatId']?.toString();
      }
      
      // Se não tiver remetenteId, tentar extrair do ID da mensagem
      if (remetenteId == null) {
        // A notificação pode ter o remetente no ID ou precisamos buscar
        AppSnackBar.showError(context, 'Não foi possível identificar o remetente');
        return;
      }
      
      // Buscar informações do remetente
      final remetente = await _usuarioService.getUsuarioById(int.parse(remetenteId));
      
      // Gerar iniciais
      final nomes = remetente.nome.split(' ').where((n) => n.isNotEmpty).toList();
      String iniciais;
      if (nomes.isEmpty) {
        iniciais = 'U';
      } else if (nomes.length > 1) {
        iniciais = (nomes[0][0] + nomes[1][0]).toUpperCase();
      } else {
        final nome = nomes[0];
        iniciais = nome.substring(0, nome.length > 1 ? 2 : 1).toUpperCase();
      }
      
      // Criar ConversaInfo
      final conversaInfo = ConversaInfo(
        userId: remetenteId,
        nome: remetente.nome,
        iniciais: iniciais,
        ultimaMensagem: notificacao.mensagem,
        horario: _formatarData(notificacao.data),
        naoLidas: 0, // Já será marcada como lida
      );
      
      // Navegar para o chat
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualChatPage(
              conversaInfo: conversaInfo,
              usuarioLogado: widget.usuarioLogado,
              currentUserId: _userId!,
            ),
          ),
        ).then((_) {
          // Recarregar notificações ao voltar
          _carregarNotificacoes();
        });
      }
    } catch (e) {
      print('❌ Erro ao abrir chat: $e');
      if (mounted) {
        AppSnackBar.showError(context, 'Erro ao abrir conversa');
      }
    }
  }

  void _marcarTodasComoLidas() {
    if (_userId == null) return;
    
    _notificacaoService.marcarTodasComoLidas(_userId!).then((_) {
      // Recarregar lista para remover notificações lidas
      _carregarNotificacoes();
      AppSnackBar.showSuccess(context, 'Todas as notificações foram marcadas como lidas');
    }).catchError((e) {
      print('❌ Erro ao marcar notificações como lidas: $e');
      // Mesmo se falhar, limpar lista localmente
      setState(() {
        _notificacoes.clear();
      });
      AppSnackBar.showSuccess(context, 'Notificações marcadas como lidas localmente');
    });
  }
}
