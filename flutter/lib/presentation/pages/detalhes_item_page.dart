import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Services
import '../../data/services/item_service.dart';
import '../../data/services/usuario_service.dart';
import '../../data/services/reivindicacao_service.dart';
import '../../data/datasources/reivindicacao_remote_datasource.dart';

// Widgets
import '../widgets/common/bottom_navigation_achados.dart';
import '../widgets/item/item_widgets.dart';
import '../widgets/dialogs/dialogs.dart';

// Models
import '../../data/DTOs/item_dto.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/reivindicacao_dto.dart';

class DetalhesItemPage extends StatefulWidget {
  final ItemDTO item;
  final UsuarioDTO? usuarioLogado;

  const DetalhesItemPage({super.key, required this.item, this.usuarioLogado});

  @override
  State<DetalhesItemPage> createState() => _DetalhesItemPageState();
}

class _DetalhesItemPageState extends State<DetalhesItemPage> {
  late String _nomeUsuario;
  late String _iniciaisUsuario;
  final _reivindicacaoService = ReivindicacaoService(
    ReivindicacaoRemoteDataSource(client: http.Client()),
  );
  bool _jaReivindicou = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuarioLogado != null) {
      _nomeUsuario = widget.usuarioLogado!.nome.split(' ')[0];
      final nomes = widget.usuarioLogado!.nome.split(' ');
      if (nomes.length > 1) {
        _iniciaisUsuario = nomes[0][0] + nomes[1][0];
      } else {
        _iniciaisUsuario = nomes[0].substring(0, nomes[0].length > 1 ? 2 : 1);
      }
      _iniciaisUsuario = _iniciaisUsuario.toUpperCase();
      _verificarReivindicacao();
    } else {
      _nomeUsuario = 'Usuário';
      _iniciaisUsuario = 'U';
    }
  }

  Future<void> _verificarReivindicacao() async {
    if (widget.usuarioLogado == null) return;
    
    setState(() => _isLoading = true);
    try {
      final jaReivindicou = await _reivindicacaoService.usuarioJaReivindicou(
        widget.item.id,
        widget.usuarioLogado!.id,
      );
      if (mounted) {
        setState(() => _jaReivindicou = jaReivindicou);
      }
    } catch (e) {
      // Falha silenciosa, não bloqueia UI
      debugPrint('Erro ao verificar reivindicação: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            Text(
              'Olá, $_nomeUsuario! :)',
              style: const TextStyle(
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white),
            onSelected: (String value) {
              switch (value) {
                case 'perfil':
                  Navigator.pushNamed(
                    context,
                    '/perfil',
                    arguments: widget.usuarioLogado,
                  );
                  break;
                case 'configuracoes':
                  Navigator.pushNamed(
                    context,
                    '/configuracoes',
                    arguments: widget.usuarioLogado,
                  );
                  break;
                case 'ajuda':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ajuda em desenvolvimento')),
                  );
                  break;
                case 'sobre':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sobre nós em desenvolvimento'),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Perfil'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'ajuda',
                child: ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Ajuda'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Sobre nós'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do item
            ItemImageCard(fotos: widget.item.fotos ?? []),
            const SizedBox(height: 24),

            // Nome do item
            Text(
              widget.item.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Descrição
            ItemDetailField(
              label: 'Descrição:',
              value: widget.item.descricao,
              icon: Icons.description,
            ),
            const SizedBox(height: 16),

            // Local encontrado
            ItemDetailField(
              label: 'Encontrado em:',
              value: widget.item.descLocalItem,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 16),

            // Data de cadastro
            ItemDetailField(
              label: 'Data de cadastro:',
              value: widget.item.dtaCriacao != null
                  ? '${widget.item.dtaCriacao!.day}/${widget.item.dtaCriacao!.month}/${widget.item.dtaCriacao!.year}'
                  : 'Não informado',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 32),

            // Botões de Ação
            ReivindicacaoButton(
              jaReivindicou: _jaReivindicou,
              isLoading: _isLoading,
              onPressed: _mostrarFormularioReivindicacao,
            ),
            
            const SizedBox(height: 16),

            ContatoButton(onPressed: _abrirChat),

            const SizedBox(height: 24),

            // Pergunta "Este item é seu?" (mantida para compatibilidade)
            if (!_jaReivindicou && !_isLoading)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Este item é seu?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: TextButton(
                        onPressed: _mostrarFormularioReivindicacao,
                        child: const Text(
                          'Sim',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF17603A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationAchados(
        usuario: widget.usuarioLogado!,
        currentIndex: 0, // Default para Achados
      ),
    );
  }

  void _mostrarFormularioReivindicacao() {
    ReivindicacaoDialog.show(context, _enviarReivindicacao);
  }

  Future<void> _enviarReivindicacao(String descricao) async {
    if (widget.usuarioLogado == null) return;

    setState(() => _isLoading = true);
    try {
      final dto = ReivindicacaoCreateDTO(
        itemId: widget.item.id,
        descricao: descricao.isEmpty ? null : descricao,
      );

      await _reivindicacaoService.create(dto);

      if (mounted) {
        setState(() {
          _jaReivindicou = true;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reivindicação enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar reivindicação: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _abrirChat() {
    if (widget.usuarioLogado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para entrar em contato'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'usuario': widget.usuarioLogado,
        'itemId': widget.item.id,
        'itemNome': widget.item.nome,
      },
    );
  }
}

