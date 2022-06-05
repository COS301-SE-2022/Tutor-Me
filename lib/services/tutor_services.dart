import 'package:http/http.dart' as http;
import 'dart:async';

class TutorServices {

  

  static Future getTutors() async {
    Uri tutorURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Tutors');
    try {
      final response = await http.get(tutorURL,   headers: {
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

  static Future getTutor(String id) async {

    Uri tutorURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Tutors/$id');
    try {
      final response = await http.get(tutorURL,   headers: {
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
