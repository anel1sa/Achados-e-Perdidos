import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Config
import 'core/config/env_config.dart';
import 'core/config/app_settings_controller.dart';

// Pages
import 'presentation/pages/login_page.dart';
import 'presentation/pages/cadastro_page.dart';
import 'presentation/pages/achados_page.dart';
import 'presentation/pages/cadastro_item_achado_page.dart';
import 'presentation/pages/cadastro_item_perdido_page.dart';
import 'presentation/pages/item_achado.dart';
import 'presentation/pages/chat_page.dart';
import 'presentation/pages/perdidos_page.dart';
import 'presentation/pages/perfil_page.dart';
import 'presentation/pages/configuracoes_page.dart';
import 'presentation/pages/notificacoes_page.dart';

// Models
import 'data/DTOs/usuario_dto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = AppSettingsController();
  await settingsController.load();
  await _initializeApplication();

  runApp(MyApp(settingsController: settingsController));
}

/// Inicializa os serviços necessários da aplicação
Future<void> _initializeApplication() async {
  // Carregar variáveis de ambiente
  await EnvConfig.init();
  
  // Validar configuração
  if (!EnvConfig.validate()) {
    throw Exception('❌ Erro: Variáveis de ambiente não configuradas corretamente');
  }
  
  // Inicializar OneSignal para Push Notifications
  await _initializeOneSignal();
  
  print('✅ App inicializado');
  print('📡 API: ${EnvConfig.apiBaseUrl}');
}

/// Inicializa OneSignal para Push Notifications
Future<void> _initializeOneSignal() async {
  try {
    final appId = EnvConfig.oneSignalAppId;
    if (appId.isEmpty) {
      print('⚠️ ONESIGNAL_APP_ID não configurado. Push notifications desabilitadas.');
      return;
    }
    
    // Inicializar OneSignal
    OneSignal.initialize(appId);
    
    // Solicitar permissão de notificações
    OneSignal.Notifications.requestPermission(true);
    
    // Configurar handlers de notificações
    try {
      OneSignal.Notifications.addClickListener((event) {
        print('📬 Notificação clicada: ${event.notification.body}');
        // Aqui você pode navegar para a tela apropriada baseado nos dados da notificação
        if (event.notification.additionalData != null) {
          final data = event.notification.additionalData!;
          final type = data['type'];
          if (type == 'CHAT') {
            // Navegar para chat se necessário
            print('💬 Notificação de chat: ${data['messageId']}');
          }
        }
      });
    } catch (e) {
      print('⚠️ Erro ao configurar listener de notificações: $e');
      // Continuar mesmo se o listener falhar
    }
    
    print('✅ OneSignal inicializado com sucesso');
  } catch (e) {
    print('❌ Erro ao inicializar OneSignal: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController});

  static const String _appTitle = 'Achados e Perdidos';
  static const Color _primaryColor = Colors.green;
  final AppSettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        return AppSettingsScope(
          controller: settingsController,
          child: MaterialApp(
            title: _appTitle,
            theme: _buildAppTheme(Brightness.light),
            darkTheme: _buildAppTheme(Brightness.dark),
            themeMode: settingsController.themeMode,
            locale: settingsController.locale,
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en', 'US'),
              Locale('es', 'ES'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaleFactor: settingsController.textScaleFactor,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            initialRoute: AppRoutes.login,
            routes: _buildRoutes(),
          ),
        );
      },
    );
  }

  ThemeData _buildAppTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: brightness,
      ),
      scaffoldBackgroundColor:
          brightness == Brightness.dark ? Colors.black : Colors.white,
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
      AppRoutes.notificacoes: (context) => _buildNotificacoesPage(context),
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

  Widget _buildNotificacoesPage(BuildContext context) {
    final usuario = _getUsuarioFromRoute(context);
    return NotificacoesPage(usuarioLogado: usuario);
  }

  UsuarioDTO _getUsuarioFromRoute(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
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
  static const String notificacoes = '/notificacoes';
}

