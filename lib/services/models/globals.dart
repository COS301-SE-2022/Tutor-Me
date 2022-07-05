import 'package:tutor_me/services/models/modules.dart';
import 'package:tutor_me/services/models/requests.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/services/models/tutors.dart';

class Globals {
  late Tutors _tutors;
  late Tutees _tutees;
  late Modules _modules;
  late Requests _requests;
  String _filesUrl = '';
  String _tutorMeUrl = '';

  Globals(Tutors? tutors, Tutees? tutees, Modules? modules, Requests? requests, String? filesUrl, String? tutorMeUrl);

  Tutors get getTutors => _tutors;
  Tutees get getTutees => _tutees;
  Modules get getModules => _modules;
  Requests get getRequests => _requests;
  String get getFilesUrl => _filesUrl;
  String get getTutorMeUrl => _tutorMeUrl;

  set setTutor(Tutors tutors) {
    _tutors = tutors;
  }

  set setTutee(Tutees tutees) {
    _tutees = tutees;
  }

  set setModules(Modules modules) {
    _modules = modules;
  }

  set setRequests(Requests requests) {
    _requests = requests;
  }

  set setGetFilesUrl(String filesUrl) {
    _filesUrl = filesUrl;
  }

  set setTutorMeUrl(String tutorMeUrl) {
    _tutorMeUrl = tutorMeUrl;
  }
}
