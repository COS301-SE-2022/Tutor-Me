// import 'dart:html';

class Requests {
  String _id = "";
  String _requesterId = "";
  String _receiverId = "";
  String _dateCreated = "";

  Requests(this._id, this._requesterId, this._receiverId, this._dateCreated);

  String get getCode => _code;
  String get getModuleName => _moduleName;
  String get getInstitution => _institution;
  String get getFaculty => _faculty;

  set setID(String newId) {
    _id = newId;
  }

  set setRequesterId(String newRequesterId) {
    _requesterId = newRequesterId;
  }

  set setReceiverId(String newReceiverId) {
    _receiverId = newReceiverId;
  }

  set setDateCreated(String newDateCreated) {
    _dateCreated = newDateCreated;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["moduleName"] = _moduleName;
    map["institution"] = _institution;
    map["faculty"] = _faculty;
    return map;
  }

  Requests.fromObject(dynamic o) {
    _id = o["id"];
    _receiverId = o["receiverId"];
    _requesterId = o["requesterId"];
    _dateCreated = o["dateCreated"];
  }

  static fromJson(model) {}
}
