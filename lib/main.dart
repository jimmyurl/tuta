import 'package:flutter/material.dart';
import 'package:tutor/ui/lessons_screen.dart';

void main() {
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
      home: LessonsScreen(), // Start with LessonsScreen
    );
  }
}
