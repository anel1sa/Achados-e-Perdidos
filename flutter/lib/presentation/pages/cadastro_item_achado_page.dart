import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/services/item_service.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/item_achado_dto.dart';
import '../../core/utils/user_utils.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/common/app_bar_with_menu.dart';
import '../widgets/common/image_grid_picker.dart';
import '../widgets/common/app_bottom_navigation.dart';

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
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Erro ao acessar galeria: $e');
      }
    }
  }

  void _removerImagem() {
    setState(() {
      _imagensSelecionadas.clear();
    });
  }

  void _removerImagemIndividual(int index) {
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
      appBar: AppBarWithMenu(
        usuario: widget.usuarioLogado,
        showBackButton: true,
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
              ImageGridPicker(
                images: _imagensSelecionadas,
                onAddImage: _selecionarImagem,
                onRemoveAll: _removerImagem,
                onRemoveImage: _removerImagemIndividual,
                addButtonText: 'Selecionar Imagens',
              ),
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
      bottomNavigationBar: widget.usuarioLogado != null
          ? AppBottomNavigation(
              usuario: widget.usuarioLogado!,
              currentIndex: 0,
            )
          : null,
    );
  }
}
