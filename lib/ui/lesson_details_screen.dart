import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'lessons_screen.dart'; // Ensure this is the correct import for accessing the Lesson model

class LessonDetailsScreen extends StatefulWidget {
  final Lesson lesson;

  LessonDetailsScreen({required this.lesson});

  @override
  _LessonDetailsScreenState createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Assuming the lesson has video_urls as a list
    String videoUrl = widget.lesson.video_urls.isNotEmpty
        ? widget.lesson.video_urls[0] // Get the first video URL
        : 'https://via.placeholder.com/400x300'; // Placeholder if no URL is provided

    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI once the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Taught by ${widget.lesson.tutorName}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(widget.lesson.description),
            SizedBox(height: 20),
            // Video Player
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(
                    height: 200, // Placeholder height
                    color: Colors.black,
                    child: Center(child: CircularProgressIndicator()),
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Play or pause the video
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            SizedBox(height: 20),
            Text('Price: ${widget.lesson.price} TZS',
                style: TextStyle(fontSize: 18)),
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
