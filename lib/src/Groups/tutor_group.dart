import 'package:flutter/material.dart';
import 'package:tutor_me/src/Groups/group.dart';
import 'package:tutor_me/src/colorpallete.dart';

class TutorGroupPage extends StatefulWidget {
  final Group group;
  const TutorGroupPage({Key? key, required this.group}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorGroupPageState();
  }
}

class TutorGroupPageState extends State<TutorGroupPage> {
  var tasks = [
    'Complete Worksheet 2, pdf in group chat.',
    'Next session will be on the 29th of July, be prepared.',
    'Our next topic will be parsing.',
    'We need to prepare for upcoming exams',
    'Revise those Lexer notes'
  ];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          title: Text(widget.group.code + '- Group'),
          backgroundColor: colorOrange,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          ],
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight * 0.9,
          width: screenWidth * 0.9,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Container(
                color: Colors.grey.withOpacity(0.2),
                height: screenHeight * 0.2,
                width: screenWidth * 0.42,
                padding: EdgeInsets.only(
                    top: screenHeight * 0.02,
                    bottom: screenHeight * 0.02,
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Group Header:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: screenHeight * 0.03,
                              decoration: TextDecoration.underline),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: colorTurqoise,
                            size: screenHeight * 0.045,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Flexible(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                    thumbColor: MaterialStateProperty.all(
                                        colorTurqoise))),
                            child: Scrollbar(
                              trackVisibility: true,
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: pointBuilder,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: screenHeight * 0.01,
                                    );
                                  },
                                  itemCount: tasks.length),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              SizedBox(
                height: screenHeight * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          horizontalTitleGap: screenHeight * 0.04,
                          leading: Icon(
                            Icons.chat,
                            size: screenHeight * 0.06,
                            color: colorOrange,
                          ),
                          title: Text(
                            'Group Chat',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025),
                          ),
                          subtitle: const Text('2 new msgs!'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          horizontalTitleGap: screenHeight * 0.04,
                          leading: Stack(children: [
                            Icon(
                              Icons.chat_bubble,
                              size: screenHeight * 0.06,
                              color: colorOrange,
                            ),
                            Positioned(
                                top: screenHeight * 0.01,
                                left: screenWidth * 0.017,
                                child: const Icon(
                                  Icons.video_camera_front,
                                  color: colorWhite,
                                ))
                          ]),
                          title: Text(
                            'Start Live Video Call',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: screenHeight * 0.05,
                    // ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * 0.5,
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  child: Text(
                    'Paticipants:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.382,
                width: screenWidth * 0.5,
                child: ListView.separated(
                    controller: ScrollController(),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: participantBuilder,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: screenHeight * 0.0001,
                      );
                    },
                    itemCount: 5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pointBuilder(BuildContext context, int i) {
    return Text(
      '•' + tasks[i],
      style: const TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget participantBuilder(BuildContext context, int i) {
    return InkWell(
        onTap: () {},
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage:
                      const AssetImage('assets/Pictures/penguin.png'),
                  radius: MediaQuery.of(context).size.aspectRatio * 50),
              title: Text(
                'Kuda Chivunga',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              subtitle: const Text(
                'Computer Science',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: colorOrange),
              ),
              trailing: Icon(
                Icons.chat_bubble,
                size: MediaQuery.of(context).size.aspectRatio * 80,
                color: colorOrange,
              ),
            )));
  }
}
