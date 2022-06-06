import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/tutors.dart';

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
        throw Exception('Failed to load');
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
        return response;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      return null;
    }
  }
}
