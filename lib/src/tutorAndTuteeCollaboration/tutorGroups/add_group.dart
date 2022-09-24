

import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/group_services.dart';

import '../../../services/models/globals.dart';
import '../../../services/models/modules.dart';
import '../../../services/services/module_services.dart';
import '../../colorpallete.dart';

class Module {
  Modules module;
  bool selected;

  Module(this.module, this.selected);
}

class AddGroup extends StatefulWidget {
  final Globals globals;
  const AddGroup({Key? key, required this.globals}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<Modules> currentModules = List<Modules>.empty(growable: true);
  List<Module> modules = List<Module>.empty(growable: true);
  List<Modules> selectedModules = List<Modules>.empty(growable: true);
  bool _isLoading = true;
  bool isConfirming = false;
  getCurrentModules() async {
    try {
      final currentModulesList = await ModuleServices.getUserModules(
          widget.globals.getUser.getId, widget.globals);
      setState(() {
        currentModules = currentModulesList;
      });
    } catch (e) {
      const snackBar = SnackBar(content: Text('Error loading'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    for (var i = 0; i < currentModules.length; i++) {
      modules.add(Module(currentModules[i], false));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentModules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm'),
        backgroundColor: colorBlueTeal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(

        label: const Text('Confirm'),
        onPressed: () async {
          if (selectedModules.isEmpty) {
            const snackBar = SnackBar(content: Text('No modules selected'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            setState(() {
              isConfirming = true;
            });
            try {
              for (int i = 0; i < selectedModules.length; i++) {
                await GroupServices.createGroup(selectedModules[i].getModuleId,
                    widget.globals.getUser.getId, widget.globals);
              }
            } catch (e) {
              const snackBar = SnackBar(content: Text('Error creating group'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            setState(() {
              isConfirming = false;
            });
          }
        },
        backgroundColor: colorBlueTeal,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.separated(
              itemCount: modules.length,
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
                });
                if (value == true) {
                  selectedModules.add(modules[i].module);
                } else {
                  selectedModules.remove(modules[i].module);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
