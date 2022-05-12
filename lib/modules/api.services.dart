import 'package:http/http.dart' as http;

class APIServices {
  static String tutorURL = 'https://localhost:44356/api/tutors';
  static Future fetchTutor() async {
    return await http.get(Uri.parse(tutorURL));
  }
}
