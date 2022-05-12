// import 'dart:html';

class Tutors {
  String _id;
  String _lastName;
  String _firstName;
  String _bio;
  String _location;
  int _age;
  String _institution;
  String _moduless;

  Tutors(this._id, this._age, this._firstName, this._lastName, this._bio,
      this._location, this._institution, this._moduless);

  String get getId => _id;
  String get getName => _lastName;
  String get getFirstNname => _firstName;
  String get getBio => _bio;
  String get getLocation => _location;
  int get getAge => _age;
  String get getInstitution => _institution;
  String get getModules => _moduless;

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

  set setAge(int newAge) {
    _age = newAge;
  }

  set setInstitution(String newInstitution) {
    _institution = newInstitution;
  }

  set setModules(String newModules) {
    _moduless = newModules;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["bio"] = _bio;
    map["location"] = _location;
    map["age"] = _age;
    map["institution"] = _institution;
    map["moduless"] = _moduless;
    map["id"] = _id;
    return map;
  }

  fromObject(dynamic o) {
    _id = o["id"];
    _firstName = o["first_name"];
    _lastName = o["last_name"];
    _bio = o["bio"];
    _location = o["location"];
    _age = o["age"];
    _institution = o["institution"];
    _moduless = o["moduless"];
  }
}
