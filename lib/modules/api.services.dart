import 'package:http/http.dart' as http;
import 'dart:async';

class APIServices {

  static Uri tutorURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Tutors');

  static Future fetchTutor() async {

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
