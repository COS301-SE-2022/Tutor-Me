import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tutor_me/src/tutorProfilePages/tutor_profile_view.dart';
import '../../services/models/globals.dart';
import '../../services/models/users.dart';
import '../chat/message.dart';
import 'package:intl/intl.dart';

import '../tuteeProfilePages/tutee_profile_view.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class Chat extends StatefulWidget {
  final dynamic reciever;
  final Globals globals;
  final Uint8List image;
  final bool hasImage;
  const Chat(
      {Key? key,
      required this.reciever,
      required this.globals,
      required this.image,
      required this.hasImage})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  bool isTapped = false;
  TextEditingController messageTextCOntroller = TextEditingController();
  List<Message> messages = [
    Message(
        text: 'Yes sure!',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "John@gmail.com")
  ].toList();
  @override
  Widget build(BuildContext context) {
    String status = "";
    if (widget.reciever.getStatus == "F") {
      status = "Offline";
    } else {
      status = "Online";
    }
    String name = widget.reciever.getName + ' ' + widget.reciever.getLastName;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorBlueTeal,
          title: InkWell(
            onTap: widget.reciever is Users
                ? () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => TutorProfilePageView(
                              tutor: widget.reciever,
                              globals: widget.globals,
                            )));
                  }
                : () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => TuteeProfilePageView(
                              user: widget.reciever,
                              image: widget.image,
                              imageExists: widget.hasImage,
                            )));
                  },
            child: Row(
              children: [
                CircleAvatar(
                  child: widget.hasImage
                      ? ClipOval(
                          child: Image.memory(
                            widget.image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.253,
                            height: MediaQuery.of(context).size.width * 0.253,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                          "assets/Pictures/penguin.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.253,
                          height: MediaQuery.of(context).size.width * 0.253,
                        )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(
                      status,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
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
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Card(
                    color: message.isSentByMe
                        ? colorBlueTeal.withOpacity(0.8)
                        : Colors.grey[300],
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
                          Text(
                            message.text,
                            style: TextStyle(
                                color: message.isSentByMe
                                    ? colorWhite
                                    : colorBlack),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(50)),
              child: TextField(
                onTap: () {
                  isTapped = true;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: messageTextCOntroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: isTapped
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            color: colorBlack,
                            iconSize:
                                MediaQuery.of(context).size.height * 0.045,
                            onPressed: messageTextCOntroller.clear,
                          )
                        : Icon(
                            Icons.mail,
                            color: colorOrange,
                            size: MediaQuery.of(context).size.height * 0.045,
                          ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: colorOrange,
                        size: MediaQuery.of(context).size.height * 0.045,
                      ),
                      onPressed: () {},
                    ),
                    contentPadding: const EdgeInsets.all(14),
                    hintText: 'Type your message...'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            )
          ],
        ));
  }
}
