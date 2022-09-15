// ignore_for_file: non_constant_identifier_names, dead_code
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

/// Stateful widget to fetch and then display video content.
class RecordingScreen extends StatefulWidget {
  final String videoURL;
  const RecordingScreen({Key? key, required this.videoURL}) : super(key: key);

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends State<RecordingScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // createMeeting();
    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recorded Video',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
