import 'package:flutter/material.dart';

class EditModuleList extends StatefulWidget {
  const EditModuleList({Key? key}) : super(key: key);

  @override
  _EditModuleListState createState() => _EditModuleListState();
}

class _EditModuleListState extends State<EditModuleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Moduqle List"),
        ),
        body: Column(children: <Widget>[
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              topDesign(),
              // readyToTutor(),
              // buildBody(),
            ],
          ),
        ]));
  }

  Widget topDesign() {
    return const Scaffold(
      body: Text('Edit Module List'),
    );
  }

  // Widget buildBody() {}
}
