import 'dart:html';

class Tutors {
  String _id;
  String _last_name;
  String _first_name;
  String _bio;
  String _location;
  int _age;
  String _institution;
  String _moduless;

  Tutors(this._id, this._age, this._first_name, this._last_name, this._bio,
      this._location, this._institution, this._moduless);

  String get id => _id;
  String get last_name => _last_name;
  String get first_name => _first_name;
  String get bio => _bio;
  String get location => _location;
  int get age => _age;
  String get institution => _institution;
  String get modules => _moduless;

  set first_name(String newFirstName) {
    _first_name = newFirstName;
  }

  set last_name(String newLastName) {
    _last_name = newLastName;
  }

  set bio(String newbio) {
    _bio = newbio;
  }

  set location(String newLocation) {
    _first_name = newLocation;
  }

  set age(int newAge) {
    _age = newAge;
  }

  set institution(String newInstitution) {
    _institution = newInstitution;
  }

  set moduless(String newModules) {
    _moduless = newModules;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["first_name"] = _first_name;
    map["last_name"] = _last_name;
    map["bio"] = _bio;
    map["location"] = _location;
    map["age"] = _age;
    map["institution"] = _institution;
    map["moduless"] = _moduless;

    if (id != null) {
      map["id"] = _id;
    }

    return map;
  }

  // Tutors.fromObject(dynamic o) {
  //   this._id = o["id"];
  //   this._first_name = o["first_name"];
  //   this._last_name = o["last_name"];
  //   this._bio = o["bio"];
  //   this._location = o["location"];
  //   this._age = o["age"];
  //   this._institution = o["institution"];
  //   this._moduless = o["moduless"];
  // }
}
