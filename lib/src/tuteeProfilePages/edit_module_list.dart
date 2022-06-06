import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../services/models/modules.dart';

class EditModuleList extends StatefulWidget {
  const EditModuleList({Key? key}) : super(key: key);

  @override
  _EditModuleListState createState() => _EditModuleListState();
}

class _EditModuleListState extends State<EditModuleList> {
  final textControl = TextEditingController();
  List<Modules> moduleList = List<Modules>.empty();
  List<Modules> saveModule = List<Modules>.empty();
  String query = '';

  void search(String search) {
    if (search == '') {
      moduleList = saveModule;
    }
    final modules = moduleList.where((module) {
      // final codeToLower = module.getCode.toLowerCase();
      final nameToLower = module.getModuleName.toLowerCase();
      final query = search.toLowerCase();

      return nameToLower.contains(query);
    }).toList();

    setState(() {
      moduleList = modules;
      query = search;
    });
  }

  getModules() async {
    final modules = await ModuleServices.getModules();
    setState(() {
      moduleList = modules;
      saveModule = modules;
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
          title: const Text("Edit Module List"),
          backgroundColor: colorOrange,
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
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
                                moduleList = saveModule;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: colorOrange, width: 1.0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "Search for a module..."),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                // padding: const EdgeInsets.all(10),
                itemCount: moduleList.length,
                itemBuilder: _cardBuilder,
              ),
            ),
            
          ]),
        ));
  }

  void addModule(String code, String name) {}

  Widget _cardBuilder(BuildContext context, int i) {
    String name = moduleList[i].getModuleName;
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.red, width: 1),
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
            title: Text(name),
            subtitle: Text(moduleList[i].getCode),
            trailing: Checkbox(
              activeColor: Colors.green,
              checkColor: Colors.white,
              value: false,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget topDesign() {
    return const Scaffold(
      body: Text('Edit Module List'),
    );
  }

  // Widget buildBody() {}
}
