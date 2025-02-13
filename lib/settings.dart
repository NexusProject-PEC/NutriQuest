import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart'; // For handling language settings
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load settings from SharedPreferences
  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

  // Save settings to SharedPreferences
  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark_mode', _isDarkMode);
    prefs.setString('language', _selectedLanguage);
  }

  // Switch between Dark and Light Mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _saveSettings();
  }

  // Change the language preference
  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      locale: Locale(_selectedLanguage),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'ES'), // Add more languages here
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: SettingsPage(
        isDarkMode: _isDarkMode,
        selectedLanguage: _selectedLanguage,
        onLanguageChanged: _changeLanguage,
        onDarkModeChanged: _toggleDarkMode,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final String selectedLanguage;
  final Function(bool) onDarkModeChanged;
  final Function(String) onLanguageChanged;

  const SettingsPage({super.key, 
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.onDarkModeChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark Mode Switch
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkMode,
              onChanged: onDarkModeChanged,
            ),
            Divider(),

            // Language Preferences Section
            ListTile(
              title: Text('Language'),
              subtitle: Text(_getLanguageName(selectedLanguage)),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            Divider(),

            // Notification Switch (example)
            SwitchListTile(
              title: Text('Notifications'),
              value: true, // Implement notification logic here
              onChanged: (bool value) {
                // Implement notification logic here
              },
            ),
            Divider(),

            // Terms and Policy Section
            ListTile(
              title: Text('Terms and Privacy Policy'),
              onTap: () {
                _showTermsAndPolicy(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Language Dialog for changing language preferences
  _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  onLanguageChanged('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Español'),
                onTap: () {
                  onLanguageChanged('es');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to get language name based on selected language code
  String _getLanguageName(String languageCode) {
    if (languageCode == 'es') {
      return 'Español';
    }
    return 'English';
  }

  // Terms and Privacy Policy
  _showTermsAndPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms & Privacy Policy'),
          content: Text('Here are the terms and privacy policy content...'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
