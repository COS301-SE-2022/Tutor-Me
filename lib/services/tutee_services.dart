import 'package:http/http.dart' as http;
import 'dart:async';

class TuteeServices {

  

  static Future getTutees() async {
    Uri tutorURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Tutees');
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

  static Future getTutee(String id) async {

    Uri tutorURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Tutors/$id');
    try {
      final response = await http.get(tutorURL,   headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*"
      });
      print(response.body + response.statusCode.toString());
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
