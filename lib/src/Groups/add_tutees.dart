import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/src/Groups/tutor_group.dart';

import '../../../services/models/globals.dart';
import '../../services/models/groups.dart';
import '../../services/models/users.dart';
import '../../services/services/user_services.dart';
import '../colorpallete.dart';

class Tutees {
  Tutee tutee;
  bool selected;

  Tutees(this.tutee, this.selected);
}

class AddTutees extends StatefulWidget {
  final Globals globals;
  final List<Tutee> tutees;
  final Groups group;
  const AddTutees(
      {Key? key,
      required this.globals,
      required this.tutees,
      required this.group})
      : super(key: key);

  @override
  _AddTuteesState createState() => _AddTuteesState();
}

class _AddTuteesState extends State<AddTutees> {
  bool _isLoading = true;
  bool isConfirming = false;
  List<Users> currentTutees = List<Users>.empty(growable: true);
  List<Tutee> tutees = List<Tutee>.empty(growable: true);
  List<Uint8List> images = List<Uint8List>.empty(growable: true);
  List<int> hasImage = List<int>.empty(growable: true);
  List<Tutees> tuteesToSelect = List<Tutees>.empty(growable: true);
  List<Users> selectedTutees = List<Users>.empty(growable: true);

  void getConnections() async {
    log('is connecting');
    try {
      currentTutees = await UserServices.getConnections(
          widget.globals.getUser.getId,
          widget.globals.getUser.getUserTypeID,
          widget.globals);

      getChatsProfileImages();
    } catch (e) {
      getChatsProfileImages();
    }
  }

  getChatsProfileImages() async {
    log('is getting images');
    log(currentTutees.length.toString());
    for (int i = 0; i < currentTutees.length; i++) {
      try {
        final image = await UserServices.getTutorProfileImage(
            currentTutees[i].getId, widget.globals);
        setState(() {
          images.add(image);
        });
      } catch (e) {
        final byte = Uint8List(128);
        images.add(byte);
        hasImage.add(i);
      }
    }
    for (int i = 0; i < currentTutees.length; i++) {
      setState(() {
        bool val = true;
        for (int j = 0; j < hasImage.length; j++) {
          if (hasImage[j] == i) {
            val = false;
            break;
          }
        }
        if (!val) {
          tutees.add(Tutee(currentTutees[i], images[i], false));
        } else {
          tutees.add(Tutee(currentTutees[i], images[i], true));
        }
      });
    }

    for (var groupTutee in widget.tutees) {
      tutees
          .removeWhere((tutee) => tutee.tutee.getId == groupTutee.tutee.getId);
    }

    for (var tutee in tutees) {
      tuteesToSelect.add(Tutees(tutee, false));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tutees'),
        backgroundColor: colorBlueTeal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Confirm'),
        onPressed: () async {
          for (var tutee in tuteesToSelect) {
            try {
              await GroupServices.addTuteeToGroup(
                  tutee.tutee.tutee.getId, widget.group.getId, widget.globals);
            } catch (e) {
              const snackBar = SnackBar(content: Text('Error adding tutee'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        },
        backgroundColor: colorBlueTeal,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.separated(
              itemCount: currentTutees.length,
              itemBuilder: (context, index) {
                return _cardBuilder(context, index);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                );
              },
            ),
    );
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = tuteesToSelect[i].tutee.tutee.getName +
        ' ' +
        tuteesToSelect[i].tutee.tutee.getLastName;
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: tuteesToSelect[i].tutee.hasImage
                  ? ClipOval(
                      child: Image.memory(
                        tuteesToSelect[i].tutee.image,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.width * 0.18,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        'assets/Pictures/penguin.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.width * 0.18,
                      ),
                    ),
            ),
            title: Text(name),
            subtitle: Text(currentTutees[i].getBio),
            trailing: Checkbox(
              value: tuteesToSelect[i].selected,
              onChanged: (bool? value) {
                setState(() {
                  tuteesToSelect[i].selected = value!;
                });
                if (value == true) {
                  selectedTutees.add(tuteesToSelect[i].tutee.tutee);
                } else {
                  selectedTutees.remove(tuteesToSelect[i].tutee.tutee);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
