import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'meeting_action_button.dart';

// import 'package:provider/provider.dart';
// import 'package:tutor_me/src/theme/themes.dart';

// Meeting ActionBar
class MeetingActionBar extends StatelessWidget {
  // control states
  final bool isMicEnabled,
      isWebcamEnabled,
      isRecordingOn,
      isScreenShareEnabled,
      isScreenShareButtonDisabled;

  // callback functions
  final void Function() onCallEndButtonPressed,
      onMicButtonPressed,
      onWebcamButtonPressed,
      onSwitchCameraButtonPressed,
      onMoreButtonPressed,
      onScreenShareButtonPressed,
      onRecordingShareButtonPressed;

  const MeetingActionBar({
    Key? key,
    required this.isMicEnabled,
    required this.isWebcamEnabled,
    required this.isRecordingOn,
    required this.isScreenShareEnabled,
    required this.isScreenShareButtonDisabled,
    required this.onCallEndButtonPressed,
    required this.onMicButtonPressed,
    required this.onWebcamButtonPressed,
    required this.onSwitchCameraButtonPressed,
    required this.onScreenShareButtonPressed,
    required this.onRecordingShareButtonPressed,
    required this.onMoreButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ThemeProvider>(context, listen: false);
    // Color participantColor;
    // if (provider.themeMode == ThemeMode.dark) {
    //   participantColor = Colors.grey;
    // } else {
    //   participantColor = Colors.orange.shade900;
    // }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // color: participantColor,
      child: Row(
        children: [
          // Call End Control
          Expanded(
            child: MeetingActionButton(
              backgroundColor: Colors.red,
              onPressed: onCallEndButtonPressed,
              icon: Icons.call_end,
            ),
          ),

          // Mic Control
          Expanded(
            child: MeetingActionButton(
              onPressed: onMicButtonPressed,
              backgroundColor:
                  isMicEnabled ? hoverColor : secondaryColor.withOpacity(0.8),
              icon: isMicEnabled ? Icons.mic : Icons.mic_off,
            ),
          ),

          // Webcam Control
          Expanded(
            child: MeetingActionButton(
              onPressed: onWebcamButtonPressed,
              backgroundColor: isWebcamEnabled
                  ? hoverColor
                  : secondaryColor.withOpacity(0.8),
              icon: isWebcamEnabled ? Icons.videocam : Icons.videocam_off,
            ),
          ),

          // Webcam Switch Control
          Expanded(
            child: MeetingActionButton(
              backgroundColor: secondaryColor.withOpacity(0.8),
              onPressed: isWebcamEnabled ? onSwitchCameraButtonPressed : null,
              icon: Icons.cameraswitch,
            ),
          ),

          // Recording Switch Control
          Expanded(
            child: MeetingActionButton(
              backgroundColor: secondaryColor.withOpacity(0.8),
              onPressed: onRecordingShareButtonPressed,
              icon: isRecordingOn
                  ? Icons.stop_circle_outlined
                  : Icons.emergency_recording,
            ),
          ),

          // ScreenShare Control
          if (Platform.isAndroid)
            Expanded(
              child: MeetingActionButton(
                backgroundColor: isScreenShareEnabled
                    ? hoverColor
                    : secondaryColor.withOpacity(0.8),
                onPressed: isScreenShareButtonDisabled
                    ? null
                    : onScreenShareButtonPressed,
                icon: isScreenShareEnabled
                    ? Icons.screen_share
                    : Icons.stop_screen_share,
                iconColor:
                    isScreenShareButtonDisabled ? Colors.white30 : Colors.white,
              ),
            ),

          // More options
          Expanded(
            child: MeetingActionButton(
              backgroundColor: secondaryColor.withOpacity(0.8),
              onPressed: onMoreButtonPressed,
              icon: Icons.chat_bubble_outline,
            ),
          ),
        ],
      ),
    );
  }
}
