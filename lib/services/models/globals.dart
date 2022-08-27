import 'package:tutor_me/services/models/modules.dart';
import 'package:tutor_me/services/models/requests.dart';
import 'package:tutor_me/services/models/users.dart';

class Globals {
  late Users _tutors;
  late Users _tutees;
  late Modules _modules;
  late Requests _requests;
  String _filesUrl = '';
  String _tutorMeUrl = '';

  Globals(Users? tutors, Users? tutees, Modules? modules, Requests? requests,
      String? filesUrl, String? tutorMeUrl);

  Users get getTutors => _tutors;
  Users get getTutees => _tutees;
  Modules get getModules => _modules;
  Requests get getRequests => _requests;
  String get getFilesUrl => _filesUrl;
  String get getTutorMeUrl => _tutorMeUrl;

  set setTutor(Users tutors) {
    _tutors = tutors;
  }

  set setTutee(Users tutees) {
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
