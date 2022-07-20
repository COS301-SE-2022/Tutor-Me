// import 'package:flutter/material.dart';
// import 'package:tutor_me/services/models/tutees.dart';
// import 'package:tutor_me/services/services/module_services.dart';
// import 'package:tutor_me/services/services/tutor_services.dart';
// import 'package:tutor_me/src/colorpallete.dart';
// import 'package:tutor_me/src/tuteeProfilePages/tutee_profile.dart';

// import '../../../services/services/tutee_services.dart';

// // import '../../services/models/modules.dart';

// class EditModuleList extends StatefulWidget {
//   final dynamic user;
//   const EditModuleList({Key? key, required this.user}) : super(key: key);

//   @override
//   _EditModuleListState createState() => _EditModuleListState();
// }

// class _EditModuleListState extends State<EditModuleList> {
//   final textControl = TextEditingController();
//   List<Tutees> participants = List<Tutees>.empty();
//   List<Tutees> saveParticipant = List<Tutees>.empty();
//   String query = '';
//   bool isCurrentOpen = true;
//   bool isAllOpen = false;
//   List<Tutees> currentModules = List<Tutees>.empty();


//   getParticipants() async {
//     final modules = await TuteeServices.getTutees();
//     setState(() {
//       participants = modules;
//       saveParticipant = modules;
//     });
//   }

//   getTutorGroupParticipants() async {
//     final current = await Tu.getParticipants(widget.user.getId);
//     setState(() {
//       currentModules = current;
//     });
//   }

//   getTuteeCurrentModules() async {
//     final current = await TuteeServices.getTuteeModules(widget.user.getId);
//     setState(() {
//       currentModules = current;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getModules();

//     if (widget.user is Tutors) {
//       getTutorCurrentModules();
//     } else {
//       getTuteeCurrentModules();
//     }
//     inputCurrent();
//   }

//   @override
//   Widget build(BuildContext context) {
//     inputCurrent();
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Edit Module List"),
//           backgroundColor: colorOrange,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               ExpansionPanelList.radio(
//                 children: [
//                   ExpansionPanelRadio(
//                     value: const Text("Current Modules"),
//                     canTapOnHeader: true,
//                     headerBuilder: (context, isOpen) {
//                       return const ListTile(
//                         title: Text(
//                           "Current Modules",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       );
//                     },
//                     body: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.5,
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       child: ListView.builder(
//                         itemBuilder: _currentModulesBuilder,
//                         itemCount: currentModules.length,
//                       ),
//                     ),
//                   ),
//                   ExpansionPanelRadio(
//                     canTapOnHeader: true,
//                     value: const Text("Availabe modules"),
//                     headerBuilder: (context, isOpen) {
//                       return const ListTile(
//                           title: Text(
//                         "Available Modules",
//                         style: TextStyle(fontSize: 20),
//                       ));
//                     },
//                     body: Column(children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(15),
//                         height: 50,
//                         child: TextField(
//                           onChanged: (value) => search(value),
//                           controller: textControl,
//                           decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.all(0),
//                               prefixIcon: const Icon(
//                                 Icons.search,
//                                 color: Colors.black45,
//                               ),
//                               suffixIcon: query.isNotEmpty
//                                   ? GestureDetector(
//                                       child: const Icon(
//                                         Icons.close,
//                                         color: Colors.black45,
//                                       ),
//                                       onTap: () {
//                                         textControl.clear();
//                                         setState(() {
//                                           moduleList = saveModule;
//                                         });
//                                       },
//                                     )
//                                   : null,
//                               border: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: colorOrange, width: 1.0),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               hintStyle: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                               hintText: "Search for a module..."),
//                         ),
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.5,
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         child: ListView.builder(
//                           // padding: const EdgeInsets.all(10),
//                           itemCount: moduleList.length,
//                           itemBuilder: _cardBuilder,
//                         ),
//                       ),
//                     ]),
//                   )
//                 ],
//                 expansionCallback: (i, isOpen) {
//                   setState(() {
//                     if (i == 0) {
//                       isCurrentOpen = !isCurrentOpen;
//                     } else {
//                       isAllOpen = !isAllOpen;
//                     }
//                   });
//                 },
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.45,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         left: MediaQuery.of(context).size.width * 0.1,
//                         top: MediaQuery.of(context).size.width * 0.04,
//                         right: MediaQuery.of(context).size.width * 0.08,
//                         bottom: MediaQuery.of(context).size.width * 0.05,
//                       ),
//                       child: SmallTagBtn(
//                           btnName: "Cancel",
//                           backColor: Colors.red,
//                           funct: () {
//                             Navigator.pop(context);
//                           }),
//                     ),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.45,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).size.width * 0.04,
//                         right: MediaQuery.of(context).size.width * 0.1,
//                         bottom: MediaQuery.of(context).size.width * 0.05,
//                       ),
//                       child: SmallTagBtn(
//                           btnName: "Confirm",
//                           backColor: Colors.green,
//                           funct: () async {
//                             String modules = "";
//                             for (int i = 0; i < currentModules.length; i++) {
//                               modules += currentModules[i].getCode;
//                               if (i != currentModules.length - 1) {
//                                 modules += ',';
//                               }
//                             }
//                             widget.user.setModules = modules;
//                             widget.user.setStatus = "F";
//                             Navigator.pop(context);

//                             if (widget.user is Tutors) {
//                               await TutorServices.updateTutor(widget.user);
//                             } else {
//                               await TuteeServices.updateTutee(widget.user);
//                             }
//                           }),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }

//   void addModule(Modules newModule) {
//     setState(() {
//       currentModules.add(newModule);
//     });
//   }

//   void deleteModule(int i) {
//     setState(() {
//       currentModules.removeAt(i);
//       getModules();
//       inputCurrent();
//     });
//   }

//   Widget _currentModulesBuilder(BuildContext context, int i) {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(color: Colors.red, width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           ListTile(
//             leading: const Icon(
//               Icons.book,
//               color: colorTurqoise,
//             ),
//             title: Text(currentModules[i].getModuleName),
//             subtitle: Text(currentModules[i].getCode),
//             trailing: IconButton(
//               onPressed: () {
//                 deleteModule(i);
//               },
//               icon: const Icon(Icons.delete),
//               color: Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _cardBuilder(BuildContext context, int i) {
//     String name = moduleList[i].getModuleName;
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(color: Colors.red, width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           ListTile(
//             leading: const Icon(
//               Icons.book,
//               color: colorTurqoise,
//             ),
//             title: Text(name),
//             subtitle: Text(moduleList[i].getCode),
//             trailing: IconButton(
//               onPressed: () {
//                 addModule(moduleList[i]);
//               },
//               icon: const Icon(
//                 Icons.add_circle,
//                 color: Colors.green,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget topDesign() {
//     return const Scaffold(
//       body: Text('Edit Module List'),
//     );
//   }

//   // Widget buildBody() {}
// }
