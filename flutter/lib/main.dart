import 'package:flutter/material.dart';

// Pages
import 'cadastro_page.dart';
import 'achados_page.dart';
import 'cadastro_item_achado_page.dart';
import 'cadastro_item_perdido_page.dart';
import 'item_achado.dart';
import 'chat_page.dart';
import 'perdidos_page.dart';
import 'perfil_page.dart';
import 'configuracoes_page.dart';

// Services
import 'services/usuario_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApplication();

  runApp(const MyApp());
}

/// Inicializa os serviços necessários da aplicação
Future<void> _initializeApplication() async {
  final usuarioService = UsuarioService();
  await usuarioService.inicializarUsuariosCadastrados();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _appTitle = 'Achados e Perdidos';
  static const Color _primaryColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: _buildAppTheme(),
      initialRoute: AppRoutes.login,
      routes: _buildRoutes(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.login: (context) => const LoginPage(),
      AppRoutes.achados: (context) => _buildAchadosPage(context),
      AppRoutes.perdidos: (context) => _buildPerdidosPage(context),
      AppRoutes.cadastroItem: (context) => _buildCadastroItemPage(context),
      AppRoutes.cadastroItemPerdido: (context) =>
          _buildCadastroItemPerdidoPage(context),
      AppRoutes.detalhesItem: (context) => _buildDetalhesItemPage(context),
      AppRoutes.chat: (context) => _buildChatPage(context),
      AppRoutes.perfil: (context) => _buildPerfilPage(context),
      AppRoutes.configuracoes: (context) => _buildConfiguracoesPage(context),
    };
  }

  Widget _buildAchadosPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return AchadosPage(usuarioLogado: usuario);
  }

  Widget _buildPerdidosPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return PerdidosPage(usuarioLogado: usuario);
  }

  Widget _buildCadastroItemPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return CadastroItemAchadoPage(usuarioLogado: usuario);
  }

  Widget _buildCadastroItemPerdidoPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return CadastroItemPerdidoPage(usuarioLogado: usuario);
  }

  Widget _buildDetalhesItemPage(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return ItemAchadoPage(item: args?['item'], usuarioLogado: args?['usuario']);
  }

  Widget _buildChatPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return ChatPage(usuarioLogado: usuario);
  }

  Widget _buildPerfilPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return PerfilPage(usuarioLogado: usuario);
  }

  Widget _buildConfiguracoesPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return ConfiguracoesPage(usuarioLogado: usuario);
  }

  UsuarioModel _getUsuarioFromRoute(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as UsuarioModel;
  }
}

/// Classe para centralizar as rotas da aplicação
class AppRoutes {
  static const String login = '/login';
  static const String achados = '/achados';
  static const String perdidos = '/perdidos';
  static const String cadastroItem = '/cadastro-item';
  static const String cadastroItemPerdido = '/cadastro-item-perdido';
  static const String detalhesItem = '/detalhes-item';
  static const String chat = '/chat';
  static const String perfil = '/perfil';
  static const String configuracoes = '/configuracoes';
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Constants
  static const double _logoRadius = 60.0;
  static const double _fieldWidth = 240.0;
  static const double _buttonHeight = 44.0;
  static const String _logoAssetPath = 'assets/logo.png';
  static const Color _primaryButtonColor = Color(0xFF17603A);

  // Services
  final UsuarioService _usuarioService = UsuarioService();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // State
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _realizarLogin() async {
    if (!_validarCampos()) return;

    _setLoadingState(true);

    try {
      final usuario = await _usuarioService.login(
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );

      _setLoadingState(false);

      if (usuario != null) {
        await _navegarParaPaginaPrincipal(usuario);
      } else {
        _setErrorMessage('Email ou senha inválidos');
      }
    } catch (e) {
      _setLoadingState(false);
      _setErrorMessage('Erro ao fazer login: $e');
    }
  }

  bool _validarCampos() {
    if (_emailController.text.trim().isEmpty ||
        _senhaController.text.trim().isEmpty) {
      _setErrorMessage('Por favor, preencha o email e a senha');
      return false;
    }
    return true;
  }

  void _setLoadingState(bool loading) {
    setState(() {
      _isLoading = loading;
      if (loading) _errorMessage = null;
    });
  }

  void _setErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<void> _navegarParaPaginaPrincipal(UsuarioModel usuario) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AchadosPage(usuarioLogado: usuario),
      ),
    );
  }

  void _navegarParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(),
              _buildTitle(),
              const SizedBox(height: 24),
              _buildErrorMessage(),
              _buildEmailField(),
              _buildPasswordField(),
              _buildForgotPasswordLink(),
              _buildLoginButton(),
              _buildRegisterButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      child: CircleAvatar(
        radius: _logoRadius,
        child: ClipOval(
          child: Image.asset(
            _logoAssetPath,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        SizedBox(height: 8),
        Text(
          'Achados e Perdidos',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
      child: SizedBox(
        width: _fieldWidth,
        child: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline),
            hintText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
      child: SizedBox(
        width: _fieldWidth,
        child: TextField(
          controller: _senhaController,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Senha',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0, top: 2.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {}, // TODO: Implementar recuperação de senha
          child: const Text(
            'Esqueci a senha',
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: SizedBox(
        width: _fieldWidth,
        height: _buttonHeight,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: _realizarLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
      child: SizedBox(
        width: _fieldWidth,
        height: _buttonHeight,
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroPage()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryButtonColor,
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
    );
  }
}
