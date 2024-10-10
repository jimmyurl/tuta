import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor/ui/lessons_screen.dart';
import 'package:tutor/ui/search_screen.dart'; // Import the SearchScreen
import 'package:tutor/ui/video_upload_screen.dart'; // Import the VideoUploadScreen
import 'package:tutor/ui/profile_screen.dart'; // Import the ProfileScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Supabase.initialize(
    url:
        'https://xfihpvkbzppaejluyqoq.supabase.co', // Replace with your Supabase URL
    anonKey: 'your_anon_key', // Replace with your Supabase anon key
  );
  runApp(MeetYourTutorApp());
}

class MeetYourTutorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MeetYourTutor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Start with HomeScreen
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected tab

  final List<Widget> _screens = [
    LessonsScreen(), // Your existing LessonsScreen
    SearchScreen(), // New SearchScreen
    VideoUploadScreen(), // New VideoUploadScreen
    ProfileScreen(), // New ProfileScreen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
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
        currentIndex: _selectedIndex, // Highlight the current tab
        onTap: _onItemTapped, // Handle tap on tab
        backgroundColor: Colors
            .white, // Set the background color to white or any color that contrasts with your app
        selectedItemColor: Colors.blue, // Set color for the selected item
        unselectedItemColor: Colors.grey, // Set color for unselected items
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
      ),
    );
  }
}
