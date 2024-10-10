import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor/ui/base_scaffold.dart'; // Ensure to import BaseScaffold

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  List<Map<String, dynamic>> educationalLessons = [];
  List<Map<String, dynamic>> personalDevelopmentLessons = [];
  List<Map<String, dynamic>> cuisineLessons = [];

  @override
  void initState() {
    super.initState();
    _fetchEducationalLessons();
    _fetchPersonalDevelopmentLessons();
    _fetchCuisineLessons();
  }

  // Fetching educational lessons data from Supabase
  Future<void> _fetchEducationalLessons() async {
    final client = Supabase.instance.client;

    try {
      final response = await client
          .from('educational_lessons')
          .select('video_urls, title, description')
          .order('id', ascending: true)
          .limit(10);

      if (response != null && response.isNotEmpty) {
        final List<Map<String, dynamic>> data = (response as List<dynamic>)
            .map((lesson) => {
                  'video_urls': lesson['video_urls'] as List<dynamic>,
                  'title': lesson['title'] as String,
                  'description': lesson['description'] as String,
                })
            .toList();

        setState(() {
          educationalLessons = data;
        });
      } else {
        throw 'No data available in the educational lessons table.';
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching educational lessons data: $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // Fetching personal development lessons from Supabase
  Future<void> _fetchPersonalDevelopmentLessons() async {
    final client = Supabase.instance.client;

    try {
      final response = await client
          .from('personal_development_lessons')
          .select('video_urls, title, description')
          .order('id', ascending: true)
          .limit(10);

      if (response != null && response.isNotEmpty) {
        final List<Map<String, dynamic>> data = (response as List<dynamic>)
            .map((lesson) => {
                  'video_urls': lesson['video_urls'] as List<dynamic>,
                  'title': lesson['title'] as String,
                  'description': lesson['description'] as String,
                })
            .toList();

        setState(() {
          personalDevelopmentLessons = data;
        });
      } else {
        throw 'No data available in the personal development lessons table.';
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error fetching personal development lessons data: $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // Fetching cuisine lessons data from Supabase
  Future<void> _fetchCuisineLessons() async {
    final client = Supabase.instance.client;

    try {
      final response = await client
          .from('cuisine_lessons')
          .select('video_urls, title, description')
          .order('id', ascending: true)
          .limit(10);

      if (response != null && response.isNotEmpty) {
        final List<Map<String, dynamic>> data = (response as List<dynamic>)
            .map((lesson) => {
                  'video_urls': lesson['video_urls'] as List<dynamic>,
                  'title': lesson['title'] as String,
                  'description': lesson['description'] as String,
                })
            .toList();

        setState(() {
          cuisineLessons = data;
        });
      } else {
        throw 'No data available in the cuisine lessons table.';
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching cuisine lessons data: $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/tuta.png', // Ensure the path is correct
              fit: BoxFit.contain,
              height: 40, // Adjust height as needed
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 4.0),
            const Text(
              'Educational Lessons',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCarousel(
                educationalLessons, 'No educational lessons available'),
            const SizedBox(height: 10.0),
            const Text(
              'Personal Development Lessons',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCarousel(personalDevelopmentLessons,
                'No personal development lessons available'),
            const SizedBox(height: 10.0),
            const Text(
              'Cuisine Lessons',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCarousel(cuisineLessons, 'No cuisine lessons available'),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  // A method to build the carousel for each category
  Widget _buildCarousel(List<Map<String, dynamic>> data, String emptyMessage) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 4,
      child: Container(
        height: MediaQuery.of(context).size.height *
            0.25, // Adjust height as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                ),
                items: data.isNotEmpty
                    ? data.map((item) {
                        String videoUrl = (item['video_urls'] != null &&
                                (item['video_urls'] as List).isNotEmpty)
                            ? item['video_urls'][0] as String
                            : 'https://via.placeholder.com/150';

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: videoUrl !=
                                          'https://via.placeholder.com/150'
                                      ? _buildVideoThumbnail(videoUrl)
                                      : Image.network(
                                          videoUrl,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 4), // Adjust spacing
                              Text(
                                item['title'] ?? 'No Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2), // Adjust spacing
                              Text(
                                item['description'] ?? 'No Description',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    : [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(child: Text(emptyMessage)),
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to generate a video thumbnail for a given video URL
  Widget _buildVideoThumbnail(String videoUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Placeholder for the video player or thumbnail
        Image.network(
          'https://via.placeholder.com/400x300', // Replace with your video thumbnail logic
          fit: BoxFit.cover,
        ),
        const Icon(
          Icons.play_circle_fill,
          color: Colors.white,
          size: 64,
        ),
      ],
    );
  }
}

class Lesson {
  final String title;
  final String tutorName;
  final String description;
  final String price;
  final List<String> video_urls; // List of video URLs

  Lesson({
    required this.title,
    required this.tutorName,
    required this.description,
    required this.price,
    required this.video_urls,
  });
}
