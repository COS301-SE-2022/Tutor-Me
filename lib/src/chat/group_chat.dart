import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../chat/message.dart';

class GroupChat extends StatefulWidget {
  final dynamic user;

  const GroupChat({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GroupChatState();
  }
}

class GroupChatState extends State<GroupChat> {
  List<Message> messages = [
    Message(
        text: 'Now to show who is chatting when they do',
        date: DateTime.now().subtract(const Duration(days: 40)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text: 'Testing..',
        date: DateTime.now().subtract(const Duration(days: 37, minutes: 59)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "mus14mabasa@gmail.com"),
    Message(
        text: 'Typing',
        date: DateTime.now().subtract(const Duration(days: 37, minutes: 5)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text:
            'Aweh, Does the chat work for long Texts like this? Does it go to the next Line?',
        date: DateTime.now().subtract(const Duration(days: 37)),
        isSentByMe: true,
        isOnline: false,
        sentBy: "John@gmail.com"),
    Message(
        text: 'Hey',
        date: DateTime.now().subtract(const Duration(days: 36, minutes: 5)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "mus14mabasa@gmail.com"),
    Message(
        text: 'I sent this last month',
        date: DateTime.now().subtract(const Duration(days: 36)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text: 'Testing Chat',
        date: DateTime.now().subtract(const Duration(days: 35)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "madunathabo2@gmail.com"),
    Message(
        text: 'I sent this last month',
        date: DateTime.now().subtract(const Duration(days: 31, minutes: 1)),
        isSentByMe: true,
        isOnline: false,
        sentBy: "John@gmail.com"),
    Message(
        text: 'I replied within a minute',
        date: DateTime.now().subtract(const Duration(days: 31)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "kudachivunga33@gmail.com"),
    Message(
        text: 'This is a test Message You',
        date: DateTime.now().subtract(const Duration(days: 3, minutes: 1)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "simphiwendlovu@gmail.com"),
    Message(
        text: 'Is this You?',
        date: DateTime.now().subtract(const Duration(minutes: 2)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text: 'Yes sure!',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: true,
        isOnline: false,
        sentBy: "John@gmail.com"),
    Message(
        text: 'Now to show who is chatting when they do',
        date: DateTime.now().subtract(const Duration(days: 40)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "kudachivunga33@gmail.com"),
    Message(
        text: 'Testing..',
        date: DateTime.now().subtract(const Duration(days: 37, minutes: 59)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "mus14mabasa@gmail.com"),
    Message(
        text: 'Typing',
        date: DateTime.now().subtract(const Duration(days: 37, minutes: 5)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "simphiwendlovu@gmail.com"),
    Message(
        text:
            'Aweh, Does the chat work for long Texts like this? Does it go to the next Line?',
        date: DateTime.now().subtract(const Duration(days: 37)),
        isSentByMe: true,
        isOnline: false,
        sentBy: "John@gmail.com"),
    Message(
        text: 'Hey',
        date: DateTime.now().subtract(const Duration(days: 36, minutes: 5)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "mus14mabasa@gmail.com"),
    Message(
        text: 'I sent this last month',
        date: DateTime.now().subtract(const Duration(days: 36)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text: 'Testing Chat',
        date: DateTime.now().subtract(const Duration(days: 35)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "madunathabo2@gmail.com"),
    Message(
        text: 'I sent this last month',
        date: DateTime.now().subtract(const Duration(days: 31, minutes: 1)),
        isSentByMe: true,
        isOnline: false,
        sentBy: "John@gmail.com"),
    Message(
        text: 'I replied within a minute',
        date: DateTime.now().subtract(const Duration(days: 31)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text: 'This is a test Message You',
        date: DateTime.now().subtract(const Duration(days: 3, minutes: 1)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text: 'Is this You?',
        date: DateTime.now().subtract(const Duration(minutes: 2)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "farai.fantasy.822@gmail.com"),
    Message(
        text: 'Yes sure!',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: true,
        isOnline: false,
        sentBy: "John@gmail.com")
  ].toList();
  @override
  Widget build(BuildContext context) {
    String status = "";
    if (widget.user.getStatus == "F") {
      status = "Offline";
    } else {
      status = "Online";
    }
    String name = widget.user.getName + ' ' + widget.user.getLastName;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorOrange,
          title: Column(
            children: const [
              Text(
                "COS301 group",
              ),
              Text(
                "Meeting code: XrL2-BFsG-2aFQ",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GroupedListView<Message, DateTime>(
                padding: const EdgeInsets.all(8),
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                elements: messages,
                groupBy: (message) => DateTime(
                    message.date.year, message.date.month, message.date.day),
                groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                    child: Card(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          DateFormat.yMMMd().format(message.date),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                itemBuilder: (context, Message message) => Align(
                  alignment: message.isSentByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Card(
                    color: message.isSentByMe
                        ? Colors.orange[300]
                        : Colors.orange[100],
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          message.isSentByMe
                              ? Text("You",
                                  style: TextStyle(
                                      color: Colors.blue[400],
                                      fontWeight: FontWeight.bold))
                              : Text(message.sentBy,
                                  style: TextStyle(
                                      color: Colors.blue[400],
                                      fontWeight: FontWeight.bold)),
                          Text(message.text),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey,
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    ),
                    contentPadding: EdgeInsets.all(14),
                    hintText: 'Type your message...'),
              ),
            )
          ],
        ));
  }
}
