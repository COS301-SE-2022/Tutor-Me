// import 'dart:html';

class UserModules {
  String _userModuleId = "";
  String _moduleId = "";
  String _userId = "";

  UserModules(this._userModuleId, this._moduleId, this._userId);

  String get getUserModuleId => _userModuleId;
  String get getModuleId => _moduleId;
  String get getUserId => _userId;

  set setUserModuleId(String newUserModuleId) {
    _userModuleId = newUserModuleId;
  }

  set setModuleId(String newModuleId) {
    _moduleId = newModuleId;
  }

  set setUserId(String newUserId) {
    _userId = newUserId;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["userModuleId"] = _userModuleId;
    map["moduleId"] = _moduleId;
    map["userId"] = _userId;
    return map;
  }

  UserModules.fromObject(dynamic o) {
    _userModuleId = o["userModuleId"];
    _moduleId = o["moduleId"];
    _userId = o["userId"];
  }
  
  static fromJson(model) {}
}
