import 'package:flutter/material.dart';
import 'Navigation/nav_drawer.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var people = ['John doe', 'Doe John', 'John Doe', 'Doe John', 'John Doe'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.chat_bubble_rounded), text: 'Chat'),
                Tab(icon: Icon(Icons.person), text: 'Request'),
                Tab(icon: Icon(Icons.phone), text: 'Calls')
              ],
            ),
            backgroundColor: const Color(0xffD6521B),
            centerTitle: true,
            title: const Text('Tutor Me'),
            actions: const <Widget>[],
          ),
          body: Column(
            children: <Widget>[
              for (var i in people)
                InkWell(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text('John'),
                          subtitle: Text('I am a Machenical engineer student'),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    //Route to profile
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

 
}