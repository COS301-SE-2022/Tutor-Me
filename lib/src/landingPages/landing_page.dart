import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tutor_me/src/authenticate/register_step1.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Container(
      color: colorWhite,
      child: Scaffold(
        backgroundColor: colorTurqoise.withOpacity(0.2),
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
                    "Learn and connect with peers",
                urlImage:
                    'assets/Pictures/undraw_visionary_technology_re_jfp7.svg',
                color: colorOrange,
                index: 0,
              ),
              buildPage(
                description:
                    "Connect to tutors or tutees. Join groups and request for tutors",
                urlImage:
                    'assets/Pictures/undraw_online_connection_6778.svg',
                color: colorTurqoise,
                index: 0,
              ),
              buildPage(
                description:
                    "Set up a profile and get ready to interact with your peers and tutors.",
                urlImage:
                    'assets/Pictures/undraw_account_re_o7id.svg',
                color: colorOrange,
                index: 0,
              ),
              buildPage(
                description: "Let's begin our learning journey",
                urlImage:
                    'assets/Pictures/undraw_maker_launch_re_rq81.svg',
                color: colorTurqoise,
                index: 0,
              ),
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
                    backgroundColor: colorOrange,
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
      ),
    );
  }

  Widget buildPage(
      {required String urlImage,
      required String description,
      required Color color,
      required int index}) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      ClipPath(
        clipper: OrangeClipper(),
        child: Container(
          color: colorOrange,
          height: screenHeight * 0.45,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: SvgPicture.asset(urlImage),
            height: screenHeight * 0.25,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
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
        ],
      ),
      SizedBox(
        height: screenHeight * 92,
        child: ClipPath(
          clipper: TurqoiseClipper(),
          child: Container(
            color: colorTurqoise,
            height: screenHeight * 0.5,
          ),
        ),
      ),
    ]);
  }
}

class OrangeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.5, size.width * 0.6, 0);
    path.lineTo(size.width * 0.6, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TurqoiseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.4, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.7, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
