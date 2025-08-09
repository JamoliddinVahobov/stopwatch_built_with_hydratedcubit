import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../change_theme/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String privacyPolicyUrl =
      'https://www.termsfeed.com/live/a4e16d9c-469c-4b53-a499-247030170ca8';

  Future<void> launchPrivacyPolicy() async {
    try {
      await launchUrlString(
        privacyPolicyUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch Privacy Policy')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Settings'),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 5),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.dark_mode_rounded,
                size: 27,
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeNotifier.isDarkMode,
                onChanged: (value) {
                  themeNotifier.toggleTheme();
                },
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.policy_rounded,
                size: 27,
              ),
              title: const Text('Privacy Policy'),
              onTap: () {
                launchPrivacyPolicy();
              },
            )
          ],
        ),
      ),
    );
  }
}
