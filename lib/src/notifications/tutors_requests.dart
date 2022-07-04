import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/services/tutee_services.dart';
import 'package:tutor_me/src/colorpallete.dart';

class TutorRequests extends StatefulWidget {
  final Tutors user;
  const TutorRequests({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorRequestsState();
  }
}

class TutorRequestsState extends State<TutorRequests> {
  List<Tutors> tutorList = List<Tutors>.empty();
  List<Tutors> tutors = List<Tutors>.empty();
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List<Tutees> tuteesList = List<Tutees>.empty();
  void getTutees() async {
    final tutees = await TuteeServices.getTutees();
    setState(() {
      tuteesList = tutees;
    });
  }

  @override
  void initState() {
    super.initState();
    getTutees();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (tuteesList.isNotEmpty) {
      return Material(
        child: SingleChildScrollView(
            child: SizedBox(
                height: screenHeight * 0.9,
                child: ListView.builder(
                  itemBuilder: _cardBuilder,
                  itemCount: tuteesList.length,
                ))),
      );
    }

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications_off,
              size: MediaQuery.of(context).size.height * 0.15,
              color: colorTurqoise,
            ),
            const Text('No new requests')
          ],
        ),
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = tuteesList[i].getName + ' ' + tuteesList[i].getLastName;
    final lastDate = DateTime.now();
    DateTime date = lastDate.add(const Duration(days: -3));
    String dateAsString = date.toString();
    List<String> actualDate = dateAsString.split(' ');
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/Pictures/penguin.png'),
            ),
            title: Text(name),
            subtitle: Text(
              tuteesList[i].getBio,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(actualDate[0]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: const Text("Accept"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorTurqoise),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Reject"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorOrange),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
