// ignore_for_file: file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/models/groups.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../../services/models/modules.dart';
import '../../../services/services/group_services.dart';
import '../../../services/services/module_services.dart';
import '../../Groups/tutor_group.dart';

class GroupList {
  Groups group;
  Modules module;

  GroupList({required this.group, required this.module});
}

class TutorGroups extends StatefulWidget {
  final Globals globals;
  const TutorGroups({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorGroupsState();
  }
}

class TutorGroupsState extends State<TutorGroups> {
  List<Groups> groups = List<Groups>.empty();
  List<int> numTutees = List<int>.empty(growable: true);
  List<Modules> modules = List<Modules>.empty(growable: true);
  List<GroupList> groupList = List<GroupList>.empty(growable: true);
  String images =
      'https://cdn.pixabay.com/photo/2018/09/27/09/22/artificial-intelligence-3706562_960_720.jpg';
  bool hasGroups = false;
  bool isLoading = true;
  final numTuteesForEachGroup = <int>[];

  int numOfTutees = 3;
  getGroupDetails() async {
    try {
      final incomingGroups = await GroupServices.getGroupByUserID(
          widget.globals.getUser.getId, widget.globals);

      groups = incomingGroups;
      if (groups.isNotEmpty) {
        hasGroups = true;

        for (int k = 0; k < numTuteesForEachGroup.length; k++) {
          k.toString() + " 's # tutees " + numTuteesForEachGroup[k].toString();
        }
        numOfTutees = numOfTutees;
        getGroupModules();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  getGroupModules() async {
    // await UserServices.updateEvent(widget.globals);
    try {
      for (int i = 0; i < groups.length; i++) {
        final incomingModules = await ModuleServices.getModule(
            groups[i].getModuleId, widget.globals);
        modules.add(incomingModules);
      }
      if (groups.isNotEmpty && modules.isNotEmpty) {
        for (int i = 0; i < groups.length; i++) {
          groupList.add(GroupList(group: groups[i], module: modules[i]));
        }
        setState(() {
          if (modules.isNotEmpty) {
            isLoading = false;
          }
        });
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        groups.clear();
      });
      const snack = SnackBar(content: Text('Error loading modules'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  @override
  void initState() {
    super.initState();
    getGroupDetails();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Center(
            child: isLoading
                ? const CircularProgressIndicator.adaptive()
                : !hasGroups
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Icon(
                              Icons.people,
                              size: MediaQuery.of(context).size.height * 0.1,
                              color: colorOrange,
                            ),
                            const Text("No Groups Found")
                          ])
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04),
                            child: ListView.separated(
                                itemBuilder: groupBuilder,
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  );
                                },
                                itemCount: groupList.length))),
          ),
        ));
  }

  Widget groupBuilder(BuildContext context, int i) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TutorGroupPage(
                  group: groupList[i].group,
                  globals: widget.globals,
                  module: groupList[i].module,
                )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: colorOrange,
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
                'https://cdn.pixabay.com/photo/2018/09/27/09/22/artificial-intelligence-3706562_960_720.jpg',
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            Row(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Text("  " + groupList[i].module.getCode,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      color: colorWhite,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: MediaQuery.of(context).size.width * 0.110),
                const Icon(Icons.circle, size: 7, color: colorBlueTeal),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                const Text(
                  "2 participants(s)",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              "  " + groupList[i].module.getModuleName,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.025,
                color: colorWhite,
              ),
            )
          ],
        ),
      ),
    );
  }
}
