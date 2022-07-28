class Groups {
  String _id = "";
  String _moduleCode = "";
  String _moduleName = "";
  String _tutees = "";
  String _tutorId = "";
  String _description = "";
  String _groupLink = "";

  Groups(this._id, this._moduleCode, this._moduleName, this._tutees,
      this._tutorId, this._description, this._groupLink);

  String get getId => _id;
  String get getModuleCode => _moduleCode;
  String get getModuleName => _moduleName;
  String get getTutees => _tutees;
  String get getTutorId => _tutorId;
  String get getDescription => _description;
  String get getGroupLink => _groupLink;

  set setId(String newId) {
    _id = newId;
  }

  set setModuleCode(String newModuleCode) {
    _moduleCode = newModuleCode;
  }

  set setModuleName(String newModuleName) {
    _moduleName = newModuleName;
  }

  set setTutees(String newTutees) {
    _tutees = newTutees;
  }

  set setTutorId(String newTutorId) {
    _tutorId = newTutorId;
  }

  set setDescription(String newDescription) {
    _description = newDescription;
  }

  set setGroupLink(String newGroupLink) {
    _groupLink = newGroupLink;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["moduleCode"] = _moduleCode;
    map["moduleName"] = _moduleName;
    map["tutees"] = _tutees;
    map['tutorId'] = _tutorId;
    map['description'] = _description;
    map['groupLink'] = _groupLink;
    return map;
  }

  Groups.fromObject(dynamic o) {
    _id = o["id"];
    _moduleCode = o["moduleCode"];
    _moduleName = o["moduleName"];
    _tutees = o["tutees"];
    _tutorId = o['tutorId'];
    _description = o['description'];
    _groupLink = o['groupLink'];
  }

  static fromJson(model) {}
}
