import 'package:flutter/material.dart';
import '../../data/services/usuario_service.dart';
import '../../data/DTOs/campus_dto.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../core/error/exceptions.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

/// Página de Cadastro de novo usuário com abas para Aluno e Servidor
class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage>
    with SingleTickerProviderStateMixin {
  // Constants
  static const double _logoRadius = 60.0;
  static const String _logoAssetPath = 'assets/logo.png';

  // Services
  final UsuarioService _usuarioService = UsuarioService();

  // Tab Controller
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Controllers - Aluno
  final GlobalKey<FormState> _formKeyAluno = GlobalKey<FormState>();
  final TextEditingController _nomeAlunoController = TextEditingController();
  final TextEditingController _emailAlunoController = TextEditingController();
  final TextEditingController _matriculaAlunoController =
      TextEditingController();
  final TextEditingController _telefoneAlunoController =
      TextEditingController();
  final TextEditingController _senhaAlunoController = TextEditingController();
  final TextEditingController _confirmarSenhaAlunoController =
      TextEditingController();

  // Controllers - Servidor
  final GlobalKey<FormState> _formKeyServidor = GlobalKey<FormState>();
  final TextEditingController _nomeServidorController = TextEditingController();
  final TextEditingController _emailServidorController = TextEditingController();
  final TextEditingController _cpfServidorController = TextEditingController();
  final TextEditingController _telefoneServidorController =
      TextEditingController();
  final TextEditingController _senhaServidorController =
      TextEditingController();
  final TextEditingController _confirmarSenhaServidorController =
      TextEditingController();

  // State
  bool _isLoading = false;
  List<CampusDTO> _campi = [];
  int? _campusIdSelecionadoAluno;
  int? _campusIdSelecionadoServidor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _carregarCampi();
  }

  void _onTabChanged() {
    if (_tabController.index != _currentTabIndex) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _nomeAlunoController.dispose();
    _emailAlunoController.dispose();
    _matriculaAlunoController.dispose();
    _telefoneAlunoController.dispose();
    _senhaAlunoController.dispose();
    _confirmarSenhaAlunoController.dispose();
    _nomeServidorController.dispose();
    _emailServidorController.dispose();
    _cpfServidorController.dispose();
    _telefoneServidorController.dispose();
    _senhaServidorController.dispose();
    _confirmarSenhaServidorController.dispose();
    super.dispose();
  }

  Future<void> _carregarCampi() async {
    try {
      final campi = await _usuarioService.getCampi();
      setState(() {
        _campi = campi;
      });
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Erro ao carregar campus: $e');
      }
    }
  }

  /// Realiza o cadastro do aluno
  Future<void> _realizarCadastroAluno() async {
    if (!_formKeyAluno.currentState!.validate()) return;

    if (_campusIdSelecionadoAluno == null) {
      AppSnackBar.showWarning(context, 'Selecione um campus');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Validação adicional da matrícula
      final matricula = _matriculaAlunoController.text.trim();
      if (matricula.isEmpty) {
        AppSnackBar.showError(context, 'A matrícula é obrigatória');
        setState(() => _isLoading = false);
        return;
      }
      
      // Remove zeros à esquerda da matrícula, mas mantém pelo menos um dígito
      final matriculaLimpa = matricula.replaceFirst(RegExp(r'^0+'), '');
      final matriculaFinal = matriculaLimpa.isEmpty ? '0' : matriculaLimpa;
      
      // Limpa o telefone (remove caracteres não numéricos)
      final telefoneLimpo = _telefoneAlunoController.text.trim()
          .replaceAll(RegExp(r'[^\d]'), '');
      
      final novoUsuario = UsuarioCreateDTO(
        nomeCompleto: _nomeAlunoController.text.trim(),
        email: _emailAlunoController.text.trim(),
        senha: _senhaAlunoController.text,
        campusId: _campusIdSelecionadoAluno!,
        matricula: matriculaFinal,
        numeroTelefone: telefoneLimpo.isEmpty ? null : telefoneLimpo,
      );

      final resposta = await _usuarioService.cadastrarAluno(novoUsuario);

      if (mounted) {
        if (resposta['sucesso']) {
          AppSnackBar.showSuccess(
            context,
            resposta['mensagem'] ?? 'Cadastro realizado com sucesso!',
          );
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          AppSnackBar.showError(
            context,
            resposta['mensagem'] ?? 'Erro ao realizar cadastro',
          );
        }
      }
    } on ValidationException catch (e) {
      if (mounted) {
        String mensagem = e.message;
        
        // Detecta email duplicado
        if (mensagem.toLowerCase().contains('email') && 
            (mensagem.toLowerCase().contains('já') || 
             mensagem.toLowerCase().contains('duplicado') ||
             mensagem.toLowerCase().contains('cadastrado'))) {
          mensagem = 'Este email já está cadastrado. Tente fazer login ou use outro email.';
        }
        
        // Se houver erros específicos de campos, adiciona à mensagem
        if (e.errors != null && e.errors!.isNotEmpty) {
          final errosCampos = e.errors!.entries
              .map((entry) => '${entry.key}: ${entry.value}')
              .join('\n');
          mensagem = '$mensagem\n\n$errosCampos';
        }
        
        AppSnackBar.showError(
          context,
          mensagem,
        );
      }
    } on ServerException catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          e.message,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          'Erro ao cadastrar: ${_tratarErroCadastro(e.toString())}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Realiza o cadastro do servidor
  Future<void> _realizarCadastroServidor() async {
    if (!_formKeyServidor.currentState!.validate()) return;

    if (_campusIdSelecionadoServidor == null) {
      AppSnackBar.showWarning(context, 'Selecione um campus');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Validação adicional do CPF
      final cpfLimpo = _cpfServidorController.text.trim()
          .replaceAll(RegExp(r'[^\d]'), '');
      
      if (cpfLimpo.isEmpty || cpfLimpo.length != 11) {
        AppSnackBar.showError(context, 'CPF deve ter exatamente 11 dígitos');
        setState(() => _isLoading = false);
        return;
      }
      
      // Limpa o telefone (remove caracteres não numéricos)
      final telefoneLimpo = _telefoneServidorController.text.trim()
          .replaceAll(RegExp(r'[^\d]'), '');
      
      final novoUsuario = UsuarioCreateDTO(
        nomeCompleto: _nomeServidorController.text.trim(),
        email: _emailServidorController.text.trim(),
        senha: _senhaServidorController.text,
        campusId: _campusIdSelecionadoServidor!,
        cpf: cpfLimpo,
        numeroTelefone: telefoneLimpo.isEmpty ? null : telefoneLimpo,
      );

      final resposta = await _usuarioService.cadastrarServidor(novoUsuario);

      if (mounted) {
        if (resposta['sucesso']) {
          AppSnackBar.showSuccess(
            context,
            resposta['mensagem'] ?? 'Cadastro realizado com sucesso!',
          );
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          AppSnackBar.showError(
            context,
            resposta['mensagem'] ?? 'Erro ao realizar cadastro',
          );
        }
      }
    } on ValidationException catch (e) {
      if (mounted) {
        String mensagem = e.message;
        
        // Detecta email duplicado
        if (mensagem.toLowerCase().contains('email') && 
            (mensagem.toLowerCase().contains('já') || 
             mensagem.toLowerCase().contains('duplicado') ||
             mensagem.toLowerCase().contains('cadastrado'))) {
          mensagem = 'Este email já está cadastrado. Tente fazer login ou use outro email.';
        }
        
        // Se houver erros específicos de campos, adiciona à mensagem
        if (e.errors != null && e.errors!.isNotEmpty) {
          final errosCampos = e.errors!.entries
              .map((entry) => '${entry.key}: ${entry.value}')
              .join('\n');
          mensagem = '$mensagem\n\n$errosCampos';
        }
        
        AppSnackBar.showError(
          context,
          mensagem,
        );
      }
    } on ServerException catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          e.message,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          'Erro ao cadastrar: ${_tratarErroCadastro(e.toString())}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Trata mensagens de erro para exibição amigável
  String _tratarErroCadastro(String erro) {
    if (erro.contains('Email já cadastrado') ||
        erro.contains('email') ||
        erro.contains('409')) {
      return 'Este email já está cadastrado';
    } else if (erro.contains('400')) {
      return 'Dados inválidos. Verifique os campos';
    } else if (erro.contains('timeout') || erro.contains('conexão')) {
      return 'Erro de conexão. Verifique sua internet';
    }
    return 'Erro ao realizar cadastro';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF17603A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF17603A),
          tabs: const [
            Tab(text: 'Aluno'),
            Tab(text: 'Servidor'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLogo(),
            const SizedBox(height: 16),
            _buildTitle(),
            const SizedBox(height: 32),
            IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildFormAluno(),
                _buildFormServidor(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: CircleAvatar(
        radius: _logoRadius,
        child: ClipOval(
          child: Image.asset(
            _logoAssetPath,
            width: _logoRadius * 2,
            height: _logoRadius * 2,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Faça seu cadastro',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  // ========== FORMULÁRIO ALUNO ==========
  Widget _buildFormAluno() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKeyAluno,
        child: Column(
          children: [
            _buildNomeField(_nomeAlunoController),
            const SizedBox(height: 16),
            _buildEmailField(_emailAlunoController),
            const SizedBox(height: 16),
            _buildMatriculaField(),
            const SizedBox(height: 16),
            _buildCampusField(true),
            const SizedBox(height: 16),
            _buildTelefoneField(_telefoneAlunoController),
            const SizedBox(height: 16),
            _buildSenhaField(_senhaAlunoController),
            const SizedBox(height: 16),
            _buildConfirmarSenhaField(
                _confirmarSenhaAlunoController, _senhaAlunoController),
            const SizedBox(height: 24),
            _buildCadastrarButton(_realizarCadastroAluno),
            const SizedBox(height: 16),
            _buildLoginLink(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ========== FORMULÁRIO SERVIDOR ==========
  Widget _buildFormServidor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKeyServidor,
        child: Column(
          children: [
            _buildNomeField(_nomeServidorController),
            const SizedBox(height: 16),
            _buildEmailField(_emailServidorController),
            const SizedBox(height: 16),
            _buildCpfField(),
            const SizedBox(height: 16),
            _buildCampusField(false),
            const SizedBox(height: 16),
            _buildTelefoneField(_telefoneServidorController),
            const SizedBox(height: 16),
            _buildSenhaField(_senhaServidorController),
            const SizedBox(height: 16),
            _buildConfirmarSenhaField(
                _confirmarSenhaServidorController, _senhaServidorController),
            const SizedBox(height: 24),
            _buildCadastrarButton(_realizarCadastroServidor),
            const SizedBox(height: 16),
            _buildLoginLink(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ========== CAMPOS COMUNS ==========
  Widget _buildNomeField(TextEditingController controller) {
    return AppTextField(
      label: 'Nome completo',
      icon: Icons.person_outline,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Digite seu nome completo';
        }
        if (value.trim().length < 3) {
          return 'Nome deve ter pelo menos 3 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(TextEditingController controller) {
    return AppTextField(
      label: 'Email',
      icon: Icons.email_outlined,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Digite seu email';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Email inválido';
        }
        return null;
      },
    );
  }

  Widget _buildMatriculaField() {
    return AppTextField(
      label: 'Matrícula',
      icon: Icons.badge_outlined,
      controller: _matriculaAlunoController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Digite sua matrícula';
        }
        // Remove zeros à esquerda para validar
        final matriculaLimpa = value.trim().replaceFirst(RegExp(r'^0+'), '');
        if (matriculaLimpa.isEmpty) {
          return 'Matrícula inválida';
        }
        if (matriculaLimpa.length < 3) {
          return 'Matrícula deve ter pelo menos 3 dígitos';
        }
        return null;
      },
    );
  }

  Widget _buildCpfField() {
    return AppTextField(
      label: 'CPF',
      icon: Icons.credit_card_outlined,
      controller: _cpfServidorController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Digite seu CPF';
        }
        final cpfLimpo = value.replaceAll(RegExp(r'[^\d]'), '');
        if (cpfLimpo.length != 11) {
          return 'CPF deve ter 11 dígitos';
        }
        return null;
      },
    );
  }

  Widget _buildCampusField(bool isAluno) {
    return SizedBox(
      width: 240.0,
      child: DropdownButtonFormField<int>(
        value: isAluno
            ? _campusIdSelecionadoAluno
            : _campusIdSelecionadoServidor,
        decoration: InputDecoration(
          labelText: 'Campus',
          prefixIcon: const Icon(Icons.location_city, color: Color(0xFF17603A)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF17603A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF17603A), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        dropdownColor: const Color(0xFF17603A),
        style: const TextStyle(color: Colors.black, fontSize: 16),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF17603A)),
        isExpanded: true,
        menuMaxHeight: 220,
        borderRadius: BorderRadius.circular(16),
        items: _campi.map((campus) {
          return DropdownMenuItem<int>(
            value: campus.id,
            child: Text(
              campus.nome,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return _campi.map((campus) {
            return Text(
              campus.nome,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            );
          }).toList();
        },
        onChanged: (value) {
          setState(() {
            if (isAluno) {
              _campusIdSelecionadoAluno = value;
            } else {
              _campusIdSelecionadoServidor = value;
            }
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Selecione um campus';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTelefoneField(TextEditingController controller) {
    return AppTextField(
      label: 'Telefone',
      icon: Icons.phone_outlined,
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildSenhaField(TextEditingController controller) {
    return AppTextField(
      label: 'Senha',
      icon: Icons.lock_outline,
      controller: controller,
      isObscured: true,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Digite uma senha';
        }
        if (value.length < 6) {
          return 'Senha deve ter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmarSenhaField(
      TextEditingController controller, TextEditingController senhaController) {
    return AppTextField(
      label: 'Confirmar senha',
      icon: Icons.lock_outline,
      controller: controller,
      isObscured: true,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) {
        if (_tabController.index == 0) {
          _realizarCadastroAluno();
        } else {
          _realizarCadastroServidor();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirme sua senha';
        }
        if (value != senhaController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
    );
  }

  Widget _buildCadastrarButton(VoidCallback onPressed) {
    return AppButton(
      text: 'Cadastrar',
      onPressed: onPressed,
      isLoading: _isLoading,
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Já possui conta? '),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Fazer login',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
