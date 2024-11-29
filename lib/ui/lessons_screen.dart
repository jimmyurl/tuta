import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor/ui/base_scaffold.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> educationalLessons = [];
  List<Map<String, dynamic>> personalDevelopmentLessons = [];
  List<Map<String, dynamic>> cuisineLessons = [];
  List<Map<String, dynamic>> healthLessons = [];

  late TabController _tabController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchAllLessons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _fetchAllLessons() async {
    await Future.wait([
      _fetchLessons('educational_lessons',
          (data) => setState(() => educationalLessons = data)),
      _fetchLessons('personal_development_lessons',
          (data) => setState(() => personalDevelopmentLessons = data)),
      _fetchLessons(
          'cuisine_lessons', (data) => setState(() => cuisineLessons = data)),
      _fetchLessons(
          'health_lessons', (data) => setState(() => healthLessons = data)),
    ]);
  }

  Future<void> _fetchLessons(
      String table, Function(List<Map<String, dynamic>>) updateState) async {
    final client = Supabase.instance.client;

    try {
      final response = await client
          .from(table)
          .select('video_urls, title, description')
          .order('id', ascending: true)
          .limit(10);

      if (response != null && response.isNotEmpty) {
        final List<Map<String, dynamic>> data = (response as List<dynamic>)
            .map((lesson) => {
                  'video_urls': lesson['video_urls'] is String
                      ? (lesson['video_urls'] as String).split(',')
                      : lesson['video_urls'] as List<dynamic>,
                  'title': lesson['title'] as String,
                  'description': lesson['description'] as String,
                })
            .toList();

        updateState(data);
        print('Fetched ${data.length} lessons from $table');
      } else {
        print('No data available in the $table table.');
      }
    } catch (err) {
      print('Error fetching $table data: $err');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching $table data: $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
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
    final appDir =
        await getApplicationDocumentsDirectory(); // More permanent than temp directory
    final fileName = '${lesson['title']}.mp4';
    final savePath = '${appDir.path}/$fileName';

    try {
      await dio.download(lesson['video_urls'][0], savePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded to your device: $fileName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
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
              'assets/icons/tuta.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Educational'),
              Tab(text: 'Personal Development'),
              Tab(text: 'Cuisine'),
              Tab(text: 'Health'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCarousel(
              educationalLessons, 'No educational lessons available'),
          _buildCarousel(personalDevelopmentLessons,
              'No personal development lessons available'),
          _buildCarousel(cuisineLessons, 'No cuisine lessons available'),
          _buildCarousel(healthLessons, 'No health lessons available'),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<Map<String, dynamic>> data, String emptyMessage) {
    return ListView(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.7,
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: 16 / 9,
            initialPage: 0,
            enableInfiniteScroll: true,
            padEnds: true,
          ),
          items: data.isNotEmpty
              ? data.map((item) {
                  String videoUrl = (item['video_urls'] != null &&
                          (item['video_urls'] as List).isNotEmpty)
                      ? item['video_urls'][0] as String
                      : 'https://via.placeholder.com/150';

                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () => _playVideo(videoUrl),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: _buildVideoThumbnail(videoUrl),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] ?? 'No Title',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Text(
                                          item['description'] ??
                                              'No Description',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/icons/love.png',
                                              height: 24,
                                            ),
                                            onPressed: () =>
                                                _toggleFavorite(item),
                                          ),
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/icons/share.png',
                                              height: 24,
                                            ),
                                            onPressed: () => _shareLesson(item),
                                          ),
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/icons/download.png',
                                              height: 24,
                                            ),
                                            onPressed: () =>
                                                _downloadLesson(item),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList()
              : [
                  Container(
                    child: Center(child: Text(emptyMessage)),
                  ),
                ],
        ),
      ],
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
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading thumbnail: $error');
                  return _buildPlaceholder();
                },
              ),
              Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () => _playVideo(videoUrl),
                ),
              ),
            ],
          );
        } else {
          return _buildPlaceholder();
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Text(
          'Video Thumbnail Loading...',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Future<String?> _generateThumbnail(String videoUrl) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );
      print('Generated thumbnail for $videoUrl: $thumbnailPath');
      return thumbnailPath;
    } catch (e) {
      print('Error generating thumbnail for $videoUrl: $e');
      return null;
    }
  }
}

class Lesson {
  final String title;
  final String tutorName;
  final String description;
  final String price;
  final List<String> video_urls;

  Lesson({
    required this.title,
    required this.tutorName,
    required this.description,
    required this.price,
    required this.video_urls,
  });
}
