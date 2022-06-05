// import 'dart:html';

class Tutees {
  String _id = "";
  String _lastName = "";
  String _firstName = "";
  String _bio = "";
  String _location = "";
  String _age = "";
  String _institution = "";
  String _modules = "";

  Tutees(this._id, this._age, this._firstName, this._lastName, this._bio, this._location, this._institution, this._modules);

  String get getId => _id;
  String get getName => _lastName;
  String get getFirstName => _firstName;
  String get getBio => _bio;
  String get getLocation => _location;
  String get getAge => _age;
  String get getInstitution => _institution;
  String get getModules => _modules;

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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["bio"] = _bio;
    map["location"] = _location;
    map["age"] = _age;
    map["institution"] = _institution;
    map["modules"] = _modules;
    map["id"] = _id;
    return map;
  }

  Tutees.fromObject(dynamic o) {
    _id = o["id"];
    _firstName = o["firstName"];
    _lastName = o["lastName"];
    _bio = o["bio"];
     _location = o["location"];
    _age = o["age"];
    _institution = o["institution"];
    _modules = o["modules"];
  }

  static fromJson(model) {}
}
