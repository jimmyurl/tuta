import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/ui/lessons_screen.dart';
import 'package:tutor/ui/search_screen.dart';
import 'package:tutor/ui/video_upload_screen.dart';
import 'package:tutor/ui/profile_screen.dart';
import 'package:tutor/ui/subscription_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tutor/ui/onboarding_screen.dart';
import 'package:tutor/services/auth_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xfihpvkbzppaejluyqoq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmaWhwdmtienBwYWVqbHV5cW9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg1NDQzMzgsImV4cCI6MjA0NDEyMDMzOH0.U30_ovXdjGrovUZhBeVbeXtX-Xg29BPNZF9mhz7USfM',
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedLanguage = prefs.getString('selectedLanguage');
  bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

  runApp(MeetYourTutorApp(
    storedLanguage: storedLanguage,
    onboardingComplete: onboardingComplete,
  ));
}

class MeetYourTutorApp extends StatefulWidget {
  final String? storedLanguage;
  final bool onboardingComplete;

  const MeetYourTutorApp({
    Key? key,
    this.storedLanguage,
    required this.onboardingComplete,
  }) : super(key: key);

  @override
  _MeetYourTutorAppState createState() => _MeetYourTutorAppState();
}

class _MeetYourTutorAppState extends State<MeetYourTutorApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.storedLanguage != null
        ? Locale(widget.storedLanguage!)
        : const Locale('en');
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MeetYourTutor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('sw', 'TZ'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: widget.onboardingComplete
          ? HomeScreen()
          : OnboardingScreen(setLocale: setLocale),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();

  final List<Widget> _screens = [
    LessonsScreen(),
    SearchScreen(),
    VideoUploadScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Upload screen index
      final user = await _authService.getCurrentUser();
      if (user != null) {
        final isSubscribed = await _authService.isUserSubscribed(user.id);
        if (!isSubscribed) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SubscriptionPage()),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to upload lessons')),
        );
        return;
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/search.png')),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/upload.png')),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/profile.png')),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
