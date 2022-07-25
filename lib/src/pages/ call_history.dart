import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CallHistoryState();
  }
}

class CallHistoryState extends State<CallHistory> {
  // ignore: non_constant_identifier_names
  var call_belongs_to = [
    'Musa Mabasa',
    'Group - COS 301 (Tutor: Kuda)',
    'Farai Chivunga',
    'Group - STK 220 (Tutor: Siphiwe) ',
    'Thabo Maduna',
    'Kuda Chris',
    'Kuda Chivunga',
    'Group - PHY114 (Tutor: Simphiwe)',
  ];

  var date = [
    'Today, 9:03 AM - missed',
    'Today, 9:10 AM - in',
    'Yesterday, 7:37 PM - in ',
    'Yesterday, 6:40 PM - out',
    'Yesterday, 4:18 PM - out',
    'Yesterday, 7:37 PM - in ',
    'Yesterday, 6:40 PM - out',
    'Yesterday, 4:18 PM - out'
  ];

  List<IconData> status = [
    Icons.call_missed,
    Icons.call_received,
    Icons.call_received,
    Icons.call_made,
    Icons.call_made,
    Icons.call_received,
    Icons.call_made,
    Icons.call_made
  ];
  List<Color> status_color = [
    colorRed,
    Colors.green,
    Colors.green,
    colorGrey,
    colorGrey,
    colorRed,
    Colors.green,
    colorGrey
  ];

  var profilePictures = [
    'https://cdn.pixabay.com/photo/2017/08/01/01/33/beanie-2562646__340.jpg\n',
    'https://cdn.pixabay.com/photo/2016/04/04/14/12/monitor-1307227__480.jpg\n'
        'https://cdn.pixabay.com/photo/2016/01/13/22/46/boy-1139042__340.jpg\n',
    'https://media.istockphoto.com/photos/businessman-trading-online-stock-market-on-teblet-screen-digital-picture-id1311598658?b=1&k=20&m=1311598658&s=170667a&w=0&h=Ln_dpeXRkCDCZjuqOe2r7AlWP29xHFbc9wyKzxajloA=\n',
    'assets/Pictures/penguin.png\n',
  ];

  void search(String search) {
    setState(() {
      //  tutors = tutors.where((tu) => false)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          // padding: const EdgeInsets.all(10),
          itemCount: 8,
          itemBuilder: _cardBuilder,
        ),
      ),
    ])));
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = call_belongs_to[i];

    return GestureDetector(
      child: Card(
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    "https://cdn.pixabay.com/photo/2016/03/23/04/01/woman-1274056__340.jpg"),
              ),
              title: Text(name),
              subtitle: Row(
                children: [
                  Icon(
                    status[i],
                    color: status_color[i],
                  ),
                  Text(date[i]),
                ],
              ),

              // trailing: ListView.builder(
              //   itemBuilder: _starBuilder,
              //   itemCount: 5,
              // ),
            ),
          ],
        ),
      ),
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (BuildContext context) => TutorProfilePageView(
        //         person: tutors[i],
        //         bio: bios[i],
        //         age: ages[i],
        //         location: location[i],
        //         gender: gender[i])));
      },
    );
  }
}
