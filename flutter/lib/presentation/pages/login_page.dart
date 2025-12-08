import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/usuario_service.dart';
import '../../data/services/device_token_service.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/utils/error_utils.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import 'achados_page.dart';
import 'cadastro_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Página de Login com autenticação por email/senha e Google
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Constants
  static const double _logoRadius = 60.0;
  static const String _logoAssetPath = 'assets/logo.png';

  // Services
  final AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();
  final DeviceTokenService _deviceTokenService = DeviceTokenService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  /// Realiza login com email e senha
  Future<void> _realizarLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Faz login e recebe token + dados básicos
      final loginResponse = await _authService.login(
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
      );

      // Salva o token no secure storage
      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: loginResponse.token,
      );
      await _secureStorage.write(
        key: StorageKeys.userId,
        value: loginResponse.userId.toString(),
      );

      // Busca o usuário completo usando o ID
      final usuario = await _usuarioService.getUsuarioById(loginResponse.userId);

      // Registra device token para push notifications
      await _registrarDeviceToken();

      if (mounted) {
        AppSnackBar.showSuccess(context, 'Login realizado com sucesso!');
        _navegarParaPaginaPrincipal(usuario);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          'Erro ao fazer login: ${ErrorUtils.tratarErroLogin(e.toString())}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Realiza login com Google (em desenvolvimento)
  Future<void> _realizarLoginGoogle() async {
    if (mounted) {
      AppSnackBar.showInfo(
        context,
        'Login com Google está em desenvolvimento',
      );
    }
  }

  /// Registra device token para push notifications
  Future<void> _registrarDeviceToken() async {
    try {
      // Obter device token do OneSignal
      final pushSubscription = OneSignal.User.pushSubscription;
      final deviceToken = pushSubscription.id;
      
      if (deviceToken != null && deviceToken.isNotEmpty) {
        // Determinar plataforma
        final plataforma = Theme.of(context).platform == TargetPlatform.android
            ? 'android'
            : 'ios';
        
        // Registrar token no backend
        await _deviceTokenService.registerOrUpdateToken(
          token: deviceToken,
          plataforma: plataforma,
        );
        
        print('✅ Device token registrado com sucesso: $deviceToken');
      } else {
        print('⚠️ Device token não disponível ainda. Tentando novamente...');
        // Aguardar um pouco e tentar novamente
        await Future.delayed(const Duration(seconds: 2));
        final retryToken = pushSubscription.id;
        if (retryToken != null && retryToken.isNotEmpty) {
          final plataforma = Theme.of(context).platform == TargetPlatform.android
              ? 'android'
              : 'ios';
          await _deviceTokenService.registerOrUpdateToken(
            token: retryToken,
            plataforma: plataforma,
          );
          print('✅ Device token registrado após retry: $retryToken');
        } else {
          print('⚠️ Device token ainda não disponível após retry');
        }
      }
    } catch (e) {
      // Não interrompe o fluxo se falhar
      print('⚠️ Erro ao registrar device token: $e');
    }
  }

  /// Navega para a página principal
  void _navegarParaPaginaPrincipal(UsuarioDTO usuario) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AchadosPage(usuarioLogado: usuario),
      ),
    );
  }

  /// Navega para a página de cadastro
  void _navegarParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 16),
                _buildTitle(),
                const SizedBox(height: 32),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 8),
                _buildForgotPasswordLink(),
                const SizedBox(height: 24),
                _buildLoginButton(),
                const SizedBox(height: 16),
                _buildDivider(),
                const SizedBox(height: 16),
                _buildGoogleButton(),
                const SizedBox(height: 16),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return CircleAvatar(
      radius: _logoRadius,
      child: ClipOval(
        child: Image.asset(
          _logoAssetPath,
          width: _logoRadius * 2,
          height: _logoRadius * 2,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final theme = Theme.of(context);
    return Text(
      'Achados e Perdidos',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildEmailField() {
    return AppTextField(
      label: 'Email',
      icon: Icons.email_outlined,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Digite seu email';
        }
        if (!value.contains('@')) {
          return 'Email inválido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      label: 'Senha',
      icon: Icons.lock_outline,
      controller: _senhaController,
      isObscured: true,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _realizarLogin(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Digite sua senha';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordLink() {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 40),
        child: TextButton(
          onPressed: () {
            AppSnackBar.showInfo(
              context,
              'Funcionalidade em desenvolvimento',
            );
          },
          child: Text(
            'Esqueceu a senha?',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AppButton(
      text: 'Entrar',
      onPressed: _realizarLogin,
      isLoading: _isLoading,
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: theme.colorScheme.outline,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OU',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return AppOutlineButton(
      text: 'Entrar com Google',
      onPressed: _realizarLoginGoogle,
      icon: Icons.login,
    );
  }

  Widget _buildSignUpLink() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não possui conta? ',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        TextButton(
          onPressed: _navegarParaCadastro,
          child: Text(
            'Cadastre-se',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

