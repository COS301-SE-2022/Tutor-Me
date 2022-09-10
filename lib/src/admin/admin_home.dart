import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_me/src/authenticate/register_or_login.dart';
import 'package:tutor_me/src/authenticate/register_step1.dart';
import '../../services/models/globals.dart';
import 'admin.dart';

class AdminHome extends StatefulWidget {
  final Globals global;
  const AdminHome({Key? key, required this.global}) : super(key: key);

  @override
  AdminHomeState createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Admin'),
        backgroundColor: const Color.fromRGBO(10, 13, 44, 1),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterStep1()));
              },
              icon: Image.asset("assets/Pictures/TutorLogo.png", width: 30))
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: <Widget>[
          // const SizedBox(
          //   height: 110,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16, right: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Text(
          //             "Farai Chivunga",
          //             style: GoogleFonts.openSans(
          //                 textStyle: const TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 18,
          //                     fontWeight: FontWeight.bold)),
          //           ),
          //           const SizedBox(
          //             height: 4,
          //           ),
          //           Text(
          //             "Admin",
          //             style: GoogleFonts.openSans(
          //                 textStyle: const TextStyle(
          //                     color: Color(0xffa29aac),
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.w600)),
          //           ),
          //         ],
          //       ),
          //       IconButton(
          //         alignment: Alignment.topCenter,
          //         icon: Image.asset(
          //           "assets/Pictures/TutorLogo.png",
          //           width: 30,
          //         ),
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const RegisterOrLogin()),
          //           );
          //         },
          //       )
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 40,
          ),
          Admin(
            global: widget.global,
          )
        ],
      ),
    );
  }
}
