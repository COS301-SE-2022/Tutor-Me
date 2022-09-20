// ignore_for_file: sort_child_properties_last, file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/event.dart';
import 'package:tutor_me/services/services/events_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/calendar.dart';

import '../../services/models/globals.dart';
import '../../services/models/groups.dart';
import '../../services/models/modules.dart';
import '../../services/services/group_services.dart';
import '../../services/services/module_services.dart';
import '../theme/themes.dart';

class InviteToMeeting extends StatefulWidget {
  final Globals globals;
  const InviteToMeeting({Key? key, required this.globals}) : super(key: key);

  @override
  State<InviteToMeeting> createState() => _InviteToMeetingState();
}

class _InviteToMeetingState extends State<InviteToMeeting> {
  List<Groups> groups = List<Groups>.empty();
  List<Modules> modules = List<Modules>.empty(growable: true);
  List<int> numTutees = List<int>.empty(growable: true);
  String images =
      'https://cdn.pixabay.com/photo/2018/09/27/09/22/artificial-intelligence-3706562_960_720.jpg';
  bool hasGroups = false;
  bool isLoading = true;
  final numTuteesForEachGroup = <int>[];

  int numOfTutees = 3;
  getGroupModules() async {
    try {
      for (int i = 0; i < groups.length; i++) {
        final incomingModules = await ModuleServices.getModule(
            groups[i].getModuleId, widget.globals);
        modules.add(incomingModules);
      }
    } catch (e) {
      const snack = SnackBar(content: Text('Error loading modules'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    setState(() {
      isLoading = false;
    });
  }

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
    getGroupModules();
  }

  late int selectedButton = 0;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getGroupDetails();
  }

  @override
  Widget build(BuildContext context) {
      final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;
    Color secondaryColor;
    Color textColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
      textColor = colorWhite;
      highLightColor = colorLightBlueTeal;
      secondaryColor = colorLightGrey;
    } else {
      primaryColor = colorBlueTeal;
      textColor = colorDarkGrey;
      highLightColor = colorOrange;
      secondaryColor = colorWhite;
    }
    // print();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Invite To Meeting"),
          backgroundColor: colorBlueTeal,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //radio buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < modules.length; i++)
                  RadioListTile(
                    title: Text(
                        modules[i].getCode + ' - ' + modules[i].getModuleName),
                    value: i,
                    groupValue: selectedButton,
                    onChanged: (value) {
                      setState(() {
                        selectedButton = value as int;
                      });
                    },
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: highLightColor,
                    ),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Calendar(
                                globals: widget.globals,
                              ),
                            ),
                          );
                          SnackBar snackBar = const SnackBar(
                            backgroundColor: colorLightGreen,
                            content: Text(
                              'Meeting Invited',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Text(
                          "Invite",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
