import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';

class TuteeGroups extends StatelessWidget {
  const TuteeGroups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color(0xffD6521B),
          centerTitle: true,
          title: const Text('My Tutee Groups'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                // borderRadius:
                //     BorderRadius.vertical(bottom: Radius.circular(60)),
                gradient: LinearGradient(
                    colors: <Color>[Colors.orange, Colors.red],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
        ),
        body: Center(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: colorGrey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2018/09/27/09/22/artificial-intelligence-3706562_960_720.jpg',
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      children: [
                        Text(" COS314 ",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              color: colorWhite,
                              fontWeight: FontWeight.bold,
                            )),
                        const Icon(Icons.circle, size: 7, color: colorOrange),
                        const Text("Artificial Intelligent"),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
