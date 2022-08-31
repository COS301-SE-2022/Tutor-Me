// import 'dart:html';

class Requests {
  String _id = "";
  String _tuteeId = "";
  String _tutorId = "";
  String _dateCreated = "";
  String _moduleId = "";

  Requests(this._id, this._tuteeId, this._tutorId, this._dateCreated,
      this._moduleId);

  String get getId => _id;
  String get getTuteeId => _tuteeId;
  String get getTutorId => _tutorId;
  String get getDateCreated => _dateCreated;
  String get getModuleId => _moduleId;

  set setID(String newId) {
    _id = newId;
  }

  set setRequesterId(String newRequesterId) {
    _tuteeId = newRequesterId;
  }

  set setReceiverId(String newReceiverId) {
    _tutorId = newReceiverId;
  }

  set setDateCreated(String newDateCreated) {
    _dateCreated = newDateCreated;
  }

  set setModuleID(String newModuleId) {
    _moduleId = newModuleId;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["requestId"] = _id;
    map["tuteeId"] = _tuteeId;
    map["tutorId"] = _tutorId;
    map["dateCreated"] = _dateCreated;
    map["moduleId"] = _moduleId;
    return map;
  }

  Requests.fromObject(dynamic o) {
    _id = o["requestId"];
    _tuteeId = o["tuteeId"];
    _tutorId = o["tutorId"];
    _dateCreated = o["dateCreated"];
    _moduleId = o["moduleId"];
  }

  static fromJson(model) {}
}
