// import 'dart:developer';

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/services/institution_services.dart';
import 'package:tutor_me/src/tutorProfilePages/pdfViewer/pdf_viewer.dart';
import '../../services/models/users.dart';
import '../../services/services/user_services.dart';
import '../colorpallete.dart';

class TutorDetails {
  Users tutor;
  String institution;
  Uint8List? transcript;
  bool hasTranscript;
  TutorDetails(
      this.tutor, this.institution, this.transcript, this.hasTranscript);
}

class ReviewTutor extends StatefulWidget {
  final Globals globals;

  const ReviewTutor({Key? key, required this.globals}) : super(key: key);

  @override
  ReviewTutorState createState() => ReviewTutorState();
}

class ReviewTutorState extends State<ReviewTutor> {
  List<Users> tutors = List.empty(growable: true);
  List<String> institutions = List.empty(growable: true);
  List<Uint8List> transcripts = List.empty(growable: true);
  List<bool> hasTranscript = List.empty(growable: true);
  List<TutorDetails> tutorDetails = List.empty(growable: true);
  int currentIndex = 0;
  bool isLoading = true;

  getTutors() async {
    tutors = await UserServices.getTutors(widget.globals);
    tutors.removeWhere((tutor) => tutor.getIsVerified == true);
    getTutorDetails();
  }

  getTutorDetails() async {
    try {
      for (var tutor in tutors) {
        final institution = await InstitutionServices.getUserInstitution(
            tutor.getInstitutionID, widget.globals);

        institutions.add(institution.getName);
        //TODO: get transcripts
        //  final transcript = await UserServices.getTranscript(tutor,widget.globals);

      }
      log(institutions.toString());
    } catch (e) {
      const snackBar = SnackBar(content: Text('Error loading tutors'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    getTranscripts();
  }

  getTranscripts() async {
    for (var tutor in tutors) {
      log('again');

      try {
        final transcript =
            await UserServices.getTutorTranscript(tutor.getId, widget.globals);
        transcripts.add(transcript);
        hasTranscript.add(true);
      } catch (e) {
        log(e.toString());
        Uint8List? empty = Uint8List(128);
        transcripts.add(empty);
        hasTranscript.add(false);
      }
    }

    for (int i = 0; i < tutors.length; i++) {
      tutorDetails.add(TutorDetails(
          tutors[i], institutions[i], transcripts[i], hasTranscript[i]));
    }

    tutorDetails.removeWhere((tutor) => tutor.hasTranscript == false);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTutors();
  }

  List<Color> colors = [
    const Color.fromARGB(255, 106, 161, 206),
    const Color.fromARGB(255, 106, 155, 42),
    const Color.fromARGB(255, 255, 230, 0),
    const Color.fromARGB(255, 255, 123, 0),
  ];

  getRandomColor() {
    return colors[currentIndex++ % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: colorBlueTeal,
        title: const Center(child: Text('Review Tutors')),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: tutorDetails.length,
                itemBuilder: _cardBuilder,
              ),
            ),
      backgroundColor: Colors.black,
    );
  }

  Widget _cardBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04),
      child: Card(
        color: Colors.blueGrey,
        elevation: 5,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.015,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: getRandomColor(),
              ),
            ),
            ListTile(
              title: Text(
                tutorDetails[index].tutor.getName +
                    ' ' +
                    tutorDetails[index].tutor.getLastName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                ),
              ),
              subtitle: Text(
                tutorDetails[index].tutor.getEmail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Age: " + tutorDetails[index].tutor.getAge,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Gender: " + tutorDetails[index].tutor.getGender,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Institution: " + tutorDetails[index].institution,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: tutorDetails[index].hasTranscript
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PDFViewer(
                                          pdf: tutorDetails[index].transcript!,
                                        )));
                          }
                        : null,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.open_in_new),
                          Text(' View Transcript'),
                        ]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorBlueTeal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => RecordingScreen(
                      //             videoURL:  "https://cdn.videosdk.live/encoded/videos/63161d681d5e14bac5db733a.mp4"
                      //             )));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.verified),
                          Text(' Verify Tutor')
                        ]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      // if (await canLaunchUrlString(_meetingIdList[index])) {
                      //   await launchUrlString(_meetingIdList[index],
                      //       mode: LaunchMode.externalApplication);
                      // }
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Icon(Icons.cancel), Text(' Decline')]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
