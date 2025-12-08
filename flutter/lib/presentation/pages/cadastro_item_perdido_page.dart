import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/services/item_service.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/item_perdido_dto.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/common/app_bar_with_menu.dart';
import '../widgets/common/image_grid_picker.dart';
import '../widgets/common/app_bottom_navigation.dart';

class CadastroItemPerdidoPage extends StatefulWidget {
  final UsuarioDTO? usuarioLogado;

  const CadastroItemPerdidoPage({super.key, this.usuarioLogado});

  @override
  State<CadastroItemPerdidoPage> createState() =>
      _CadastroItemPerdidoPageState();
}

class _CadastroItemPerdidoPageState extends State<CadastroItemPerdidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemService = ItemService();
  final _nomeItemController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _localController = TextEditingController(); // Campo de texto livre para o local

  bool _isLoading = false;
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
        AppSnackBar.showError(context, 'Informe onde você perdeu o item');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // API espera apenas: nome, descricao, descLocalItem
      // usuarioRelatorId é extraído do JWT pelo controller
      final dto = ItemPerdidoCreateDTO(
        nome: _nomeItemController.text.trim(),
        descricao: _descricaoController.text.trim(),
        descLocalItem: descLocalItem,
      );
      
      // Se houver fotos, envia junto com o item via multipart/form-data
      // Se não houver fotos, envia apenas JSON
      final fotoPaths = _imagensSelecionadas.isNotEmpty
          ? _imagensSelecionadas.map((f) => f.path).toList()
          : null;
      
      final itemCriado = await _itemService.createItemPerdido(
        dto,
        fotoPaths: fotoPaths,
      );

      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      AppSnackBar.showSuccess(context, 'Item perdido cadastrado com sucesso!');
      Navigator.pop(context, true); // Retorna true para indicar sucesso
      
    } catch (e) {
      print('Erro ao cadastrar item: $e');
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      AppSnackBar.showError(context, 'Erro ao cadastrar item perdido. Tente novamente.');
    }
  }

  Widget _buildLocalTextField() {
    return _buildTextField(
      label: 'Onde você perdeu? *',
      controller: _localController,
      maxLines: 2,
      isRequired: true,
      hint: 'Ex: Bloco azul, sala 101',
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
              _buildTextField(
                label: 'O que você perdeu?',
                controller: _nomeItemController,
              ),
              _buildTextField(
                label: 'Descreva o item perdido:',
                controller: _descricaoController,
              ),
              _buildLocalTextField(),
              const SizedBox(height: 8),
              const Text(
                'Você tem uma imagem do item perdido? (Opcional)',
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
              currentIndex: 1,
            )
          : null,
    );
  }
}



