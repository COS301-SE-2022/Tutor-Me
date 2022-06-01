import 'package:http/http.dart' as http;
import 'dart:async';

class APIServices {
  static Uri tutorURL = Uri.https('localhost:7062', '/api/Tutors');
  static Future fetchTutor() async {
    try {
      print("breakpoint 1");
      final response = await http.get(tutorURL);
      print("done with http");
      if (response.statusCode == 200) {
        print("breakpoint 2" + response.body);
        return response;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
