// import 'dart:html';

class Tutors {
  String _id = "";
  String _lastName = "";
  String _firstName = "";
  String _bio = "";
  String _location = "";
  String _age = "";
  String _email = "";
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
    this._age,
    this._firstName,
    this._lastName,
    this._bio,
    this._location,
    this._institution,
    this._modules,
    this._rating,
    this._course,
    this._status,
    this._faculty,
    this._email,
    this._gender,
    this._connections,
  );

  String get getId => _id;
  String get getName => _lastName;
  String get getFirstName => _firstName;
  String get getBio => _bio;
  String get getLocation => _location;
  String get getAge => _age;
  String get getInstitution => _institution;
  String get getModules => _modules;
  String get getRating => _rating;
  String get getCourse => _course;
  String get getStatus => _status;
  String get getFaculty => _faculty;
  String get getEmail => _email;
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

  set setAge(String newAge) {
    _age = newAge;
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

  set setStatus(String newStatus) {
    _status = newStatus;
  }

  set setFaculty(String newFaculty) {
    _faculty = newFaculty;
  }

  set setEmail(String newEmail) {
    _email = newEmail;
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
    map["age"] = _age;
    map["institution"] = _institution;
    map["modules"] = _modules;
    map["id"] = _id;
    map["rating"] = _rating;
    map["course"] = _course;
    map["status"] = _status;
    map["faculty"] = _faculty;
    map["email"] = _email;
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
    _age = o["age"];
    _institution = o["institution"];
    _modules = o["modules"];
    _rating = o["rating"];
    _course = o["course"];
    _status = o["status"];
    _faculty = o["faculty"];
    _email = o["email"];
    _gender = o["gender"];
    _connections = o["connections"];
  }

  static fromJson(model) {}
}
