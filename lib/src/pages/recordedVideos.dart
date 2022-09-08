import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';

class RecordedVideos extends StatefulWidget {
  const RecordedVideos({Key? key}) : super(key: key);

  @override
  State<RecordedVideos> createState() => _RecordedVideosState();
}

class _RecordedVideosState extends State<RecordedVideos> {
  int currentIndex = 0;

  // ignore: non_constant_identifier_names
  List<Color> colors = [
    // const Color.fromARGB(255, 94, 8, 145),
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
        backgroundColor: colorOrange,
        title: const Center(child: Text('Recorded Videos')),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          // padding: const EdgeInsets.all(10),
          itemCount: 5,
          itemBuilder: _cardBuilder,
        ),
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04),
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.015,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: getRandomColor(),
                // image: DecorationImage(
                //   image: AssetImage('assets/Pictures/tutorCover.jpg'),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            ListTile(
              // leading: const CircleAvatar(
              //   radius: 30,
              //   backgroundImage: AssetImage('assets/Pictures/video.jpg'),
              // ),
              title: Text(
                'Video' ' ' + (index + 1).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
              subtitle: const Text('Mathematics'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Text('Date: 12/12/2021'),
                Text('Duration: 12:00'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorTurqoise,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Download',
                      style: TextStyle(color: colorWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 184, 180, 180),
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
