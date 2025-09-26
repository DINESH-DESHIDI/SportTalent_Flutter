import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class VideoUploadPage extends StatefulWidget {
  const VideoUploadPage({super.key});

  @override
  State<VideoUploadPage> createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  VideoPlayerController? _controller;
  bool _loading = false;
  Map<String, dynamic>? _results;

  // Pick a video
  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      _controller?.dispose();

      if (kIsWeb) {
        // Convert picked file to a blob URL for web
        Uint8List? videoBytes = result.files.single.bytes;
        if (videoBytes != null) {
          final blob = html.Blob([videoBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          _controller = VideoPlayerController.network(url);
          await _controller!.initialize();
          _controller!.setLooping(true);
          setState(() {
            _results = null;
          });
        }
      } else {
        // Mobile
        if (result.files.single.path != null) {
          _controller = VideoPlayerController.file(
            File(result.files.single.path!),
          );
          await _controller!.initialize();
          _controller!.setLooping(true);
          setState(() {
            _results = null;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a valid video file.")),
      );
    }
  }

  // Mock submit (simulate API call)
  Future<void> _submitVideo() async {
    if (_controller == null) return;

    setState(() {
      _loading = true;
      _results = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _loading = false;
      _results = {
        "correctReps": 12,
        "wrongForm": 3,
        "suggestion": "Keep your elbows aligned with shoulders",
      };
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(
              children: [
                // Header
                const Text(
                  "Upload / Record Your Performance",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Upload Section
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFDDDDDD),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _pickVideo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            232,
                            177,
                            48,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "Choose a video file",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Video Preview
                      if (_controller != null)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                if (_controller != null)
                  ElevatedButton(
                    onPressed: _loading ? null : _submitVideo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 235, 188, 80),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 5,
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            "Submit for Analysis",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                const SizedBox(height: 28),

                // Results Section
                if (_results != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECF9F1),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AI Analysis Results",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "✅ Correct reps: ${_results!['correctReps']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "❌ Wrong form: ${_results!['wrongForm']} (elbows not aligned)",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "🔮 Suggestion: ${_results!['suggestion']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
