// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:tutor_me/src/authenticate/register_step3.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/models/users.dart';
import '../components.dart';
import 'register_step1.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RegisterStep2 extends StatefulWidget {
  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController confirmPasswordController = TextEditingController();
  final email;
  final password;
  final confirmPassword;
  final toRegister;

  const RegisterStep2(
      {Key? key,
      this.email,
      this.password,
      this.confirmPassword,
      this.toRegister})
      : super(key: key);

  @override
  _RegisterStep2State createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode genderFocusNode = FocusNode();
  final FocusNode calendarFocusNode = FocusNode();
  final FocusNode institutionFocusNode = FocusNode();
  final FocusNode courseFocusNode = FocusNode();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController calendarController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  DateTime dateOfBirth = DateTime.now().subtract(const Duration(days: 6205));
  String formattedDate = "Date Of Birth";
  DateTime dateOver = DateTime.now().subtract(const Duration(days: 36500));

  late Users tutor;
  late Users tutee;

  List<IconData> iconsgender = [Icons.female, Icons.male, Icons.man];

  // List of items in our dropdown menu
  List<String> items = [
    'F - Female',
    'M - Male',
    'O - Other',
  ];

  String gender = 'F - Female';
  int indexOfOption = 2;
  int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black, Colors.transparent],
            ).createShader(rect),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Pictures/register_login.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black54,
                        BlendMode.darken,
                      ))),
            ),
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Flexible(
                child: Text(
                  'Lets Continue...',
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Theme(
                  data: ThemeData(
                      primarySwatch: Colors.green,
                      canvasColor: Colors.transparent,
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                          secondary: colorOrange, primary: colorOrange)),
                  child: Stepper(
                    type: StepperType.horizontal,
                    steps: getSteps(),
                    currentStep: currentStep,
                  ),
                ),
              ),
              TextInputField(
                icon: Icons.person_outline,
                hint: 'Enter Full Name',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: firstNameController,
                // inputFocus: firstNameFocusNode,
              ),
              TextInputField(
                icon: Icons.person_outline,
                hint: 'Enter Last Name',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: lastNameController,
                // inputFocus: lastNameFocusNode,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.01),
                child: DropdownButton<String>(
                  dropdownColor: colorOrange,
                  icon: Icon(Icons.arrow_drop_down,
                      color: colorWhite,
                      size: MediaQuery.of(context).size.width * 0.08),
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.height * 0.06,
                  ),
                  // ignore: unnecessary_null_comparison
                  hint: gender == null
                      ? Row(
                          children: [
                            const Icon(
                              Icons.female,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              'Select Gender',
                              style: TextStyle(
                                color: colorWhite,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.woman,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              gender,
                              style: const TextStyle(color: colorWhite),
                            ),
                          ],
                        ),
                  isExpanded: true,
                  value: gender,
                  items: items.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Row(
                          children: [
                            Icon(
                              iconsgender[indexOfOption],
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              val,
                              style: TextStyle(
                                color: colorWhite,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        gender = val!;
                        indexOfOption = items.indexOf(val);
                      },
                    );
                  },
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[500]!.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorOrange,
                    width: 1,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.01),
                decoration: BoxDecoration(
                  color: Colors.grey[500]!.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorOrange,
                    width: 1,
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      icon:
                          const Icon(Icons.calendar_month, color: Colors.white),
                      labelText: formattedDate,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      )),
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDateOfBirth = await showDatePicker(
                        context: context,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: colorBlueTeal,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: colorOrange,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        initialDate: dateOfBirth,
                        firstDate: dateOver,
                        lastDate: dateOfBirth);

                    if (newDateOfBirth == null) return;

                    setState(() {
                      dateOfBirth = newDateOfBirth;
                      formattedDate =
                          DateFormat('dd/MM/yyyy').format(dateOfBirth);
                    });
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorOrange,
                ),
                child: TextButton(
                  onPressed: () async {
                    String errMsg = "";

                    if (gender == "") {
                      gender = "";
                    } else {
                      gender = gender.substring(0, 1);
                    }

                    if (firstNameController.text == "" ||
                        lastNameController.text == "" ||
                        gender == "") {
                      errMsg += "One or more parametres missing\n";
                    }

                    if (formattedDate == "Date Of Birth") {
                      errMsg += "Your Date of birth is missing\n";
                    }

                    if (errMsg != "") {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("One Or More Errors Occured"),
                            content: Text(errMsg),
                            backgroundColor: colorWhite,
                            titleTextStyle: TextStyle(
                              color: colorOrange,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "Retry",
                                  style: TextStyle(color: colorDarkGrey),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterStep1()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterStep3(
                                email: widget.email,
                                password: widget.password,
                                confirmPassword: widget.confirmPassword,
                                fullName: firstNameController.text,
                                lastName: lastNameController.text,
                                dob: formattedDate,
                                gender: gender,
                                toRegister: widget.toRegister)),
                      );
                    }
                  },
                  child: const Text("Continue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text(
            'Personal',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text(
            'Education',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Container(),
        ),
      ];
}
