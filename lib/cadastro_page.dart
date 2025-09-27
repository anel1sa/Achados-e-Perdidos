import 'package:flutter/material.dart';
import 'services/usuario_service.dart';

/// Widget reutilizável para campos de texto do cadastro
class _CadastroTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isObscured;
  final String? errorText;
  final TextInputType keyboardType;

  const _CadastroTextField({
    required this.label,
    required this.icon,
    required this.controller,
    this.isObscured = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  static const double fieldWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fieldWidth,
      child: TextFormField(
        controller: controller,
        obscureText: isObscured,
        keyboardType: keyboardType,
        validator: _validateField,
        decoration: _buildInputDecoration(),
      ),
    );
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      errorText: errorText,
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Constants
  static const Color _primaryColor = Color(0xFF17603A);
  static const double _buttonWidth = 220.0;
  static const double _buttonHeight = 44.0;

  // Form and controllers
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _campusController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();

  // Services and state
  final UsuarioService _usuarioService = UsuarioService();
  bool _isLoading = false;
  bool _showValidationError = false;
  List<CampusModel> _campi = [];
  int? _campusIdSelecionado;
  Map<String, String?> _errosValidacao = {};
  OverlayEntry? _campusMenuEntry;

  @override
  void initState() {
    super.initState();
    _carregarCampi();
  }

  Future<void> _carregarCampi() async {
    try {
      final campi = await _usuarioService.getCampi();
      setState(() {
        _campi = campi;
      });
    } catch (e) {
      print('Erro ao carregar campi: $e');
    }
  }

  @override
  void dispose() {
    _campusMenuEntry?.remove();
    _nomeController.dispose();
    _emailController.dispose();
    _matriculaController.dispose();
    _campusController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _tentarCadastrar() async {
    _fecharMenuCampus();

    if (!_validarFormulario()) return;

    _setLoadingState(true);

    try {
      final novoUsuario = _criarUsuarioModel();
      final resposta = await _usuarioService.cadastrarUsuario(novoUsuario);

      _setLoadingState(false);

      if (resposta['sucesso']) {
        await _handleCadastroSucesso(resposta['mensagem']);
      } else {
        _handleCadastroErro(resposta);
      }
    } catch (e) {
      _setLoadingState(false);
      _showErrorSnackBar('Erro ao cadastrar: $e');
    }
  }

  void _fecharMenuCampus() {
    _campusMenuEntry?.remove();
  }

  bool _validarFormulario() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final isCampusSelected = _campusIdSelecionado != null;

    setState(() {
      _showValidationError = !isFormValid || !isCampusSelected;
      if (!isCampusSelected) {
        _errosValidacao['campus'] = 'Selecione um campus';
      }
    });

    return isFormValid && isCampusSelected;
  }

  void _setLoadingState(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  UsuarioModel _criarUsuarioModel() {
    return UsuarioModel(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      matricula: _matriculaController.text.trim(),
      campusId: _campusIdSelecionado!,
      telefone: _telefoneController.text.trim(),
      senha: _senhaController.text,
    );
  }

  Future<void> _handleCadastroSucesso(String mensagem) async {
    _showSuccessSnackBar(mensagem);
    Navigator.pop(context);
  }

  void _handleCadastroErro(Map<String, dynamic> resposta) {
    setState(() {
      _errosValidacao = resposta['erros'] ?? {};
      _showValidationError = true;
    });
    _showErrorSnackBar(resposta['mensagem']);
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_showValidationError)
                          const Padding(
                            padding: EdgeInsets.only(top: 34.00, bottom: 4.0),
                            child: Text(
                              'Preencha todos os campos obrigatórios!',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 50.0,
                            bottom: 8.0,
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/logo.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Faça seu cadastro',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _CadastroTextField(
                          label: 'Nome completo',
                          icon: Icons.person_outline,
                          controller: _nomeController,
                          errorText: _errosValidacao['nome'],
                        ),
                        const SizedBox(height: 12),
                        _CadastroTextField(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          controller: _emailController,
                          errorText: _errosValidacao['email'],
                        ),
                        const SizedBox(height: 12),
                        _CadastroTextField(
                          label: 'Matrícula',
                          icon: Icons.badge_outlined,
                          controller: _matriculaController,
                          errorText: _errosValidacao['matricula'],
                        ),
                        const SizedBox(height: 12),
                        // Campo de seleção de campus como input, menu customizado ancorado
                        SizedBox(
                          width: 240,
                          child: Builder(
                            builder: (context) {
                              final layerLink = LayerLink();
                              final fieldKey = GlobalKey<FormFieldState>();
                              return CompositedTransformTarget(
                                link: layerLink,
                                child: GestureDetector(
                                  onTap: () async {
                                    final renderBox =
                                        fieldKey.currentContext
                                                ?.findRenderObject()
                                            as RenderBox?;
                                    if (renderBox == null) return;
                                    final position = renderBox.localToGlobal(
                                      Offset.zero,
                                    );
                                    final overlay = Overlay.of(context);
                                    if (_campusMenuEntry != null) {
                                      _campusMenuEntry?.remove();
                                      _campusMenuEntry = null;
                                      return;
                                    }
                                    _campusMenuEntry = OverlayEntry(
                                      builder: (context) {
                                        return Stack(
                                          children: [
                                            Positioned.fill(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _campusMenuEntry?.remove();
                                                  _campusMenuEntry = null;
                                                },
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                child: Container(),
                                              ),
                                            ),
                                            Positioned(
                                              left: position.dx,
                                              top:
                                                  position.dy +
                                                  renderBox.size.height +
                                                  4,
                                              width: renderBox.size.width,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                        maxHeight: 220,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF17603A,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 8,
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    children: _campi.map((
                                                      campus,
                                                    ) {
                                                      return ListTile(
                                                        leading: const Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Colors.white,
                                                          size: 22,
                                                        ),
                                                        title: Text(
                                                          campus.nome,
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                              ),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            _campusIdSelecionado =
                                                                campus.id;
                                                            _errosValidacao
                                                                .remove(
                                                                  'campus',
                                                                );
                                                          });
                                                          fieldKey.currentState
                                                              ?.validate();
                                                          _campusMenuEntry
                                                              ?.remove();
                                                          _campusMenuEntry =
                                                              null;
                                                        },
                                                        selected:
                                                            _campusIdSelecionado ==
                                                            campus.id,
                                                        selectedTileColor:
                                                            const Color(
                                                              0x2217603A,
                                                            ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    overlay.insert(_campusMenuEntry!);
                                  },
                                  child: AbsorbPointer(
                                    child: FormField<int>(
                                      key: fieldKey,
                                      validator: (value) {
                                        if (_campusIdSelecionado == null ||
                                            _campusIdSelecionado == 0) {
                                          return 'Selecione um campus';
                                        }
                                        return null;
                                      },
                                      builder: (state) {
                                        final hasError = state.hasError;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InputDecorator(
                                              isEmpty:
                                                  _campusIdSelecionado ==
                                                      null ||
                                                  _campusIdSelecionado == 0,
                                              decoration: InputDecoration(
                                                labelText: '',
                                                prefixIcon: const Icon(
                                                  Icons.location_city_outlined,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16,
                                                    ),
                                                errorText: hasError
                                                    ? state.errorText
                                                    : null,
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      borderSide:
                                                          const BorderSide(
                                                            color: Colors.red,
                                                            width: 2,
                                                          ),
                                                    ),
                                              ),
                                              child: Text(
                                                _campi
                                                        .firstWhere(
                                                          (c) =>
                                                              c.id ==
                                                              _campusIdSelecionado,
                                                          orElse: () =>
                                                              CampusModel(
                                                                id: 0,
                                                                nome: '',
                                                                endereco: '',
                                                                cidade: '',
                                                                estado: '',
                                                                cep: '',
                                                                ativo: true,
                                                              ),
                                                        )
                                                        .nome
                                                        .isNotEmpty
                                                    ? _campi
                                                          .firstWhere(
                                                            (c) =>
                                                                c.id ==
                                                                _campusIdSelecionado,
                                                            orElse: () =>
                                                                CampusModel(
                                                                  id: 0,
                                                                  nome: '',
                                                                  endereco: '',
                                                                  cidade: '',
                                                                  estado: '',
                                                                  cep: '',
                                                                  ativo: true,
                                                                ),
                                                          )
                                                          .nome
                                                    : 'Selecione um campus',
                                                style: TextStyle(
                                                  color:
                                                      (_campusIdSelecionado ==
                                                              null ||
                                                          _campusIdSelecionado ==
                                                              0)
                                                      ? Colors.grey
                                                      : Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if (hasError)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 12,
                                                  top: 4,
                                                ),
                                                child: Text(
                                                  state.errorText ?? '',
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        _CadastroTextField(
                          label: 'Telefone',
                          icon: Icons.phone_outlined,
                          controller: _telefoneController,
                          keyboardType: TextInputType.phone,
                          errorText: _errosValidacao['telefone'],
                        ),
                        const SizedBox(height: 12),
                        _CadastroTextField(
                          label: 'Senha',
                          icon: Icons.lock_outline,
                          isObscured: true,
                          controller: _senhaController,
                          errorText: _errosValidacao['senha'],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: _buttonWidth,
                          height: _buttonHeight,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _tentarCadastrar,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cadastrar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 240,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Já possuo conta',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
