// import 'dart:html';

class Tutors {
  String _id = "";
  String _lastName = "";
  String _firstName = "";
  String _bio = "";
  String _location = "";
  String _tuteesCode = "";
  String _age = "";
  String _dateOfBirth = "";
  String _email = "";
  String _password = "";
  String _gender = "";
  String _institution = "";
  String _connections = "";
  String _modules = "";
  String _rating = "";
  String _course = "";
  String _status = "";
  String _faculty = "";

  Tutors(
    this._id,
    this._dateOfBirth,
    this._firstName,
    this._lastName,
    this._bio,
    this._location,
    this._tuteesCode,
    this._institution,
    this._modules,
    this._rating,
    this._course,
    this._status,
    this._faculty,
    this._email,
    this._password,
    this._gender,
    this._connections,
  );

  String get getId => _id;
  String get getName => _firstName;
  String get getLastName => _lastName;
  String get getBio => _bio;
  String get getLocation => _location;
  String get getTuteesCode => _tuteesCode;
  String get getAge => _age;
  String get getDateOfBirth => _dateOfBirth;
  String get getInstitution => _institution;
  String get getModules => _modules;
  String get getRating => _rating;
  String get getCourse => _course;
  String get getStatus => _status;
  String get getFaculty => _faculty;
  String get getEmail => _email;
  String get getPassword => _password;
  String get getGender => _gender;
  String get getConnections => _connections;

  set setId(String newId) {
    _id = newId;
  }

  set setFirstName(String newFirstName) {
    _firstName = newFirstName;
  }

  set setLastName(String newLastName) {
    _lastName = newLastName;
  }

  set setBio(String newbio) {
    _bio = newbio;
  }

  set setLocation(String newLocation) {
    _location = newLocation;
  }

  set setTuteesCode(String newTuteesCode) {
    _tuteesCode = newTuteesCode;
  }

  set setAge(String newAge) {
    int age = 0;
    int year = 0;
    int month = 0;
    int day = 0;
    DateTime now = DateTime.now();
    List<String> dateList = newAge.split("/");
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
    _age = age.toString();
  }

  set setInstitution(String newInstitution) {
    _institution = newInstitution;
  }

  set setModules(String newModules) {
    _modules = newModules;
  }

  set setRating(String newRating) {
    _rating = newRating;
  }

  set setCourse(String newCourse) {
    _course = newCourse;
  }

  set setDateOfBirth(String newDateOfBirth) {
    _dateOfBirth = newDateOfBirth;
  }

  set setStatus(String newStatus) {
    _status = newStatus;
  }

  set setFaculty(String newFaculty) {
    _faculty = newFaculty;
  }

  set setEmail(String newEmail) {
    _email = newEmail;
  }

  set setPassword(String newPassword) {
    _password = newPassword;
  }

  set setGender(String newGender) {
    _gender = newGender;
  }

  set setConnections(String newConnections) {
    _connections = newConnections;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["bio"] = _bio;
    map["location"] = _location;
    map["tuteesCode"] = _tuteesCode;
    map["dateOfBirth"] = _dateOfBirth;
    map["institution"] = _institution;
    map["modules"] = _modules;
    map["id"] = _id;
    map["rating"] = _rating;
    map["course"] = _course;
    map["status"] = _status;
    map["faculty"] = _faculty;
    map["email"] = _email;
    map["password"] = _password;
    map["gender"] = _gender;
    map["connections"] = _connections;
    return map;
  }

  Tutors.fromObject(dynamic o) {
    _id = o["id"];
    _firstName = o["firstName"];
    _lastName = o["lastName"];
    _bio = o["bio"];
    _location = o["location"];
    _tuteesCode = o["tuteesCode"];
    _dateOfBirth = o["dateOfBirth"];
    _institution = o["institution"];
    _modules = o["modules"];
    _rating = o["rating"];
    _course = o["course"];
    _status = o["status"];
    _faculty = o["faculty"];
    _email = o["email"];
    _password = o["password"];
    _gender = o["gender"];
    _connections = o["connections"];
  }

  static fromJson(model) {}
}
