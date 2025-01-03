import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/ui/feed_screen.dart';  // Add this import
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
    url: 'your-supabase-url',
    anonKey:
        'your-anon-key',
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
      title: 'KizaziHakika',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Enable Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
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
          ? const HomeScreen()
          : OnboardingScreen(setLocale: setLocale),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();

  final List<Widget> _screens = [
    const FeedScreen(),  
     SearchScreen(),
     VideoUploadScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) { 
      final user = await _authService.getCurrentUser();
      if (user != null) {
        final isSubscribed = await _authService.isUserSubscribed(user.id);
        if (!isSubscribed) {
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SubscriptionPage()),
          );
          return;
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to upload lessons')),
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
      body: IndexedStack(  
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(  
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: ImageIcon(const AssetImage('assets/icons/home.png')),
            label: 'Home',
          ),
          NavigationDestination(
            icon: ImageIcon(const AssetImage('assets/icons/search.png')),
            label: 'Search',
          ),
          NavigationDestination(
            icon: ImageIcon(const AssetImage('assets/icons/upload.png')),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: ImageIcon(const AssetImage('assets/icons/profile.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}