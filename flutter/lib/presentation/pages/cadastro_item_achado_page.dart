import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/services/usuario_service.dart';
import '../../data/services/item_service.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/item_dto.dart';
import '../../data/DTOs/item_achado_dto.dart';
import '../widgets/app_snackbar.dart';

class CadastroItemAchadoPage extends StatefulWidget {
  final UsuarioDTO? usuarioLogado;

  const CadastroItemAchadoPage({super.key, this.usuarioLogado});

  @override
  State<CadastroItemAchadoPage> createState() => _CadastroItemAchadoPageState();
}

class _CadastroItemAchadoPageState extends State<CadastroItemAchadoPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemService = ItemService();
  final _nomeItemController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _localController = TextEditingController(); // Campo de texto livre para o local

  bool _isLoading = false;
  bool _showValidationError = false;
  final List<File> _imagensSelecionadas = [];
  bool _uploading = false;
  double _uploadProgress = 0.0;

  late String _nomeUsuario;
  late String _iniciaisUsuario;

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
    } else {
      _nomeUsuario = 'Usuário';
      _iniciaisUsuario = 'U';
    }
  }

  @override
  void dispose() {
    _nomeItemController.dispose();
    _descricaoController.dispose();
    _localController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        setState(() {
          _imagensSelecionadas.addAll(
            images.map((image) => File(image.path)).toList(),
          );
          _uploading = true;
          _uploadProgress = 0.0;
        });

        // Simula o progresso de upload
        await _simularUpload();
      } else {
        // Usuário cancelou a seleção
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleção de imagem cancelada'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // Erro ao acessar galeria
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao acessar galeria: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _simularUpload() async {
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _uploadProgress = i / 100;
      });
    }
    setState(() {
      _uploading = false;
    });
  }

  Future<void> _removerImagem() async {
    setState(() {
      _imagensSelecionadas.clear();
      _uploading = false;
      _uploadProgress = 0.0;
    });
  }

  Future<void> _removerImagemIndividual(int index) async {
    setState(() {
      _imagensSelecionadas.removeAt(index);
    });
  }


  Future<void> _cadastrarItem() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _showValidationError = true;
      });
      return;
    }

    // Validar se há pelo menos uma imagem (obrigatório para itens achados)
    if (_imagensSelecionadas.isEmpty) {
      if (mounted) {
        AppSnackBar.showWarning(context, 'É obrigatório adicionar pelo menos uma foto do item achado!');
      }
      return;
    }

    if (widget.usuarioLogado?.id == null) {
      if (mounted) {
        AppSnackBar.showError(context, 'Usuário não identificado. Faça login novamente.');
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Validar se local foi preenchido
      final descLocalItem = _localController.text.trim();
      if (descLocalItem.isEmpty) {
        AppSnackBar.showError(context, 'Informe onde você achou o item');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // API espera apenas: nome, descricao, descLocalItem
      // usuarioRelatorId é extraído do JWT pelo controller
      final dto = ItemAchadoCreateDTO(
        nome: _nomeItemController.text.trim(),
        descricao: _descricaoController.text.trim(),
        descLocalItem: descLocalItem,
      );

      // Foto é OBRIGATÓRIA para itens achados (já validado acima)
      final fotoPaths = _imagensSelecionadas.map((f) => f.path).toList();
      
      // Sempre usa multipart/form-data (foto obrigatória)
      final itemCriado = await _itemService.createItemAchado(
        dto,
        fotoPaths: fotoPaths,
      );

      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      AppSnackBar.showSuccess(context, 'Item achado cadastrado com sucesso!');
      Navigator.pop(context, true); // Retorna true para indicar sucesso
      
    } catch (e) {
      print('Erro ao cadastrar item: $e');
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      AppSnackBar.showError(context, 'Erro ao cadastrar item achado. Tente novamente.');
    }
  }

  Widget _buildLocalTextField() {
    return _buildTextField(
      label: 'Onde você achou? *',
      controller: _localController,
      maxLines: 2,
      isRequired: true,
      hint: 'Ex: Ginásio, próximo ao vestiário',
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool isRequired = true,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'Campo obrigatório';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
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
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 50),
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
                  // TODO: Implementar navegação para ajuda
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ajuda em desenvolvimento')),
                  );
                  break;
                case 'sobre':
                  // TODO: Implementar navegação para sobre nós
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sobre nós em desenvolvimento'),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'perfil',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Perfil',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Configurações',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'ajuda',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Ajuda',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Sobre nós',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_showValidationError)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: const Text(
                    'Preencha todos os campos obrigatórios!',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              _buildTextField(
                label: 'O que você achou?',
                controller: _nomeItemController,
              ),
              _buildTextField(
                label: 'Descreva o item achado:',
                controller: _descricaoController,
              ),
              _buildLocalTextField(),
              const SizedBox(height: 8),
              const Text(
                'Você tem uma imagem do item achado? (Obrigatório)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              // Botão de upload (sempre visível)
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _selecionarImagem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF17603A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _imagensSelecionadas.isEmpty
                        ? 'Selecionar Imagens'
                        : 'Adicionar Mais Imagens',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Exibe as imagens selecionadas
              if (_imagensSelecionadas.isNotEmpty) ...[
                Text(
                  '${_imagensSelecionadas.length} imagem(ns) selecionada(s)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),

                // Grid de imagens
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _imagensSelecionadas.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _imagensSelecionadas[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Botão de remover imagem individual
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removerImagemIndividual(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Barra de progresso do upload
                if (_uploading) ...[
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _uploadProgress < 1.0
                                ? Colors.orange
                                : Colors.green,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _uploadProgress < 1.0
                            ? Icons.upload
                            : Icons.check_circle,
                        color: _uploadProgress < 1.0
                            ? Colors.orange
                            : Colors.green,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_uploadProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: _uploadProgress < 1.0
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  // Botão para remover todas as imagens
                  TextButton(
                    onPressed: _removerImagem,
                    child: const Text(
                      'Remover todas as imagens',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _cadastrarItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF17603A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Postar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // Achados tab ativo
          backgroundColor: const Color(0xFF17603A),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(
                  context,
                  '/achados',
                  arguments: widget.usuarioLogado,
                );
                break;
              case 1:
                Navigator.pushReplacementNamed(
                  context,
                  '/perdidos',
                  arguments: widget.usuarioLogado,
                );
                break;
              case 2:
                Navigator.pushReplacementNamed(
                  context,
                  '/chat',
                  arguments: widget.usuarioLogado,
                );
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Achados'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: 'Perdidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
