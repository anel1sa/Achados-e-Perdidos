import 'package:flutter/material.dart';
import 'services/usuario_service.dart';

class _CadastroTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final String? errorText;

  const _CadastroTextField({
    required this.label,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240, //aumenta a largura da box
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          errorText: errorText,
        ),
      ),
    );
  }
}

class CadastroPage extends StatefulWidget {
  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _campusController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();

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
    _campusMenuEntry?.remove();
    setState(() {
      _showValidationError = !_formKey.currentState!.validate();
      _isLoading = !_showValidationError;
    });

    if (_showValidationError) {
      return;
    }

    if (_campusIdSelecionado == null) {
      setState(() {
        _showValidationError = true;
        _errosValidacao['campus'] = 'Selecione um campus';
      });
      return;
    }

    try {
      final novoUsuario = UsuarioModel(
        nome: _nomeController.text,
        email: _emailController.text,
        matricula: _matriculaController.text,
        campusId: _campusIdSelecionado!,
        telefone: _telefoneController.text,
        senha: _senhaController.text,
      );

      final resposta = await _usuarioService.cadastrarUsuario(novoUsuario);

      setState(() {
        _isLoading = false;
      });

      if (resposta['sucesso']) {
        // Exibe mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resposta['mensagem']),
            backgroundColor: Colors.green,
          ),
        );

        // Retorna para a tela de login
        Navigator.pop(context);
      } else {
        // Exibe mensagem de erro
        setState(() {
          _errosValidacao = resposta['erros'] ?? {};
          _showValidationError = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resposta['mensagem']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                                                labelText: 'Campus',
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
                          errorText: _errosValidacao['telefone'],
                        ),
                        const SizedBox(height: 12),
                        _CadastroTextField(
                          label: 'Senha',
                          icon: Icons.lock_outline,
                          obscure: true,
                          controller: _senhaController,
                          errorText: _errosValidacao['senha'],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 220,
                          height: 44,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _tentarCadastrar,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF17603A),
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
