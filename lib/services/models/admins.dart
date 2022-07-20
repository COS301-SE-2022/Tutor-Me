// import 'dart:html';

class Admins {
  String _id = "";
  String _name = "";
  String _email = "";
  String _password = "";

  Admins(this._id, this._name, this._email, this._password);

  String get getId => _id;
  String get getName => _name;
  String get getEmail => _email;
  String get getPassword => _password;

  set setId(String newId) {
    _id = newId;
  }

  set setName(String newName) {
    _name = newName;
  }

  set setEmail(String newEmail) {
    _email = newEmail;
  }

  set setPassword(String newPassword) {
    _password = newPassword;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["email"] = _email;
    map["password"] = _password;
    return map;
  }

  Admins.fromObject(dynamic o) {
    _id = o["id"];
    _name = o["name"];
    _email = o["email"];
    _password = o["password"];
  }

  static fromJson(model) {}
}
