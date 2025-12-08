import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controla e persiste as preferências de configuração do app.
class AppSettingsController extends ChangeNotifier {
  static const _prefsThemeMode = 'settings.theme_mode'; // 'light', 'dark', 'system'
  static const _prefsFontSize = 'settings.font_size';
  static const _prefsLanguage = 'settings.language';
  static const _prefsNotificationsEnabled = 'settings.notifications.enabled';
  static const _prefsChatNotifications = 'settings.notifications.chat';
  static const _prefsNewItemsNotifications = 'settings.notifications.items';
  static const _prefsUpdatesNotifications = 'settings.notifications.updates';

  String _themeMode = 'system'; // 'light', 'dark', 'system'
  int _fontSize = 18;
  String _languageCode = 'pt';
  bool _notificationsEnabled = true;
  bool _chatNotifications = true;
  bool _newItemsNotifications = true;
  bool _updatesNotifications = true;

  SharedPreferences? _prefs;

  bool get isDarkMode {
    if (_themeMode == 'system') {
      // Retorna baseado no sistema (será tratado pelo ThemeMode.system)
      return false; // Placeholder, o ThemeMode.system cuida disso
    }
    return _themeMode == 'dark';
  }

  ThemeMode get themeMode {
    switch (_themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String get themeModeString => _themeMode;
  int get fontSize => _fontSize;
  double get textScaleFactor => _fontSize / 18;
  Locale get locale => switch (_languageCode) {
        'en' => const Locale('en', 'US'),
        'es' => const Locale('es', 'ES'),
        _ => const Locale('pt', 'BR'),
      };
  String get languageCode => _languageCode;
  String get languageLabel => switch (_languageCode) {
        'en' => 'English',
        'es' => 'Español',
        _ => 'Português',
      };

  bool get notificationsEnabled => _notificationsEnabled;
  bool get chatNotificationsEnabled => _chatNotifications;
  bool get newItemsNotificationsEnabled => _newItemsNotifications;
  bool get updatesNotificationsEnabled => _updatesNotifications;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = _prefs?.getString(_prefsThemeMode) ?? _themeMode;
    _fontSize = _prefs?.getInt(_prefsFontSize) ?? _fontSize;
    _languageCode = _prefs?.getString(_prefsLanguage) ?? _languageCode;
    _notificationsEnabled =
        _prefs?.getBool(_prefsNotificationsEnabled) ?? _notificationsEnabled;
    _chatNotifications =
        _prefs?.getBool(_prefsChatNotifications) ?? _chatNotifications;
    _newItemsNotifications =
        _prefs?.getBool(_prefsNewItemsNotifications) ?? _newItemsNotifications;
    _updatesNotifications =
        _prefs?.getBool(_prefsUpdatesNotifications) ?? _updatesNotifications;

    _enforceNotificationRules();
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    if (mode != 'light' && mode != 'dark' && mode != 'system') {
      return;
    }
    _themeMode = mode;
    await _prefs?.setString(_prefsThemeMode, mode);
    notifyListeners();
  }

  /// Método de compatibilidade para manter código antigo funcionando
  Future<void> toggleDarkMode(bool value) async {
    await setThemeMode(value ? 'dark' : 'light');
  }

  Future<void> updateFontSize(int size) async {
    _fontSize = size;
    await _prefs?.setInt(_prefsFontSize, size);
    notifyListeners();
  }

  Future<void> updateLanguage(String languageCode) async {
    _languageCode = languageCode;
    await _prefs?.setString(_prefsLanguage, languageCode);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefs?.setBool(_prefsNotificationsEnabled, enabled);

    if (!enabled) {
      _chatNotifications = false;
      _newItemsNotifications = false;
      _updatesNotifications = false;

      final prefs = _prefs;
      if (prefs != null) {
        await Future.wait<bool>([
          prefs.setBool(_prefsChatNotifications, _chatNotifications),
          prefs.setBool(_prefsNewItemsNotifications, _newItemsNotifications),
          prefs.setBool(_prefsUpdatesNotifications, _updatesNotifications),
        ]);
      }
    }

    notifyListeners();
  }

  Future<void> toggleChatNotifications(bool enabled) async {
    _chatNotifications = enabled;
    await _prefs?.setBool(_prefsChatNotifications, enabled);
    _enforceNotificationRules();
    notifyListeners();
  }

  Future<void> toggleNewItemsNotifications(bool enabled) async {
    _newItemsNotifications = enabled;
    await _prefs?.setBool(_prefsNewItemsNotifications, enabled);
    _enforceNotificationRules();
    notifyListeners();
  }

  Future<void> toggleUpdatesNotifications(bool enabled) async {
    _updatesNotifications = enabled;
    await _prefs?.setBool(_prefsUpdatesNotifications, enabled);
    _enforceNotificationRules();
    notifyListeners();
  }

  void _enforceNotificationRules() {
    if (!_notificationsEnabled) {
      _chatNotifications = false;
      _newItemsNotifications = false;
      _updatesNotifications = false;
    }
  }
}

/// Exponibiliza o [AppSettingsController] no tree de widgets.
class AppSettingsScope extends InheritedNotifier<AppSettingsController> {
  const AppSettingsScope({
    super.key,
    required AppSettingsController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static AppSettingsController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope não encontrado no contexto');
    return scope!.notifier!;
  }

  @override
  bool updateShouldNotify(AppSettingsScope oldWidget) =>
      notifier != oldWidget.notifier;
}

