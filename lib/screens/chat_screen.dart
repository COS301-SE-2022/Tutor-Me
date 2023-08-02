// import 'package:flutter/material.dart';
// import 'package:tutor_me/src/colorpallete.dart';
// import 'package:videosdk/rtc.dart';
// import '../widgets/chat/chat_widget.dart';

// import 'package:provider/provider.dart';
// import 'package:tutor_me/src/theme/themes.dart';

// // ChatScreen
// class ChatScreen extends StatefulWidget {
//   final Meeting meeting;
//   const ChatScreen({
//     Key? key,
//     required this.meeting,
//   }) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   // MessageTextController
//   final msgTextController = TextEditingController();

//   // PubSubMessages
//   PubSubMessages? messages;

//   @override
//   void initState() {
//     super.initState();

//     // Subscribing 'CHAT' Topic
//     widget.meeting.pubSub
//         .subscribe("CHAT", messageHandler)
//         .then((value) => setState((() => messages = value)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ThemeProvider>(context, listen: false);
//     Color appBarColor;
//     if (provider.themeMode == ThemeMode.dark) {
//       appBarColor = Colors.grey;
//     } else {
//       appBarColor = colorBlueTeal;
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("TutorMe Chat"),
//         automaticallyImplyLeading: false,
//         backgroundColor: appBarColor,
//         actions: [
//           // Close Button
//           IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: messages == null
//                     ? const Center(child: CircularProgressIndicator())
//                     : SingleChildScrollView(
//                         reverse: true,
//                         child: Column(
//                           children: messages!.messages
//                               .map(
//                                 (e) => ChatWidget(
//                                   message: e,
//                                   isLocalParticipant: e.senderId ==
//                                       widget.meeting.localParticipant.id,
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white54),
//                     borderRadius: BorderRadius.circular(15)),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: msgTextController,
//                         onChanged: (value) => setState(() {
//                           msgTextController.text;
//                         }),
//                         decoration: const InputDecoration(
//                           hintText: "Typing ...",
//                           border: InputBorder.none,
//                           // border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: colorBlueTeal,
//                       onPressed: msgTextController.text.trim().isEmpty
//                           ? null
//                           : () => widget.meeting.pubSub
//                               .publish(
//                                 "CHAT",
//                                 msgTextController.text,
//                                 const PubSubPublishOptions(persist: true),
//                               )
//                               .then((value) => msgTextController.clear()),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void messageHandler(PubSubMessage message) {
//     setState(() => messages!.messages.add(message));
//   }

//   @override
//   void dispose() {
//     widget.meeting.pubSub.unsubscribe("CHAT", messageHandler);
//     super.dispose();
//   }
// }
