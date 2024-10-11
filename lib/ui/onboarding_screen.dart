import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/l10n/app_localizations.dart';
import 'package:tutor/ui/lessons_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const OnboardingScreen({Key? key, required this.setLocale}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _selectedLanguage = 'en';

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    Locale newLocale = Locale(languageCode);
    widget.setLocale(newLocale);

    // Save the selected language in SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('selectedLanguage', languageCode);
    });
  }

  Future<void> _proceedToLessons() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LessonsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.welcomeMessage ??
                  'Welcome to the Lessons App!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.selectLanguage ?? 'Select Language',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _changeLanguage('en'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedLanguage == 'en' ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      Text(AppLocalizations.of(context)?.english ?? 'English'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _changeLanguage('sw'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedLanguage == 'sw' ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      Text(AppLocalizations.of(context)?.swahili ?? 'Swahili'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _proceedToLessons,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)?.proceed ??
                  'Proceed to Lessons'),
            ),
          ],
        ),
      ),
    );
  }
}
