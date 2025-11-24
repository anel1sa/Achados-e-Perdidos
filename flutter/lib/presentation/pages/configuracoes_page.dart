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
            backgroundColor: const Color(0xFF17603A),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                _iniciaisUsuario,
                style: const TextStyle(
                  color: Color(0xFF17603A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Olá, ${_nomeUsuario.split(' ')[0]}! :)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Ícone de notificações
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
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
            icon: const Icon(Icons.settings, color: Colors.white),
            color: Colors.white,
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
          backgroundColor: const Color(0xFF17603A),
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
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF17603A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF17603A),
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
                color: enabled ? Colors.white : Colors.white70,
              ),
            ),
            const Spacer(),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              thumbColor: WidgetStateProperty.all(Colors.white),
              activeTrackColor: Colors.white.withValues(alpha: 0.3),
              inactiveThumbColor: Colors.white70,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
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
        return AlertDialog(
          title: const Text('Modo escuro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<bool>(
                title: const Text('Ativado'),
                value: true,
                groupValue: settings.isDarkMode,
                onChanged: (bool? value) {
                  settings.toggleDarkMode(value ?? false);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<bool>(
                title: const Text('Desativado'),
                value: false,
                groupValue: settings.isDarkMode,
                onChanged: (bool? value) {
                  settings.toggleDarkMode(value ?? false);
                  Navigator.pop(context);
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

