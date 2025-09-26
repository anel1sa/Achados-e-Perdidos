import 'package:flutter/material.dart';
import 'cadastro_page.dart';
import 'achados_page.dart';
import 'cadastro_item_achado_page.dart';
import 'cadastro_item_perdido_page.dart';
import 'item_achado.dart';
import 'chat_page.dart';
import 'perdidos_page.dart';
import 'perfil_page.dart';
import 'configuracoes_page.dart';
import 'services/usuario_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o arquivo de usuários cadastrados
  final usuarioService = UsuarioService();
  await usuarioService.inicializarUsuariosCadastrados();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achados e Perdidos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/achados': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UsuarioModel?;
          return AchadosPage(usuarioLogado: args!);
        },
        '/perdidos': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UsuarioModel?;
          return PerdidosPage(usuarioLogado: args!);
        },
        '/cadastro-item': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UsuarioModel?;
          return CadastroItemAchadoPage(usuarioLogado: args);
        },
        '/cadastro-item-perdido': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UsuarioModel?;
          return CadastroItemPerdidoPage(usuarioLogado: args);
        },
        '/detalhes-item': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return ItemAchadoPage(
            item: args?['item'],
            usuarioLogado: args?['usuario'],
          );
        },
        '/chat': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UsuarioModel?;
          return ChatPage(usuarioLogado: args);
        },
        '/perfil': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UsuarioModel?;
          return PerfilPage(usuarioLogado: args);
        },
        '/configuracoes': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UsuarioModel?;
          return ConfiguracoesPage(usuarioLogado: args);
        },
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UsuarioService _usuarioService = UsuarioService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _realizarLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text;
      final senha = _senhaController.text;

      if (email.isEmpty || senha.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Por favor, preencha o email e a senha';
        });
        return;
      }

      final usuario = await _usuarioService.login(email, senha);

      setState(() {
        _isLoading = false;
      });

      if (usuario != null) {
        // Login bem-sucedido, navega para a página principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AchadosPage(usuarioLogado: usuario),
          ),
        );
      } else {
        // Login falhou
        setState(() {
          _errorMessage = 'Email ou senha inválidos';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao fazer login: $e';
      });
    }
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
              // Logo centralizado grande
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
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
              const SizedBox(height: 8),
              // Título
              const Text(
                'Achados e Perdidos',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Mensagem de erro
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Campo Usuário
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 4.0,
                ),
                child: SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Campo Senha
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 4.0,
                ),
                child: SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Link Esqueci a senha
              Padding(
                padding: const EdgeInsets.only(right: 50.0, top: 2.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueci a senha',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              // Botão Entrar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8.0,
                ),
                child: SizedBox(
                  width: 240,
                  height: 44,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _realizarLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF17603A),
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
              ),
              // Botão Cadastrar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 4.0,
                ),
                child: SizedBox(
                  width: 240,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CadastroPage()),
                      );
                    },
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
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
