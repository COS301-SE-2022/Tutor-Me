import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/tutors.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class TutorServices {
  static getTutors() async {
    Uri tutorURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Tutors');
    try {
      final response = await http.get(tutorURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Tutors.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getTutor(String id) async {
    Uri tutorURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Tutors/$id');
    try {
      final response = await http.get(tutorURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Tutors.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      return null;
    }
  }

  static registerTutor(
      String name,
      String lastName,
      String date,
      String gender,
      String institution,
      String email,
      String password,
      String confirmPassword) async {
    List<Tutors> tutors = await getTutors();
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getEmail == email) {
        throw Exception("Email already exists");
      }
    }
    final modulesURL =
        Uri.https('tutormeapi.azurewebsites.net', '/api/Tutors/');
    int age = 0;
    int year = 0;
    int month = 0;
    int day = 0;
    DateTime now = DateTime.now();
    List<String> dateList = date.split("/");
    year = int.parse(dateList[2]);
    month = int.parse(dateList[1]);
    day = int.parse(dateList[0]);

    if (month < now.month) {
      if (day < now.day) {
        age = now.year - year;
      } else {
        age = now.year - int.parse(dateList[2]) - 1;
      }
    } else {
      age = now.year - int.parse(dateList[2]) - 1;
    }
    //source: https://protocoderspoint.com/flutter-encryption-decryption-using-flutter-string-encryption/#:~:text=open%20your%20flutter%20project%20that,IDE(android%2Dstudio).&text=Then%20after%20you%20have%20added,the%20password%20the%20user%20enter.

    String data = jsonEncode({
      'firstName': name,
      'lastName': lastName,
      'age': age.toString(),
      'gender': gender,
      'status': "T",
      'faculty': "None",
      'course': "None",
      'institution': institution,
      'modules': "",
      'location': "None",
      'tuteesCode': "",
      'email': email,
      'password': password,
      'bio': "None",
      'connections': "",
      'rating': 0.toString()
    });

    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    // print("record : " + record);
    // print("data : " + data);
    try {
      final response = await http.post(modulesURL, headers: header, body: data);
      if (response.statusCode == 201) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        List<Tutors> tutors =
            list.map((json) => Tutors.fromObject(json)).toList();
        return tutors[0];
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static logInTutor() {
    // TODO: implement logInTutor
  }
}
