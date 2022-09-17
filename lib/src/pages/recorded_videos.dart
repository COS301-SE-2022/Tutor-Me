// ignore_for_file: dead_code, non_constant_identifier_names

import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tutor_me/screens/recording_screen.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import '../../services/models/globals.dart';
import '../../services/models/groups.dart';
import '../../utils/toast.dart';

class RecordedVideos extends StatefulWidget {
  final Groups group;
  final Globals global;
  const RecordedVideos({Key? key, required this.group, required this.global})
      : super(key: key);

  @override
  State<RecordedVideos> createState() => _RecordedVideosState();
}

class _RecordedVideosState extends State<RecordedVideos> {
  List<String> _meetingIdList = List<String>.empty(growable: true);
  List<String> _meetingDateList = List<String>.empty(growable: true);

  int currentIndex = 0;
  // String _token = "";
  int numVideos = 0;

  @override
  void initState() {
    super.initState();
    // fetchToken().then((token) => setState(() => _token = token));
    getRecordings();
  }

  List<Color> colors = [
    // const Color.fromARGB(255, 94, 8, 145),
    const Color.fromARGB(255, 106, 161, 206),
    const Color.fromARGB(255, 106, 155, 42),
    const Color.fromARGB(255, 255, 230, 0),
    const Color.fromARGB(255, 255, 123, 0),
  ];

  getRandomColor() {
    return colors[currentIndex++ % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: colorBlueTeal,
        title: const Center(child: Text('Recorded Videos')),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          // padding: const EdgeInsets.all(10),
          itemCount: numVideos,
          itemBuilder: _cardBuilder,
        ),
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04),
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.015,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: getRandomColor(),
              ),
            ),
            ListTile(
              title: Text(
                'Video' ' ' + (index + 1).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                ),
              ),
              // subtitle: const Text(""),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Date: " +
                    _meetingDateList[index].characters.take(10).toString()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecordingScreen(
                                  videoURL: _meetingIdList[index]
                                  // "https://cdn.videosdk.live/encoded/videos/63161d681d5e14bac5db733a.mp4"
                                  )));
                    },
                    child: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorOrange,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await canLaunchUrlString(_meetingIdList[index])) {
                        await launchUrlString(_meetingIdList[index],
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const Text(
                      'Download',
                      style: TextStyle(color: colorWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
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

    // log("Auth Token here: $_AUTH_TOKEN");
    getRecordings();

    return _AUTH_TOKEN ?? "";
  }

  Future<List<String>> getRecordings() async {
    final String? _AUTH_URL = dotenv.env['AUTH_URL'];
    String? _AUTH_TOKEN = dotenv.env['AUTH_TOKEN'];

    if ((_AUTH_TOKEN?.isEmpty ?? true) && (_AUTH_URL?.isEmpty ?? true)) {
      toastMsg("Please set the environment variables");
      throw Exception("Either AUTH_TOKEN or AUTH_URL is not set in .env file");
      // return "";
    }

    if ((_AUTH_TOKEN?.isNotEmpty ?? false) &&
        (_AUTH_URL?.isNotEmpty ?? false)) {
      toastMsg("Please set only one environment variable");
      throw Exception("Either AUTH_TOKEN or AUTH_URL can be set in .env file");
      // return "";
    }

    if (_AUTH_URL?.isNotEmpty ?? false) {
      final Uri getTokenUrl = Uri.parse('$_AUTH_URL/get-token');
      final http.Response tokenResponse = await http.get(getTokenUrl);
      _AUTH_TOKEN = json.decode(tokenResponse.body)['token'];
    }

    // log("Auth Token here: $_AUTH_TOKEN");

    ///////////////////
    ////
    ////
    //////
    /////
    /////
    ////
    ////
    //////

    // final String? _VIDEOSDK_API_ENDPOINT = dotenv.env['VIDEOSDK_API_ENDPOINT'];
    final String? _VIDEOSDK_API_ENDPOINTV2 =
        dotenv.env['VIDEOSDK_API_ENDPOINTV2'];

    // final Uri getMeetingIdUrl = Uri.parse('$_VIDEOSDK_API_ENDPOINT/meetings');
    final Uri getMeetingIdUrl = Uri.parse('$_VIDEOSDK_API_ENDPOINTV2');
    // log("but   Auth Token here: $_token");
    final http.Response meetingIdResponse = await http
        .get(getMeetingIdUrl, headers: {"Authorization": _AUTH_TOKEN!});

    // final List<String> _meetingIdList = List<String>.empty(growable: true);
    // int length = json.decode(meetingIdResponse.body)['data'].length;

    final getVideoLinks =
        await GroupServices.getVideoLinks(widget.group.getId, widget.global);
    int length = getVideoLinks.length;
    setState(() {
      numVideos = length - 1;
    });
    // log("Length of array: $length");

    //TODO: Check if meetingIdResponse is in group
    for (int i = 0; i < length; i++) {
      // if (getVideoLinks(
      //     )) {
      if (getVideoLinks
          .contains(json.decode(meetingIdResponse.body)['data'][i]['roomId'])) {
        _meetingIdList.add(json.decode(meetingIdResponse.body)['data'][i]
            ['recordingFiles'][0]['url']);
        _meetingDateList.add(json.decode(meetingIdResponse.body)['data'][i]
            ['recordingFiles'][0]['createdAt']);
      }
      _meetingIdList.add(
          json.decode(meetingIdResponse.body)['data'][i]['file']['fileUrl']);
      _meetingDateList
          .add(json.decode(meetingIdResponse.body)['data'][i]['createdAt']);
      // }
    }

    setState(() {
      _meetingIdList = _meetingIdList;
      _meetingDateList = _meetingDateList;
    });
    // final meetingId = json.decode(meetingIdResponse.body)['data'];

    // log("Meeting ID: $meetingId");
    // log("Meeting ID: $_meetingIdList");

    return _meetingIdList;
  }
}
