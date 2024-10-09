import 'package:flutter/material.dart';
import 'lesson_details_screen.dart'; // Import the details screen

class Lesson {
  final String id;
  final String title;
  final String tutorName;
  final String description;
  final double price;

  Lesson({
    required this.id,
    required this.title,
    required this.tutorName,
    required this.description,
    required this.price,
  });
}

class LessonsScreen extends StatelessWidget {
  final List<Lesson> educationalLessons = [
    Lesson(
      id: '1',
      title: 'Introduction to Flutter',
      tutorName: 'John Doe',
      description: 'Learn the basics of Flutter development',
      price: 19.99,
    ),
    Lesson(
      id: '2',
      title: 'Advanced Python Programming',
      tutorName: 'Jane Smith',
      description: 'Master advanced Python concepts',
      price: 24.99,
    ),
  ];

  final List<Lesson> personalDevelopmentLessons = [
    Lesson(
      id: '3',
      title: 'Time Management Skills',
      tutorName: 'Alice Brown',
      description: 'Develop effective time management techniques',
      price: 15.99,
    ),
    Lesson(
      id: '4',
      title: 'Public Speaking Masterclass',
      tutorName: 'Bob Green',
      description: 'Enhance your public speaking abilities',
      price: 22.99,
    ),
  ];

  final List<Lesson> cuisineLessons = [
    Lesson(
      id: '5',
      title: 'Italian Cooking Essentials',
      tutorName: 'Chef Maria',
      description: 'Learn the basics of Italian cuisine',
      price: 30.00,
    ),
    Lesson(
      id: '6',
      title: 'Sushi Making Workshop',
      tutorName: 'Chef Sato',
      description: 'Master the art of sushi making',
      price: 35.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Lessons'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryCarousel(context, 'Educational', educationalLessons),
            _buildCategoryCarousel(
                context, 'Personal Development', personalDevelopmentLessons),
            _buildCategoryCarousel(context, 'Cuisines', cuisineLessons),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCarousel(
      BuildContext context, String categoryTitle, List<Lesson> lessons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            categoryTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200, // Height of the carousel
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return _buildLessonCard(context, lesson);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailsScreen(lesson: lesson),
          ),
        );
      },
      child: Container(
        width: 150, // Width of each card in the carousel
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.title,
                style: TextStyle(fontSize: 16, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text(
                '${lesson.tutorName}',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              SizedBox(height: 10),
              Text(
                '\$${lesson.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
