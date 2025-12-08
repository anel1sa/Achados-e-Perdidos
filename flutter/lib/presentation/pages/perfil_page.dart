import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/item_dto.dart';
import '../../data/services/item_service.dart';
import '../widgets/app_snackbar.dart';

class PerfilPage extends StatefulWidget {
  final UsuarioDTO? usuarioLogado;

  const PerfilPage({super.key, required this.usuarioLogado});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late String _nomeUsuario;
  late String _iniciaisUsuario;
  late String _matricula;
  late String _email;
  late String _campus;
  late String _telefone;
  late String _senha;

  // Variáveis para edição
  File? _imagemPerfil;
  final ImagePicker _picker = ImagePicker();
  bool _isEditingMode = false;
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Gerenciamento de posts
  final ItemService _itemService = ItemService();
  List<ItemDTO> _meusPosts = [];
  bool _loadingPosts = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuarioLogado != null) {
      _nomeUsuario = widget.usuarioLogado!.nome;
      final nomes = widget.usuarioLogado!.nome.split(' ');
      if (nomes.length > 1) {
        _iniciaisUsuario = nomes[0][0] + nomes[1][0];
      } else {
        _iniciaisUsuario = nomes[0].substring(0, nomes[0].length > 1 ? 2 : 1);
      }
      _iniciaisUsuario = _iniciaisUsuario.toUpperCase();
      _matricula = widget.usuarioLogado!.matricula ?? '';
      _email = widget.usuarioLogado!.email;
      _campus = "Colombo"; // Valor padrão baseado na imagem
      _telefone = "+12 34 95678910"; // Valor padrão baseado na imagem
      _senha = ''; // Senha não vem no DTO por segurança
    } else {
      _nomeUsuario = 'Ciclaininho de Souza';
      _iniciaisUsuario = 'CS';
      _matricula = '123456789101112';
      _email = 'email@email.com';
      _campus = 'Colombo';
      _telefone = '+12 34 95678910';
      _senha = '123456';
    }

    // Inicializar controllers
    _telefoneController.text = _telefone;
    _senhaController.text = _senha;

    // Carregar posts do usuário
    _carregarMeusPosts();
  }

  Future<void> _carregarMeusPosts() async {
    final userId = widget.usuarioLogado?.id;
    if (userId == null) return;

    setState(() {
      _loadingPosts = true;
    });

    try {
      final posts = await _itemService.getItensByUser(userId);
      // Filtrar apenas itens ativos (não deletados)
      final postsAtivos = posts.where((post) => !post.flgInativo).toList();
      setState(() {
        _meusPosts = postsAtivos;
        _loadingPosts = false;
      });
    } catch (e) {
      print('Erro ao carregar posts: $e');
      setState(() {
        _loadingPosts = false;
      });
      if (mounted) {
        AppSnackBar.showError(context, 'Erro ao carregar seus posts');
      }
    }
  }

  Future<void> _editarPost(ItemDTO item) async {
    // TODO: Navegar para página de edição
    // Por enquanto, mostra um dialog simples
    final nomeController = TextEditingController(text: item.nome);
    final descricaoController = TextEditingController(text: item.descricao);
    final localController = TextEditingController(text: item.descLocalItem);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: localController,
                decoration: const InputDecoration(
                  labelText: 'Local',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF17603A),
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        setState(() {
          _loadingPosts = true;
        });

        final updateDTO = ItemUpdateDTO(
          nome: nomeController.text.trim(),
          descricao: descricaoController.text.trim(),
          descLocalItem: localController.text.trim(),
        );

        await _itemService.updateItem(item.id, updateDTO);
        
        if (mounted) {
          AppSnackBar.showSuccess(context, 'Post atualizado com sucesso!');
          _carregarMeusPosts(); // Recarregar lista
        }
      } catch (e) {
        print('Erro ao atualizar post: $e');
        if (mounted) {
          AppSnackBar.showError(context, 'Erro ao atualizar post');
          setState(() {
            _loadingPosts = false;
          });
        }
      }
    }
  }

  Future<void> _excluirPost(ItemDTO item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir o post "${item.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        setState(() {
          _loadingPosts = true;
        });

        await _itemService.deleteItem(item.id);
        
        if (mounted) {
          AppSnackBar.showSuccess(context, 'Post excluído com sucesso!');
          _carregarMeusPosts(); // Recarregar lista
        }
      } catch (e) {
        print('Erro ao excluir post: $e');
        if (mounted) {
          AppSnackBar.showError(context, 'Erro ao excluir post');
          setState(() {
            _loadingPosts = false;
          });
        }
      }
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  void dispose() {
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagemPerfil() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  _escolherImagem(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  _escolherImagem(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              if (_imagemPerfil != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remover foto'),
                  onTap: () {
                    setState(() {
                      _imagemPerfil = null;
                    });
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _escolherImagem(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagemPerfil = File(pickedFile.path);
      });
    }
  }

  void _salvarTelefone() {
    setState(() {
      _telefone = _telefoneController.text;
      _isEditingMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Telefone atualizado com sucesso!')),
    );
  }

  void _salvarSenha() {
    setState(() {
      _senha = _senhaController.text;
      _isEditingMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha atualizada com sucesso!')),
    );
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
              'Olá, ${_nomeUsuario.split(' ')[0]}! :)',
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
          // Ícone de notificações
          IconButton(
            icon: Icon(
              Icons.notifications_outlined, 
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/notificacoes',
                arguments: widget.usuarioLogado,
              );
            },
            tooltip: 'Notificações',
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.settings, 
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 50),
            onSelected: (String value) {
              switch (value) {
                case 'perfil':
                  // Já estamos na página de perfil
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
        child: Column(
          children: [
            // Seção do perfil com fundo verde
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF17603A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  // Avatar do usuário
                  GestureDetector(
                    onTap: _selecionarImagemPerfil,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 56,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: ClipOval(
                              child: _imagemPerfil != null
                                  ? Image.file(
                                      _imagemPerfil!,
                                      width: 112,
                                      height: 112,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 112,
                                      height: 112,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFFF6B9D),
                                            Color(0xFFC44569),
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF17603A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nome do usuário
                  Text(
                    _nomeUsuario,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Seção de dados pessoais
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título com ícone de edição
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dados pessoais',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditingMode ? Icons.check : Icons.edit,
                          color: const Color(0xFF17603A),
                          size: 20,
                        ),
                        onPressed: () {
                          if (_isEditingMode) {
                            // Salvar alterações
                            _salvarTelefone();
                            _salvarSenha();
                          } else {
                            // Entrar em modo de edição
                            setState(() {
                              _isEditingMode = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Lista de dados pessoais
                  _buildDataRow('Nome', _nomeUsuario),
                  _buildDataRow('Matrícula', _matricula),
                  _buildDataRow('Email', _email),
                  _buildDataRow('Campus', _campus),
                  _buildEditableField(
                    'Telefone',
                    _telefone,
                    _telefoneController,
                    false,
                  ),
                  _buildEditableField('Senha', _senha, _senhaController, true),
                  const SizedBox(height: 40),
                  // Seção de gerenciamento de posts
                  _buildGerenciamentoPosts(),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // Índice válido, mas sem destacar visualmente
          backgroundColor: const Color(0xFF17603A),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacementNamed(
                '/achados',
                arguments: widget.usuarioLogado,
              );
            } else if (index == 1) {
              Navigator.of(context).pushReplacementNamed(
                '/perdidos',
                arguments: widget.usuarioLogado,
              );
            } else if (index == 2) {
              Navigator.of(
                context,
              ).pushReplacementNamed('/chat', arguments: widget.usuarioLogado);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Achados"),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: "Perdidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "Chat",
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    bool isPassword = label == 'Senha';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Value
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isPassword
                    ? const Color(0xFF17603A)
                    : const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    String value,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Value or TextField
          Expanded(
            child: _isEditingMode
                ? TextField(
                    controller: controller,
                    obscureText: isPassword,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF333333),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF17603A)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF17603A),
                          width: 2,
                        ),
                      ),
                    ),
                  )
                : Text(
                    isPassword ? '••••••••••••' : value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isPassword
                          ? const Color(0xFF17603A)
                          : const Color(0xFF333333),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGerenciamentoPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meus Posts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        if (_loadingPosts)
          const Center(child: CircularProgressIndicator())
        else if (_meusPosts.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Você ainda não criou nenhum post',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ..._meusPosts.map((post) => _buildPostCard(post)),
      ],
    );
  }

  Widget _buildPostCard(ItemDTO post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.descricao ?? 'Sem descrição',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatarData(post.dtaCriacao),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: post.tipoItem == TipoItem.PERDIDO
                                  ? Colors.orange.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.tipoItem == TipoItem.PERDIDO
                                  ? 'Perdido'
                                  : 'Achado',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: post.tipoItem == TipoItem.PERDIDO
                                    ? Colors.orange.shade800
                                    : Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botões de ação
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF17603A)),
                      onPressed: () => _editarPost(post),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _excluirPost(post),
                      tooltip: 'Excluir',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

