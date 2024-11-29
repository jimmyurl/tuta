import 'package:flutter/material.dart';
import 'lessons_screen.dart'; // Make sure this is the correct import for accessing the Lesson model

class LessonDetailsScreen extends StatelessWidget {
  final Lesson lesson;

  LessonDetailsScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Taught by ${lesson.tutorName}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(lesson.description),
            SizedBox(height: 20),
            Text('Price: ${lesson.price} TZS', style: TextStyle(fontSize: 18)),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Add payment logic here
              },
              child: Text('Subscribe and Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
