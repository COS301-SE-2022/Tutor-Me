// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/groups.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../../services/models/users.dart';
import '../../Groups/tutor_group.dart';

class TutorGroups extends StatefulWidget {
  final Users tutor;
  const TutorGroups({Key? key, required this.tutor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorGroupsState();
  }
}

class TutorGroupsState extends State<TutorGroups> {
  List<Groups> groups = List<Groups>.empty();
  List<int> numTutees = List<int>.empty(growable: true);
  bool hasGroups = false;
  bool isLoading = true;

  // getGroupDetails() async {
  //   final incomingGroups =
  //       await GroupServices.getGroupByUserID(widget.tutor.getId);
  //   groups = incomingGroups;

  //   if (groups.isNotEmpty) {
  //     setState(() {
  //       hasGroups = true;
  //     });
  //   }
  //   for (int i = 0; i < groups.length; i++) {
  //     List<String> tutees = groups[i].getTutees.split(',');
  //     numTutees.add(tutees.length);
  //   }

  //   setState(() {
  //     isLoading = false;
  //     groups = incomingGroups;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getGroupDetails();
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
                              color: colorTurqoise,
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
                                itemCount: groups.length))),
          ),
        ));
  }

  Widget groupBuilder(BuildContext context, int i) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TutorGroupPage(
                  group: groups[i],
                  tutor: widget.tutor,
                )));
      },
      child: Container(
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
                'https://cdn.pixabay.com/photo/2018/09/27/09/22/artificial-intelligence-3706562_960_720.jpg',
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            Row(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Text("  " + groups[i].getModuleId,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      color: colorWhite,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: MediaQuery.of(context).size.width * 0.110),
                const Icon(Icons.circle, size: 7, color: colorOrange),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Text(
                  numTutees[i].toString() + " participants(s)",
                  style: const TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              "  " + groups[i].getDescription,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: colorWhite,
              ),
            )
          ],
        ),
      ),
    );
  }
}
