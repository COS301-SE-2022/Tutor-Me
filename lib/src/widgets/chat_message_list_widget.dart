import 'package:tutor_me/src/colorpallete.dart';

import '../models/message_model.dart';
import 'package:flutter/material.dart';

Widget chatMessageWidget(ScrollController chatListScrollController,
    List<MessageModel> messageModel, String currentUserId) {
  return Expanded(
      child: Container(
    color: Colors.white,
    child: SingleChildScrollView(
      controller: chatListScrollController,
      child: Column(
        children: [
          ...messageModel.map((e) => chatItemWidget(e, currentUserId)),
          const SizedBox(
            height: 6,
          )
        ],
      ),
    ),
  ));
}

Widget chatItemWidget(MessageModel e, String currentUserId) {
  bool isMyChat = e.userId == currentUserId;
  return e.userId == "0"
      ? systemMessageWidget(e.messageText!)
      : Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              isMyChat
                  ? messageTime(isMyChat, e)
                  : userAvatar(e.userId!, e.userName!),
              messageTextAndName(isMyChat, e.messageText!, e.userName!),
              if (!isMyChat) messageTime(isMyChat, e)
            ],
          ),
        );
}

Widget systemMessageWidget(String text) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(25))),
    child: Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    ),
  );
}

Widget userAvatar(String userId, String userName) {
  Color avatarColor = colorBlueTeal;

  return Container(
    width: 40,
    height: 40,
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(shape: BoxShape.circle, color: avatarColor),
    child: Center(
      child: Text(
        userName.substring(0, 1).toUpperCase(),
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
    ),
  );
}

Widget messageTextAndName(bool isMyChat, String messageText, String userName) {
  return Expanded(
      child: Column(
    crossAxisAlignment:
        isMyChat ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.fromLTRB(isMyChat ? 20 : 8, 6, 8, 6),
        padding: EdgeInsets.fromLTRB(16, isMyChat ? 6 : 14, 16, 12),
        decoration: BoxDecoration(
            color: isMyChat ? Colors.amber[100] : Colors.amber[200],
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyChat)
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            Text(
              messageText,
              style: const TextStyle(height: 1.7),
            ),
          ],
        ),
      ),
    ],
  ));
}

Widget messageTime(bool isMyChat, MessageModel e) {
  var parsedDate = DateTime.parse(e.createDate!);
  var timeText = parsedDate.hour.toString() +
      " : " +
      parsedDate.minute.toString().padLeft(2, '0');
  return Container(
      margin: EdgeInsets.only(
          left: isMyChat ? 48 : 8, bottom: 12, right: isMyChat ? 0 : 16),
      alignment: Alignment.center,
      child: Text(
        timeText,
        style: const TextStyle(color: Colors.grey),
      ));
}
