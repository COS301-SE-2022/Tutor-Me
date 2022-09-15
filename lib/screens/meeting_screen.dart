import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:videosdk/rtc.dart';
import '../services/models/globals.dart';
import '../services/models/groups.dart';
// import '../services/services/group_services.dart';
import '../src/authenticate/register_step1.dart';
import '/screens/chat_screen.dart';

import '../../navigator_key.dart';
import '../utils/spacer.dart';
import '../utils/toast.dart';
import '../widgets/meeting_controls/meeting_action_bar.dart';
import '../widgets/participant_grid_view/participant_grid_view.dart';
import 'startup_screen.dart';

import 'package:provider/provider.dart';
import 'package:tutor_me/src/theme/themes.dart';

// Meeting Screen
class MeetingScreen extends StatefulWidget {
  final String meetingId, token, displayName;
  final bool micEnabled, webcamEnabled, chatEnabled;
  final Groups group;
  final Globals globals;
  const MeetingScreen({
    Key? key,
    required this.meetingId,
    required this.token,
    required this.displayName,
    this.micEnabled = true,
    this.webcamEnabled = true,
    this.chatEnabled = true,
    required this.group,
    required this.globals,
  }) : super(key: key);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  // Recording Webhook
  final String recordingWebHookURL = "";

  Meeting? meeting;

  // control states
  bool isRecordingOn = false;
  bool isLiveStreamOn = false;

  // List of controls
  List<MediaDeviceInfo> webcams = [];
  List<MediaDeviceInfo> mics = [];
  String? selectedMicId;

  String? activePresenterId;

  // Streams
  Stream? shareStream;
  Stream? videoStream;
  Stream? audioStream;
  Stream? remoteParticipantShareStream;

