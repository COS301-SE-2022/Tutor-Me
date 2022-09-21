import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tuteeProfilePages/tutee_profile.dart';

import '../../services/models/globals.dart';
import '../../services/models/groups.dart';
import '../../services/models/modules.dart';

// ignore: must_be_immutable

class Module {
  Modules module;
  bool selected;

  Module(this.module, this.selected);
}

// ignore: must_be_immutable
class AddModulesPage extends StatefulWidget {
  final Globals globals;
  List<Modules> currentModules;
  AddModulesPage(
      {Key? key, required this.globals, required this.currentModules})
      : super(key: key);

  @override
  _AddModulesPageState createState() => _AddModulesPageState();
}

class _AddModulesPageState extends State<AddModulesPage> {
  List<Modules> modulesToRemove = List<Modules>.empty(growable: true);
  List<Modules> modulesToAdd = List<Modules>.empty(growable: true);
  List<Modules> confirmedModules = List<Modules>.empty();
  List<Module> modules = List<Module>.empty(growable: true);
  List<Module> saveModule = List<Module>.empty();
  List<Groups> tutorGroups = List<Groups>.empty();
  final textControl = TextEditingController();
  List<Modules> moduleList = List<Modules>.empty();

  String query = '';
  bool isCurrentOpen = true;
  bool isAllOpen = false;
  bool isConfirming = false;
  bool _isLoading = true;

  void inputCurrent() {
    confirmedModules = widget.currentModules;
    for (int i = 0; i < widget.currentModules.length; i++) {
      updateModules(widget.currentModules[i]);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void updateModules(Modules cModule) {
    String cName = cModule.getModuleName;
    String cCode = cModule.getCode;
    final checkModules = modules.where((module) {
      final nameToLower = module.module.getModuleName.toLowerCase();
      final codeToLower = module.module.getCode.toLowerCase();
      final cNameToLower = cName.toLowerCase();
      final cCodeToLower = cCode.toLowerCase();

      return !nameToLower.contains(cNameToLower) &&
          !codeToLower.contains(cCodeToLower);
    }).toList();
    setState(() {
      modules = checkModules;
      saveModule = modules;
    });
    getTutorGroups();
  }

  void search(String search) {
    if (search == '') {
      modules = saveModule;
    }
    final checkModules = modules.where((module) {
      final nameToLower = module.module.getModuleName.toLowerCase();
      final codeToLower = module.module.getCode.toLowerCase();
      final query = search.toLowerCase();

      return nameToLower.contains(query) || codeToLower.contains(query);
    }).toList();

    setState(() {
      modules = checkModules;
      query = search;
    });
  }

  getModules() async {
    final fetchedModules = await ModuleServices.getModules(widget.globals);

    moduleList = fetchedModules;
    log(moduleList.length.toString());

    for (var element in moduleList) {
      modules.add(Module(element, false));
    }

    setState(() {
      modules = modules;
      saveModule = modules;
    });

    inputCurrent();
  }

  getTutorGroups() async {
    final groups = await GroupServices.getGroupByUserID(
        widget.globals.getUser.getId, widget.globals);

    tutorGroups = groups;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getModules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Modules"),
        backgroundColor: colorBlueTeal,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : moduleList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.book,
                        size: MediaQuery.of(context).size.height * 0.09,
                        color: colorOrange,
                      ),
                      const Text('No Modules Available')
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          height: 50,
                          child: TextField(
                            onChanged: (value) => search(value),
                            controller: textControl,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(0),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.black45,
                                ),
                                suffixIcon: query.isNotEmpty
                                    ? GestureDetector(
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.black45,
                                        ),
                                        onTap: () {
                                          textControl.clear();
                                          setState(() {
                                            modules = saveModule;
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorBlueTeal, width: 1.0),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                hintText: "Search for a module..."),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                          // padding: const EdgeInsets.all(10),
                          itemCount: modules.length,
                          itemBuilder: _cardBuilder,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            top: MediaQuery.of(context).size.width * 0.04,
                            right: MediaQuery.of(context).size.width * 0.08,
                            bottom: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: SmallTagBtn(
                              btnName: "Done",
                              backColor: colorOrange,
                              funct: () {
                                Navigator.pop(context, modulesToAdd);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = modules[i].module.getModuleName;
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
              color: colorOrange,
            ),
            title: Text(name),
            subtitle: Text(modules[i].module.getCode),
            trailing: Checkbox(
              value: modules[i].selected,
              onChanged: (bool? value) {
                setState(() {
                  modules[i].selected = value!;
                  if (value) {
                    modulesToAdd.add(modules[i].module);
                  } else {
                    modulesToAdd.remove(modules[i].module);
                  }
                });
              },
            ),
          )
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
                            side:
                                const BorderSide(width: 2, color: colorOrange)),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: colorOrange),
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
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddModulesPage(
                      globals: widget.globals,
                      currentModules: widget.currentModules,
                    ))).then((value) {
          if (value != null) {
            setState(() {
              widget.currentModules = value;
            });
          }
        });
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Modules'),
      backgroundColor: colorOrange,
    );
  }
}
