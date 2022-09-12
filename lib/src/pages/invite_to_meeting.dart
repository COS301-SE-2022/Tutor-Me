// ignore_for_file: sort_child_properties_last, file_names

import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/calendar.dart';

class InviteToMeeting extends StatefulWidget {
  final String title;
  final String description;
  const InviteToMeeting(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<InviteToMeeting> createState() => _InviteToMeetingState();
}

class _InviteToMeetingState extends State<InviteToMeeting> {
  final allChecked = CheckBoxModal(name: "All Checked");
  // ignore: non_constant_identifier_names
  final CheckBoxList = [
    CheckBoxModal(name: "Kuda Christine"),
    CheckBoxModal(name: "Farai Chivunga"),
    CheckBoxModal(name: "Simphiwe Ndlovu"),
    CheckBoxModal(name: "Thabo Maduna"),
    CheckBoxModal(name: "Musa Mabasa"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Invite To Meeting"),
        backgroundColor: colorBlueTeal,
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => allCheck(allChecked),
            trailing: Checkbox(
              checkColor: colorWhite,
              activeColor: colorBlueTeal,
              value: allChecked.isChecked,
              onChanged: (value) => allCheck(allChecked),
            ),
            title: Text(
              allChecked.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.05,
              ),
            ),
          ),
          Divider(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          ...CheckBoxList.map(
            (checkBox) => ListTile(
              onTap: () => oneClicked(checkBox),
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/Pictures/penguin.png"),
              ),
              trailing: Checkbox(
                checkColor: colorWhite,
                activeColor: colorBlueTeal,
                value: checkBox.isChecked,
                onChanged: (value) => oneClicked(checkBox),
              ),
              title: Text(
                checkBox.name,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const Calendar())),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colorBlueTeal,
              ),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    const snackBar = SnackBar(
                      content: Text("Meeting Invite Sent"),
                      backgroundColor: colorLightGreen,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text(
                    "Invite",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ],
      ),
    ));
  }

  oneClicked(CheckBoxModal checkBox) {
    setState(() {
      checkBox.isChecked = !checkBox.isChecked;
    });
  }

  allCheck(CheckBoxModal n) {
    setState(() {
      n.isChecked = !n.isChecked;
      for (var checkBox in CheckBoxList) {
        checkBox.isChecked = n.isChecked;
      }
    });
  }
}

class CheckBoxModal {
  String name;
  bool isChecked;

  CheckBoxModal({required this.name, this.isChecked = false});
}
