import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Config
import 'core/config/env_config.dart';
import 'core/config/app_settings_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/cache/cache_service.dart';

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

  // Inicializar cache ANTES de tudo
  await CacheService.init();

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
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
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
              final theme = Theme.of(context);
              return AnimatedTheme(
                data: theme,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaleFactor: settingsController.textScaleFactor,
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            initialRoute: AppRoutes.login,
            routes: _buildRoutes(),
          ),
        );
      },
    );
  }

  // Tema agora vem de AppTheme

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.login: (context) => const LoginPage(),
      AppRoutes.achados: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return AchadosPage(usuarioLogado: usuario);
      },
      AppRoutes.perdidos: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return PerdidosPage(usuarioLogado: usuario);
      },
      AppRoutes.cadastroItem: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return CadastroItemAchadoPage(usuarioLogado: usuario);
      },
      AppRoutes.cadastroItemPerdido: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return CadastroItemPerdidoPage(usuarioLogado: usuario);
      },
      AppRoutes.detalhesItem: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return ItemAchadoPage(item: args?['item'], usuarioLogado: args?['usuario']);
      },
      AppRoutes.chat: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return ChatPage(usuarioLogado: usuario);
      },
      AppRoutes.perfil: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return PerfilPage(usuarioLogado: usuario);
      },
      AppRoutes.configuracoes: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return ConfiguracoesPage(usuarioLogado: usuario);
      },
      AppRoutes.notificacoes: (context) {
        final usuario = ModalRoute.of(context)?.settings.arguments as UsuarioDTO;
        return NotificacoesPage(usuarioLogado: usuario);
      },
    };
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

