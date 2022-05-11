import 'package:flutter/material.dart';

class EditModule extends StatefulWidget {
  const EditModule({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditModulesState();
  }
}

class EditModulesState extends State<EditModule> {
  var _itemCount = 0;
  void increaseNum() {
    setState(() {
      _itemCount++;
    });
  }

  void decreaseNum() {
    setState(() {
      _itemCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 170,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Pictures/flower.jpg"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: const EdgeInsets.only(top: 60, left: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        // text: "Rose Tumil",
                        // style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Rose Tamil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 6.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepOrangeAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: null,
                      child: const Text("Tutee"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 95,
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width - 220,
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("assets/Pictures/profilePic.jpg")),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width - 270,
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromRGBO(214, 82, 7, 1),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 200,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 160,
              child: const Icon(
                Icons.edit_note,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 40,
            height: 450,
            width: 300,
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _itemCount,
              itemBuilder: _cardBuilder,
            ),
          ),
          Positioned(
            top:700,
            left:173,
            child: IconButton(onPressed: increaseNum, icon: const Icon(Icons.add_circle)))
        ],
      ),
    ));
  }

  Widget _cardBuilder(BuildContext context, int i) {
    return InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
              const ListTile(
              leading: SizedBox(
                height: 4,
                child:Text('calculas')
              )
            ),
            IconButton(onPressed: decreaseNum, icon: const Icon(Icons.delete))
          ],
        ),
      ),
      onTap: () {
        //Route to profile
      },
    );
  }
}
