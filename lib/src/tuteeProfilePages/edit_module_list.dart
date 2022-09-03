import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:tutor_me/services/services/user_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tuteeProfilePages/tutee_profile.dart';

import '../../services/models/groups.dart';
import '../../services/models/modules.dart';
import '../../services/models/users.dart';
import 'add_modules.dart';

// ignore: must_be_immutable
class EditModuleList extends StatefulWidget {
  final Users user;
  List<Modules> currentModules;
  EditModuleList({Key? key, required this.user, required this.currentModules})
      : super(key: key);

  @override
  _EditModuleListState createState() => _EditModuleListState();
}

class _EditModuleListState extends State<EditModuleList> {
  List<Modules> modulesToRemove = List<Modules>.empty(growable: true);
  List<Modules> modulesToAdd = List<Modules>.empty(growable: true);
  List<Modules> confirmedModules = List<Modules>.empty();
  List<Groups> tutorGroups = List<Groups>.empty();
  final textControl = TextEditingController();
  String query = '';
  bool isCurrentOpen = true;
  bool isAllOpen = false;
  bool isConfirming = false;

  // void inputCurrent() {
  //   confirmedModules = widget.currentModules;
  //   for (int i = 0; i < widget.currentModules.length; i++) {
  //     updateModules(widget.currentModules[i]);
  //   }
  // }

  // void updateModules(Modules cModule) {
  //   String cName = cModule.getModuleName;
  //   String cCode = cModule.getCode;
  //   final modules = moduleList.where((module) {
  //     final nameToLower = module.getModuleName.toLowerCase();
  //     final codeToLower = module.getCode.toLowerCase();
  //     final cNameToLower = cName.toLowerCase();
  //     final cCodeToLower = cCode.toLowerCase();

  //     return !nameToLower.contains(cNameToLower) &&
  //         !codeToLower.contains(cCodeToLower);
  //   }).toList();
  //   setState(() {
  //     moduleList = modules;
  //   });
  //   getTutorGroups();
  // }

  // void search(String search) {
  //   if (search == '') {
  //     moduleList = saveModule;
  //   }
  //   final modules = moduleList.where((module) {
  //     final nameToLower = module.getModuleName.toLowerCase();
  //     final codeToLower = module.getCode.toLowerCase();
  //     final query = search.toLowerCase();

  //     return nameToLower.contains(query) || codeToLower.contains(query);
  //   }).toList();

  //   setState(() {
  //     moduleList = modules;
  //     query = search;
  //   });
  // }

  // getModules() async {
  //   final modules = await ModuleServices.getModules();
  //   setState(() {
  //     moduleList = modules;
  //     saveModule = modules;
  //   });
  // }