  @override
  Widget build(BuildContext context) {
    //Get statusbar height
    final statusbarHeight = MediaQuery.of(context).padding.top;

    log("Meeting Data: ${widget.meetingId} ${widget.token}");
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: MeetingBuilder(
        meetingId: widget.meetingId,
        displayName: widget.displayName,
        token: widget.token,
        micEnabled: widget.micEnabled,
        webcamEnabled: widget.webcamEnabled,
        notification: const NotificationInfo(
          title: "Tutor_Me",
          message: "You are sharing sharing your screen in the meeting",
          icon: "notification_share", // drawable icon name
        ),
        builder: (_meeting) {
          // Called when joined in meeting
          _meeting.on(
            Events.meetingJoined,
            () {
              setState(() {
                meeting = _meeting;
              });

              // Setting meeting event listeners
              setMeetingListeners(_meeting);

              // Holds available webcams info
              webcams = _meeting.getWebcams();

              //terminate after 59 minutes
              Future.delayed(const Duration(minutes: 59), () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Video call sessions with a Tutor are limited to an hour')));
                _meeting.leave();
                goToRegisterOrLogin(context);
              });
            },
          );

          // Showing waiting screen
          if (meeting == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    verticalSpacer(10),
                    const Text("waiting to join meeting"),
                  ],
                ),
              ),
            );
          }

          final provider = Provider.of<ThemeProvider>(context, listen: false);
          Color themeColor;
          if (provider.themeMode == ThemeMode.dark) {
            themeColor = Colors.grey.shade800;
          } else {
            themeColor = Colors.grey.shade100;
          }
          return Scaffold(
            backgroundColor: themeColor,
            floatingActionButton: MeetingActionBar(
              isMicEnabled: audioStream != null,
              isWebcamEnabled: videoStream != null,
              isRecordingOn: isRecordingOn,
              isScreenShareEnabled: shareStream != null,
              isScreenShareButtonDisabled: remoteParticipantShareStream != null,
              // Called when Call End button is pressed
              onCallEndButtonPressed: () {
                _meeting.leave();
                goToRegisterOrLogin(context);
              },
              // Called when mic button is pressed
              onMicButtonPressed: () {
                if (audioStream != null) {
                  _meeting.muteMic();
                } else {
                  _meeting.unmuteMic();
                }
              },
              // Called when webcam button is pressed
              onWebcamButtonPressed: () {
                if (videoStream != null) {
                  _meeting.disableWebcam();
                } else {
                  _meeting.enableWebcam();
                }
              },
              // Called when switch webcam button is pressed
              onSwitchCameraButtonPressed: () {
                final selectedWebcamId = _meeting.selectedWebcamId;

                MediaDeviceInfo deviceToSwitch = webcams.firstWhere(
                  (webcam) => webcam.deviceId != selectedWebcamId,
                );

                _meeting.changeWebcam(deviceToSwitch.deviceId);
              },

              // Called when ScreenShare button is pressed
              onScreenShareButtonPressed: () {
                if (shareStream != null) {
                  _meeting.disableScreenShare();
                } else {
                  _meeting.enableScreenShare();
                }
              },

              // Called when Recording button is pressed
              onRecordingShareButtonPressed: () {
                if (isRecordingOn == true) {
                  _meeting.stopRecording();
                  isRecordingOn = false;
                } else {
                  _meeting.startRecording(recordingWebHookURL);
                  isRecordingOn = true;
                }
              },

              // Called when chat button is pressed
              onMoreButtonPressed: () {
                // Showing chat screen
                showModalBottomSheet(
                  context: context,
                  constraints: BoxConstraints(
                      maxHeight:
                          MediaQuery.of(context).size.height - statusbarHeight),
                  isScrollControlled: true,
                  builder: (context) => ChatScreen(meeting: meeting!),
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              backgroundColor: colorBlueTeal,
              title: Text(widget.meetingId),
              actions: [
                // Recording status
                if (isRecordingOn)
                  SvgPicture.asset("assets/Pictures/recording.png"),

                // Copy meeting id button
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.meetingId));
                    toastMsg("Meeting ID has been copied.");
                  },
                ),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.modulate),
                  image: AssetImage('assets/Pictures/teacher1.png'),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Column(
                children: [
                  if (remoteParticipantShareStream != null ||
                      shareStream != null)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: RTCVideoView(
                          remoteParticipantShareStream != null
                              ? remoteParticipantShareStream!.renderer!
                              : shareStream!.renderer!,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ParticipantGridView(meeting: meeting!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void setMeetingListeners(Meeting meeting) {
    // Called when meeting is ended
    meeting.on(Events.meetingLeft, () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StartupScreen()),
          (route) => false);
    });

    //TODO save meeting id to database

    // Called when recording is started
    meeting.on(Events.recordingStarted, () {
      toastMsg("Meeting recording started.");

      // await GroupServices.saveMeetingIdForGroup(
      //                               widget.meetingId, widget.group.getId, widget.globals);

      setState(() {
        isRecordingOn = true;
      });
    });

    // Called when recording is stopped
    meeting.on(Events.recordingStopped, () {
      toastMsg("Meeting recording stopped.");

      setState(() {
        isRecordingOn = false;
      });
    });

    // Called when LiveStreaming is started
    meeting.on(Events.liveStreamStarted, () {
      toastMsg("Meeting live streaming started.");

      setState(() {
        isLiveStreamOn = true;
      });
    });

    // Called when LiveStreaming is stopped
    meeting.on(Events.liveStreamStopped, () {
      toastMsg("Meeting live streaming stopped.");

      setState(() {
        isLiveStreamOn = false;
      });
    });

    // Called when mic is requested
    meeting.on(Events.micRequested, (_data) {
      log("_data => $_data");
      dynamic accept = _data['accept'];
      dynamic reject = _data['reject'];

      log("accept => $accept reject => $reject");

      // Mic Request Dialog
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text("Mic requested?"),
          content: const Text("Do you want to turn on your mic? "),
          actions: [
            TextButton(
              onPressed: () {
                reject();

                Navigator.of(context).pop();
              },
              child: const Text("Reject"),
            ),
            TextButton(
              onPressed: () {
                accept();

                Navigator.of(context).pop();
              },
              child: const Text("Accept"),
            ),
          ],
        ),
      );
    });

    // Called when webcam is requested
    meeting.on(Events.webcamRequested, (_data) {
      log("_data => $_data");
      dynamic accept = _data['accept'];
      dynamic reject = _data['reject'];

      log("accept => $accept reject => $reject");

      // Webcam Request Dialog
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text("Webcam requested?"),
          content: const Text("Do you want to turn on your webcam? "),
          actions: [
            TextButton(
              onPressed: () {
                reject();

                Navigator.of(context).pop();
              },
              child: const Text("Reject"),
            ),
            TextButton(
              onPressed: () {
                accept();

                Navigator.of(context).pop();
              },
              child: const Text("Accept"),
            ),
          ],
        ),
      );
    });

    // Called when stream is enabled
    meeting.localParticipant.on(Events.streamEnabled, (Stream _stream) {
      if (_stream.kind == 'video') {
        setState(() {
          videoStream = _stream;
        });
      } else if (_stream.kind == 'audio') {
        setState(() {
          audioStream = _stream;
        });
      } else if (_stream.kind == 'share') {
        setState(() {
          shareStream = _stream;
        });
      }
    });

    // Called when stream is disabled
    meeting.localParticipant.on(Events.streamDisabled, (Stream _stream) {
      if (_stream.kind == 'video' && videoStream?.id == _stream.id) {
        setState(() {
          videoStream = null;
        });
      } else if (_stream.kind == 'audio' && audioStream?.id == _stream.id) {
        setState(() {
          audioStream = null;
        });
      } else if (_stream.kind == 'share' && shareStream?.id == _stream.id) {
        setState(() {
          shareStream = null;
        });
      }
    });

    // Called when presenter is changed
    meeting.on(Events.presenterChanged, (_activePresenterId) {
      Participant? activePresenterParticipant =
          meeting.participants[_activePresenterId];

      // Get Share Stream
      Stream? _stream = activePresenterParticipant?.streams.values
          .singleWhere((e) => e.kind == "share");

      setState(() => remoteParticipantShareStream = _stream);
    });
  }

  Future<bool> _onWillPopScope() async {
    meeting?.leave();
    goToRegisterOrLogin(context);
    return true;
  }

  void goToRegisterOrLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterStep1()));
  }
}
