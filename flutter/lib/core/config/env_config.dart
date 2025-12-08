import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Classe para gerenciar variáveis de ambiente
class EnvConfig {
  // Singleton
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  /// Inicializa as variáveis de ambiente
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  // ===================================
  // FIREBASE CONFIGURATION
  // ===================================
  static String get firebaseProjectNumber =>
      dotenv.env['FIREBASE_PROJECT_NUMBER'] ?? '';
  
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  
  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  
  static String get firebaseMobileSdkAppId =>
      dotenv.env['FIREBASE_MOBILESDK_APP_ID'] ?? '';
  
  static String get firebaseAndroidPackageName =>
      dotenv.env['FIREBASE_ANDROID_PACKAGE_NAME'] ?? '';
  
  static String get firebaseApiKey =>
      dotenv.env['FIREBASE_API_KEY'] ?? '';

  // ===================================
  // API CONFIGURATION
  // ===================================
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api-achadosperdidos.com.br';
  
  static String get oneSignalAppId =>
      dotenv.env['ONESIGNAL_APP_ID'] ?? '';

  /// Gera o conteúdo do google-services.json dinamicamente
  static String generateGoogleServicesJson() {
    return '''
{
  "project_info": {
    "project_number": "$firebaseProjectNumber",
    "project_id": "$firebaseProjectId",
    "storage_bucket": "$firebaseStorageBucket"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "$firebaseMobileSdkAppId",
        "android_client_info": {
          "package_name": "$firebaseAndroidPackageName"
        }
      },
      "oauth_client": [],
      "api_key": [
        {
          "current_key": "$firebaseApiKey"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
''';
  }

  /// Valida se todas as variáveis necessárias estão configuradas
  static bool validate() {
    final requiredVars = [
      'FIREBASE_PROJECT_NUMBER',
      'FIREBASE_PROJECT_ID',
      'FIREBASE_STORAGE_BUCKET',
      'FIREBASE_MOBILESDK_APP_ID',
      'FIREBASE_ANDROID_PACKAGE_NAME',
      'FIREBASE_API_KEY',
    ];

    for (final varName in requiredVars) {
      if (dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty) {
        print('⚠️ Variável de ambiente obrigatória não encontrada: $varName');
        return false;
      }
    }

    print('✅ Todas as variáveis de ambiente configuradas corretamente');
    return true;
  }
}
