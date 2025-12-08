import 'package:flutter/material.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../core/config/app_settings_controller.dart';

class ConfiguracoesPage extends StatefulWidget {
  final UsuarioDTO? usuarioLogado;

  const ConfiguracoesPage({super.key, required this.usuarioLogado});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late String _nomeUsuario;
  late String _iniciaisUsuario;

  @override
  void initState() {
    super.initState();
    if (widget.usuarioLogado != null) {
      _nomeUsuario = widget.usuarioLogado!.nome;
      final nomes = widget.usuarioLogado!.nome.split(' ');
      if (nomes.length > 1) {
        _iniciaisUsuario = nomes[0][0] + nomes[1][0];
      } else {
        _iniciaisUsuario = nomes[0].substring(0, nomes[0].length > 1 ? 2 : 1);
      }
      _iniciaisUsuario = _iniciaisUsuario.toUpperCase();
    } else {
      _nomeUsuario = 'Usuário';
      _iniciaisUsuario = 'U';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.scaffoldBackgroundColor,
              child: Text(
                _iniciaisUsuario,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Olá, ${_nomeUsuario.split(' ')[0]}! :)',
              style: TextStyle(
                color: theme.appBarTheme.foregroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Ícone de notificações
          IconButton(
            icon: Icon(
              Icons.notifications_outlined, 
              color: theme.appBarTheme.foregroundColor,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/notificacoes',
                arguments: widget.usuarioLogado,
              );
            },
            tooltip: 'Notificações',
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.settings, 
              color: theme.appBarTheme.foregroundColor,
            ),
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 50),
            onSelected: (String value) {
              switch (value) {
                case 'perfil':
                  Navigator.pushNamed(
                    context,
                    '/perfil',
                    arguments: widget.usuarioLogado,
                  );
                  break;
                case 'configuracoes':
                  // Já estamos na página de configurações
                  break;
                case 'ajuda':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ajuda em desenvolvimento')),
                  );
                  break;
                case 'sobre':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sobre nós em desenvolvimento'),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Perfil'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'ajuda',
                child: ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Ajuda'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Sobre nós'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da página
            Text(
              'Configurações',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 30),

            // Seção Configurações do app
            _buildSectionHeader('Configurações do app', context),
            const SizedBox(height: 16),
            _buildSettingRow(
              'Modo escuro',
              settings.isDarkMode ? 'Ativado' : 'Desativado',
              Icons.dark_mode,
              () => _showModoEscuroDialog(settings),
            ),
            _buildSettingRow(
              'Tamanho da fonte',
              '${settings.fontSize}',
              Icons.text_fields,
              () => _showTamanhoFonteDialog(settings),
            ),
            _buildSettingRow(
              'Idioma',
              settings.languageLabel,
              Icons.language,
              () => _showIdiomaDialog(settings),
            ),

            const SizedBox(height: 30),

            // Seção Notificações
            _buildSectionHeader('Notificações', context),
            const SizedBox(height: 16),
            _buildSwitchRow('Ativar notificações', settings.notificationsEnabled, (
              value,
            ) {
              settings.toggleNotifications(value);
            }),
            _buildSwitchRow('Chat', settings.chatNotificationsEnabled, (value) {
              settings.toggleChatNotifications(value);
            }, enabled: settings.notificationsEnabled),
            _buildSwitchRow('Novos itens', settings.newItemsNotificationsEnabled,
                (value) {
              settings.toggleNewItemsNotifications(value);
            }, enabled: settings.notificationsEnabled),
            _buildSwitchRow(
              'Atualização de item',
              settings.updatesNotificationsEnabled,
              (value) {
                settings.toggleUpdatesNotifications(value);
              },
              enabled: settings.notificationsEnabled,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // Índice válido
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacementNamed(
                '/achados',
                arguments: widget.usuarioLogado,
              );
            } else if (index == 1) {
              Navigator.of(context).pushReplacementNamed(
                '/perdidos',
                arguments: widget.usuarioLogado,
              );
            } else if (index == 2) {
              Navigator.of(
                context,
              ).pushReplacementNamed('/chat', arguments: widget.usuarioLogado);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Achados"),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: "Perdidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "Chat",
            ),
          ],
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        ),
      ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildSettingRow(
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rowColor = isDark
        ? theme.colorScheme.surfaceVariant
        : theme.colorScheme.primary;
    final textColor = isDark
        ? theme.colorScheme.onSurfaceVariant
        : Colors.white;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14, 
                  color: textColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor.withOpacity(0.8),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rowColor = isDark
        ? theme.colorScheme.surfaceVariant
        : theme.colorScheme.primary;
    final textColor = isDark
        ? theme.colorScheme.onSurfaceVariant
        : Colors.white;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: enabled 
                    ? textColor 
                    : textColor.withOpacity(0.6),
              ),
            ),
            const Spacer(),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              thumbColor: WidgetStateProperty.all(
                isDark 
                    ? theme.colorScheme.primary
                    : Colors.white,
              ),
              activeTrackColor: isDark
                  ? theme.colorScheme.primary.withOpacity(0.5)
                  : Colors.white.withValues(alpha: 0.3),
              inactiveThumbColor: isDark
                  ? theme.colorScheme.onSurfaceVariant
                  : Colors.white70,
              inactiveTrackColor: isDark
                  ? theme.colorScheme.surface
                  : Colors.white.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  void _showModoEscuroDialog(AppSettingsController settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final currentMode = settings.themeModeString;
        return AlertDialog(
          title: const Text('Tema do aplicativo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Row(
                  children: [
                    Icon(Icons.light_mode, size: 20),
                    SizedBox(width: 8),
                    Text('Claro'),
                  ],
                ),
                value: 'light',
                groupValue: currentMode,
                onChanged: (String? value) {
                  if (value != null) {
                    settings.setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Row(
                  children: [
                    Icon(Icons.dark_mode, size: 20),
                    SizedBox(width: 8),
                    Text('Escuro'),
                  ],
                ),
                value: 'dark',
                groupValue: currentMode,
                onChanged: (String? value) {
                  if (value != null) {
                    settings.setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Row(
                  children: [
                    Icon(Icons.brightness_auto, size: 20),
                    SizedBox(width: 8),
                    Text('Seguir sistema'),
                  ],
                ),
                value: 'system',
                groupValue: currentMode,
                onChanged: (String? value) {
                  if (value != null) {
                    settings.setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTamanhoFonteDialog(AppSettingsController settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tamanho da fonte'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [14, 16, 18, 20, 22, 24].map((size) {
              return RadioListTile<int>(
                title: Text('$size'),
                value: size,
                groupValue: settings.fontSize,
                onChanged: (int? value) {
                  if (value != null) {
                    settings.updateFontSize(value);
                  }
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showIdiomaDialog(AppSettingsController settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              {'label': 'Português', 'code': 'pt'},
              {'label': 'English', 'code': 'en'},
              {'label': 'Español', 'code': 'es'},
            ].map((idioma) {
              return RadioListTile<String>(
                title: Text(idioma['label']!),
                value: idioma['code']!,
                groupValue: settings.languageCode,
                onChanged: (String? value) {
                  if (value != null) {
                    settings.updateLanguage(value);
                  }
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

