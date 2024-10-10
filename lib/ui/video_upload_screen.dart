import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  String? _selectedFolder;
  String? _fileName;
  File? _videoFile;

  // Method to handle file selection
  Future<void> selectVideo() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      setState(() {
        _videoFile = File(pickedFile.files.first.path!);
        _fileName = pickedFile.files.first.name;
      });
    }
  }

  // Method to handle file upload
  Future<void> uploadVideo() async {
    if (_videoFile == null || _selectedFolder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a video and a folder.")),
      );
      return;
    }

    try {
      // Upload video to Supabase storage
      final response = await supabase.storage
          .from('videos/$_selectedFolder')
          .upload(_fileName!, _videoFile!);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Video uploaded successfully!")),
        );
      } else {
        throw Exception("Upload failed.");
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Video"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting folder
            DropdownButton<String>(
              value: _selectedFolder,
              hint: Text("Select Folder"),
              items: [
                DropdownMenuItem(
                    value: 'educational', child: Text("Educational")),
                DropdownMenuItem(value: 'personal', child: Text("Personal")),
                DropdownMenuItem(value: 'cuisine', child: Text("Cuisine")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFolder = value;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Text field for filename
            TextField(
              decoration: InputDecoration(
                labelText: "File Name",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _fileName = value;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Button to select video file
            ElevatedButton(
              onPressed: selectVideo,
              child: Text("Select Video"),
            ),
            SizedBox(height: 16.0),

            // Upload button
            ElevatedButton(
              onPressed: uploadVideo,
              child: Text("Upload Video"),
            ),
          ],
        ),
      ),
    );
  }
}
