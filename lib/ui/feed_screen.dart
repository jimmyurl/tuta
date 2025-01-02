import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Map<String, dynamic>> allLessons = [];
  bool isLoading = true;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _fetchAllLessons();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _fetchAllLessons() async {
    final client = Supabase.instance.client;
    setState(() => isLoading = true);

    try {
      // Fetch from all lesson tables and combine the results
      final tables = [
        'educational_lessons',
        'personal_development_lessons',
        'cuisine_lessons',
        'health_lessons'
      ];

      List<Map<String, dynamic>> combinedLessons = [];

      for (String table in tables) {
        final response = await client
            .from(table)
            .select('*, created_at')
            .order('created_at', ascending: false);

        if (response != null) {
          final lessons = (response as List<dynamic>).map((lesson) => {
                'video_urls': lesson['video_urls'] is String
                    ? (lesson['video_urls'] as String).split(',')
                    : lesson['video_urls'] as List<dynamic>,
                'title': lesson['title'] as String,
                'description': lesson['description'] as String,
                'category': table.replaceAll('_lessons', '').toUpperCase(),
                'created_at': DateTime.parse(lesson['created_at']),
              }).toList();

          combinedLessons.addAll(lessons);
        }
      }

      // Sort all lessons by created_at
      combinedLessons.sort((a, b) =>
          (b['created_at'] as DateTime).compareTo(a['created_at'] as DateTime));

      setState(() {
        allLessons = combinedLessons;
        isLoading = false;
      });
    } catch (err) {
      print('Error fetching lessons: $err');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching lessons: $err'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _playVideo(String videoUrl) {
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: 16 / 9,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Chewie(controller: _chewieController!),
          ),
        );
      },
    ).then((_) {
      _videoPlayerController!.pause();
      _videoPlayerController!.dispose();
      _chewieController!.dispose();
    });
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson) {
    String videoUrl = (lesson['video_urls'] as List).isNotEmpty
        ? lesson['video_urls'][0]
        : 'https://via.placeholder.com/150';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Video thumbnail
          AspectRatio(
            aspectRatio: 16 / 9,
            child: GestureDetector(
              onTap: () => _playVideo(videoUrl),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: _buildVideoThumbnail(videoUrl),
              ),
            ),
          ),
          // Lesson details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category chip
                Chip(
                  label: Text(
                    lesson['category'],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: Colors.blue,
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  lesson['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  lesson['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      'assets/icons/love.png',
                      () => _toggleFavorite(lesson),
                    ),
                    _buildActionButton(
                      'assets/icons/share.png',
                      () => _shareLesson(lesson),
                    ),
                    _buildActionButton(
                      'assets/icons/download.png',
                      () => _downloadLesson(lesson),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String iconPath, VoidCallback onPressed) {
    return IconButton(
      icon: Image.asset(
        iconPath,
        height: 24,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildVideoThumbnail(String videoUrl) {
    return FutureBuilder<String?>(
      future: _generateThumbnail(videoUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(snapshot.data!),
                fit: BoxFit.cover,
              ),
              Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 50,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          );
        }
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<String?> _generateThumbnail(String videoUrl) async {
    try {
      return await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  void _toggleFavorite(Map<String, dynamic> lesson) {
    // TODO: Implement favorite functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to favorites: ${lesson['title']}')),
    );
  }

  void _shareLesson(Map<String, dynamic> lesson) {
    Share.share('Check out this lesson: ${lesson['title']}');
  }

  Future<void> _downloadLesson(Map<String, dynamic> lesson) async {
    final dio = Dio();
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${lesson['title']}.mp4';
    final savePath = '${appDir.path}/$fileName';

    try {
      await dio.download(lesson['video_urls'][0], savePath);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to your device: $fileName')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/tuta.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAllLessons,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAllLessons,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : allLessons.isEmpty
                ? const Center(child: Text('No lessons available'))
                : ListView.builder(
                    itemCount: allLessons.length,
                    itemBuilder: (context, index) =>
                        _buildLessonCard(allLessons[index]),
                  ),
      ),
    );
  }
}