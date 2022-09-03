class Groups {
  String _id = "";
  String _moduleId = "";
  String _description = "";
  String userId = "";

  Groups(this._id, this._description, this._moduleId, this.userId);

  String get getId => _id;
  String get getDescription => _description;
  String get getModuleId => _moduleId;
  String get getUserId => userId;

  set setId(String newId) {
    _id = newId;
  }

  set setDescription(String newDescription) {
    _description = newDescription;
  }

  set setModuleId(String newModuleId) {
    _moduleId = newModuleId;
  }

  set setUserId(String newUserId) {
    userId = newUserId;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map['description'] = _description;
    map['moduleId'] = _moduleId;
    map['userId'] = userId;
    return map;
  }

  Groups.fromObject(dynamic o) {
    _id = o["id"];
    _description = o['description'];
    _moduleId = o['moduleId'];
    userId = o['userId'];
  }

  static fromJson(model) {}
}
