import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_me/services/models/groups.dart';
import 'package:tutor_me/src/Groups/group.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../../services/models/modules.dart';

class TuteeGroups extends StatelessWidget {
  TuteeGroups({Key? key}) : super(key: key);

  var groups = [
    Group("COS314", "Compiler Construction - YR 3", 3,
        'https://cdn.pixabay.com/photo/2018/09/27/09/22/artificial-intelligence-3706562_960_720.jpg'),
    Group("IMY310", "Multimedia - YR 3", 5,
        'https://cdn.pixabay.com/photo/2018/10/19/10/43/social-media-3758364__340.jpg'),
    Group("STK12O", "Multimedia - YR 3", 7,
        'https://cdn.pixabay.com/photo/2017/10/17/14/10/financial-2860753__340.jpg'),
  ];
  List<Groups> groupIdList = List<Groups>.empty();

  @override
  // void initState() {
  //   super.initState();
  //   // getModules();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: const Color(0xffD6521B),
            centerTitle: true,
            title: const Text('My Tutee Groups'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  // borderRadius:
                  //     BorderRadius.vertical(bottom: Radius.circular(60)),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.orange, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          body: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.04),
                    child: ListView.separated(
                        itemBuilder: groupBuilder,
                        separatorBuilder: (BuildContext context, index) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          );
                        },
                        itemCount: 3))),
          ),
        ));
  }

  Widget groupBuilder(BuildContext context, int i) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: colorTurqoise,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              groups[i].image,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
          Row(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text("  " + groups[i].code,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    color: colorWhite,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(width: MediaQuery.of(context).size.width * 0.135),
              const Icon(Icons.circle, size: 7, color: colorOrange),
              SizedBox(width: MediaQuery.of(context).size.width * 0.08),
              const Text(
                "x   participants",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            "  " + groups[i].name,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: colorWhite,
            ),
          )
        ],
      ),
    );
  }
}
