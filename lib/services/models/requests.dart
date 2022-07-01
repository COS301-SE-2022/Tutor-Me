// import 'dart:html';

class Requests {
  String _id = "";
  String _requesterId = "";
  String _receiverId = "";
  String _dateCreated = "";

  Requests(this._id, this._requesterId, this._receiverId, this._dateCreated);

  String get getId => _id;
  String get getRequesterId => _requesterId;
  String get getReceiverId => _receiverId;
  String get getDateCreated => _dateCreated;

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
    map["id"] = _id;
    map["receiverId"] = _receiverId;
    map["requesterId"] = _requesterId;
    map["dateCreated"] = _dateCreated;
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