  getTutorGroups() async {
    final groups =
        await GroupServices.getGroupByUserID(widget.user.getId);

    tutorGroups = groups;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getModules();

  //   inputCurrent();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Current Modules'),
        backgroundColor: colorOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  itemBuilder: _currentModulesBuilder,
                  itemCount: widget.currentModules.length,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                        top: MediaQuery.of(context).size.width * 0.04,
                        bottom: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: SmallTagBtn(
                          btnName: "Cancel",
                          backColor: colorOrange,
                          funct: isConfirming
                              ? () {}
                              : () {
                                  Navigator.pop(context);
                                }),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.1,
                        bottom: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: SmallTagBtn(
                          btnName: !isConfirming ? "Confirm" : 'Confirming',
                          backColor: colorTurqoise,
                          funct: isConfirming
                              ? () {}
                              : () async {
                                  setState(() {
                                    isConfirming = true;
                                  });
                                  try {

                                    for (var module in widget.currentModules) {
                                      try {
                                        await ModuleServices.addUserModule(
                                            widget.user.getId, module);
                                      } catch (e) {
                                        continue;
                                      }
                                    }

                                    // if (tutorGroups.isEmpty) {
                                    //   modulesToAdd = widget.currentModules;
                                    // } else {
                                    //   final newGroups =
                                    //       widget.currentModules.where((module) {
                                    //     bool isModuleOld = false;
                                    //     for (int i = 0;
                                    //         i < tutorGroups.length;
                                    //         i++) {
                                    //       if (module.getCode.contains(
                                    //           tutorGroups[i].getModuleCode)) {
                                    //         isModuleOld = true;
                                    //       }
                                    //     }
                                    //     return !isModuleOld;
                                    //   }).toList();

                                    //   modulesToAdd = newGroups;
                                    // }

                                    // if (modulesToAdd.isNotEmpty) {
                                    //   showConfirmUpdate(context);
                                    //   for (int i = 0;
                                    //       i < modulesToAdd.length;
                                    //       i++) {
                                    //     await GroupServices.createGroup(
                                    //         modulesToAdd[i].getCode,
                                    //         modulesToAdd[i].getModuleName,
                                    //         widget.user.getId);
                                    //   }
                                    // }

                                    Navigator.pop(
                                        context, widget.currentModules);
                                  } catch (e) {
                                    const snackBar = SnackBar(
                                      content:
                                          Text('Failed to update modules.'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  isConfirming = false;
                                }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ExpansionPanelRadio(
        //   canTapOnHeader: true,
        //   value: const Text("Availabe modules"),
        //   headerBuilder: (context, isOpen) {
        //     return const ListTile(
        //         title: Text(
        //       "Available Modules",
        //       style: TextStyle(fontSize: 20),
        //     ));
        //   },
        //   body: Column(children: <Widget>[
        //     Container(
        //       margin: const EdgeInsets.all(15),
        //       height: 50,
        //       child: TextField(
        //         onChanged: (value) => search(value),
        //         controller: textControl,
        //         decoration: InputDecoration(
        //             filled: true,
        //             fillColor: Colors.white,
        //             contentPadding: const EdgeInsets.all(0),
        //             prefixIcon: const Icon(
        //               Icons.search,
        //               color: Colors.black45,
        //             ),
        //             suffixIcon: query.isNotEmpty
        //                 ? GestureDetector(
        //                     child: const Icon(
        //                       Icons.close,
        //                       color: Colors.black45,
        //                     ),
        //                     onTap: () {
        //                       textControl.clear();
        //                       setState(() {
        //                         moduleList = saveModule;
        //                       });
        //                     },
        //                   )
        //                 : null,
        //             border: OutlineInputBorder(
        //               borderSide: const BorderSide(
        //                   color: colorOrange, width: 1.0),
        //               borderRadius: BorderRadius.circular(50),
        //             ),
        //             hintStyle: const TextStyle(
        //               fontSize: 14,
        //             ),
        //             hintText: "Search for a module..."),
        //       ),
        //     ),
        //     SizedBox(
        //       height: MediaQuery.of(context).size.height * 0.5,
        //       width: MediaQuery.of(context).size.width * 0.9,
        //       child: ListView.builder(
        //         // padding: const EdgeInsets.all(10),
        //         itemCount: moduleList.length,
        //         itemBuilder: _cardBuilder,
        //       ),
        //     ),
        //   ]),
        // ),
      ),
    );
  }

  void addModule(Modules newModule) {
    setState(() {
      widget.currentModules.add(newModule);
    });
  }

  void deleteModule(int i) {
    setState(() {
      widget.currentModules.removeAt(i);
      // inputCurrent();
    });
  }

  Widget _currentModulesBuilder(BuildContext context, int i) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.book,
              color: colorTurqoise,
            ),
            title: Text(widget.currentModules[i].getModuleName),
            subtitle: Text(widget.currentModules[i].getCode),
            trailing: IconButton(
              onPressed: () {
                deleteModule(i);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  showConfirmUpdate(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: (() async => false),
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  title: const Text("Alert"),
                  content: const Text(
                      'New Groups will be created for the newly added modules'),
                  actions: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 2, color: colorTurqoise)),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: colorTurqoise),
                        )),
                  ]);
            }),
          );
        });
  }

  Widget topDesign() {
    return const Scaffold(
      body: Text('Edit Module List'),
    );
  }

  Widget buildAddButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        final results = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddModulesPage(
                      user: widget.user,
                      currentModules: widget.currentModules,
                    )));
        setState(() {
          widget.currentModules += results;
        });
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Modules'),
      backgroundColor: colorTurqoise,
    );
  }
}
