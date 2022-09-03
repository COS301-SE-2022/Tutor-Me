import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tutor_me/src/authenticate/register_step1.dart';
import 'package:tutor_me/src/colorpallete.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LandingPageState();
  }
}

class LandingPageState extends State<LandingPage> {
  PageController pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    super.dispose();

    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: screenSize.height * 0.08),
        child: PageView(
          onPageChanged: (index) {
            if (index == 3) {
              setState(() {
                isLastPage = true;
              });
            } else {
              setState(() {
                isLastPage = false;
              });
            }
          },
          controller: pageController,
          children: [
            buildPage(
                description:
                    "In a word where technology is leading our lives. Learning and technology are becoming more intertwined.",
                urlImage: 'assets/Pictures/technology.jpg'),
            buildPage(
                description:
                    "This app will allow student who need help with subjects to connect to tutor who will help with said subjects.",
                urlImage: 'assets/Pictures/onlineLesson.jpg'),
            buildPage(
                description:
                    "Set up a profile and get ready to interact with your peers and tutors.",
                urlImage: 'assets/Pictures/undraw_account_re_o7id.svg'),
            buildPage(
                description: "Let's begin our learning journey",
                urlImage: 'assets/Pictures/undraw_maker_launch_re_rq81.svg'),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: colorWhite,
                  minimumSize: Size.fromHeight(screenSize.height * 0.08)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterStep1()));
              })
          : SizedBox(
              // padding: EdgeInsets.symmetric(horizontal: screenSize.height * 0.9),

              height: screenSize.height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  Center(
                      child: SmoothPageIndicator(
                    controller: pageController,
                    count: 4,
                    effect: const ScrollingDotsEffect(
                      radius: 14,
                      activeDotColor: colorOrange,
                      spacing: 15,
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Next',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      IconButton(
                        onPressed: () {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.linear);
                        },
                        icon: const Icon(Icons.arrow_circle_right),
                        iconSize: screenSize.height * 0.05,
                        color: colorOrange,
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage({required String urlImage, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //     image: AssetImage(urlImage),
        //     fit: BoxFit.fill,
        //   )),
        // ),
        Image.asset(urlImage),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
        ),
        Container(
          child: Text(
            description,
            style: const TextStyle(
                fontSize: 18,
                color: colorTurqoise,
                fontWeight: FontWeight.w600),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.14),
        ),
        // isLastPage
        //     ?
        //     : Container()
      ],
    );
  }
}
