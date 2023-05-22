import 'package:flutter/material.dart';
import 'package:nhs/services/ui_service.dart';
import 'package:provider/provider.dart';
import './setting.dart';
import './settings_container.dart';

class Appearance extends StatelessWidget {
  const Appearance({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UIService>(
        builder: (context, uiService, child) => SettingsContainer(
            title: "Appearance",
            child: Column(
              children: [
                Setting(
                  name: "Dark Theme",
                  child: Switch(
                    value: uiService.isDarkMode,
                    onChanged: (value) => uiService.setIsDarkMode(value),
                  ),
                )
              ],
            )));
  }
}
