// ignore_for_file: sort_child_properties_last, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/services/events_services.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../services/models/event.dart';
import '../../services/models/globals.dart';
import '../../services/models/groups.dart';
import '../../services/models/modules.dart';
import '../../services/services/group_services.dart';
import '../../services/services/module_services.dart';
import '../theme/themes.dart';

class InviteToMeeting extends StatefulWidget {
  final Globals globals;
  final Event event;
  const InviteToMeeting({Key? key, required this.globals, required this.event})
      : super(key: key);

  @override
  State<InviteToMeeting> createState() => _InviteToMeetingState();
}

class _InviteToMeetingState extends State<InviteToMeeting> {
  List<Groups> groups = List<Groups>.empty();
  List<Modules> modules = List<Modules>.empty(growable: true);
  List<int> numTutees = List<int>.empty(growable: true);
  late Groups selectedGroup;
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
      final incomingGroups = await GroupServices.getTuteeGroupByUserID(
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

    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      highLightColor = colorLightBlueTeal;
    } else {
      highLightColor = colorOrange;
    }
    // print();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            try {
              await EventServices.updateGroupId(
                  widget.event.getEventId, selectedGroup.getId, widget.globals);

              SnackBar snackBar = const SnackBar(
                backgroundColor: colorLightGreen,
                content: Text(
                  'Meeting Invitations have been sent',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.pop(context);
            } catch (e) {
              SnackBar snackBar = const SnackBar(
                content: Text(
                  'Failed to invite group',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          label: Text(
            'Invite',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          backgroundColor: highLightColor,
        ),
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
                    title: Text(modules[i].getCode +
                        ' - ' +
                        modules[i].getModuleName +
                        ' group'),
                    value: i,
                    groupValue: selectedButton,
                    onChanged: (value) {
                      setState(() {
                        selectedButton = value as int;
                        selectedGroup = groups[selectedButton];
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
