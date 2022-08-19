// import 'dart:html';

class Requests {
  String _id = "";
  String _requesterId = "";
  String _receiverId = "";
  String _dateCreated = "";
  String _moduleCode = "";

  Requests(this._id, this._requesterId, this._receiverId, this._dateCreated,
      this._moduleCode);

  String get getId => _id;
  String get getRequesterId => _requesterId;
  String get getReceiverId => _receiverId;
  String get getDateCreated => _dateCreated;
  String get getModuleCode => _moduleCode;

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

  set setModuleCode(String newModuleCode) {
    _moduleCode = newModuleCode;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["receiverId"] = _receiverId;
    map["requesterId"] = _requesterId;
    map["dateCreated"] = _dateCreated;
    map["moduleCode"] = _moduleCode;
    return map;
  }

  Requests.fromObject(dynamic o) {
    _id = o["id"];
    _receiverId = o["receiverId"];
    _requesterId = o["requesterId"];
    _dateCreated = o["dateCreated"];
    _moduleCode = o["moduleCode"];
  }

  static fromJson(model) {}
}
