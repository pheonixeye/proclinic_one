import 'package:flutter/material.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/language_btn.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Settings'),
                subtitle: const Divider(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('App Language'),
                    trailing: const LanguageBtn(),
                    subtitle: const Divider(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
