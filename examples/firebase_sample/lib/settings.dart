import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_sample/theme.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppTheme>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ListTile(
            title: Text('Theme Mode'),
            subtitle: Text('Click on the icon to change the theme of your app!'),
            trailing: theme.themeMode == ThemeMode.light
                ? IconButton(
                    icon: Icon(Icons.light_mode_rounded),
                    onPressed: () {
                      theme.themeMode = ThemeMode.dark;
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.dark_mode_rounded),
                    onPressed: () {
                      theme.themeMode = ThemeMode.light;
                    },
                  ),
          )
        ],
      ),
    );
  }
}
