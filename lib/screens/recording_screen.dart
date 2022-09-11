// ignore_for_file: non_constant_identifier_names, dead_code
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../utils/toast.dart';

/// Stateful widget to fetch and then display video content.
class RecordingScreen extends StatefulWidget {
  final String videoURL;
  const RecordingScreen({Key? key, required this.videoURL}) : super(key: key);

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends State<RecordingScreen> {
  late VideoPlayerController _controller;
  final String _token = "";

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
      title: 'Video Demo',
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

  Future<String> fetchToken() async {
    final String? _AUTH_URL = dotenv.env['AUTH_URL'];
    String? _AUTH_TOKEN = dotenv.env['AUTH_TOKEN'];

    if ((_AUTH_TOKEN?.isEmpty ?? true) && (_AUTH_URL?.isEmpty ?? true)) {
      toastMsg("Please set the environment variables");
      throw Exception("Either AUTH_TOKEN or AUTH_URL is not set in .env file");
      return "";
    }

    if ((_AUTH_TOKEN?.isNotEmpty ?? false) &&
        (_AUTH_URL?.isNotEmpty ?? false)) {
      toastMsg("Please set only one environment variable");
      throw Exception("Either AUTH_TOKEN or AUTH_URL can be set in .env file");
      return "";
    }

    if (_AUTH_URL?.isNotEmpty ?? false) {
      final Uri getTokenUrl = Uri.parse('$_AUTH_URL/get-token');
      final http.Response tokenResponse = await http.get(getTokenUrl);
      _AUTH_TOKEN = json.decode(tokenResponse.body)['token'];
    }

    // log("Auth Token: $_AUTH_TOKEN");

    return _AUTH_TOKEN ?? "";
  }

  Future<String> createMeeting() async {
    // final String? _VIDEOSDK_API_ENDPOINT = dotenv.env['VIDEOSDK_API_ENDPOINT'];
    final String? _VIDEOSDK_API_ENDPOINTV2 =
        dotenv.env['VIDEOSDK_API_ENDPOINTV2'];

    // final Uri getMeetingIdUrl = Uri.parse('$_VIDEOSDK_API_ENDPOINT/meetings');
    final Uri getMeetingIdUrl = Uri.parse('$_VIDEOSDK_API_ENDPOINTV2');
    final http.Response meetingIdResponse =
        await http.get(getMeetingIdUrl, headers: {
      "Authorization": _token,
    });

    final meetingId =
        json.decode(meetingIdResponse.body)['data'][0]['file']['fileUrl'];

    // log(" $meetingId");
    // log("Meeting ID: "{meetingId['id']});
    log("Meeting ID: $meetingId");

    return meetingId;
  }

  Future<bool> validateMeeting(String _meetingId) async {
    final String? _VIDEOSDK_API_ENDPOINT = dotenv.env['VIDEOSDK_API_ENDPOINT'];

    final Uri validateMeetingUrl =
        Uri.parse('$_VIDEOSDK_API_ENDPOINT/meetings/$_meetingId');
    final http.Response validateMeetingResponse =
        await http.post(validateMeetingUrl, headers: {
      "Authorization": _token,
    });

    return validateMeetingResponse.statusCode == 200;
  }
}
