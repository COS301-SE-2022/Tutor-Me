// import 'dart:html';

class Modules {
  String _moduleId = "";
  String _code = "";
  String _moduleName = "";
  String _institutionID = "";
  String _faculty = "";
  String _year = '';

  Modules(this._moduleId, this._code, this._moduleName, this._institutionID,
      this._faculty, this._year);

  String get getModuleId => _moduleId;
  String get getCode => _code;
  String get getModuleName => _moduleName;
  String get getInstitution => _institutionID;
  String get getFaculty => _faculty;
  String get getYear => _year;

  set setModuleId(String newModuleId) {
    _moduleId = newModuleId;
  }

  set setCode(String newCode) {
    _code = newCode;
  }

  set setModuleName(String newModuleName) {
    _moduleName = newModuleName;
  }

  set setInstitution(String newInstitution) {
    _institutionID = newInstitution;
  }

  set setFaculty(String newFaculty) {
    _faculty = newFaculty;
  }

  set setYear(String newYear) {
    _year = newYear;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["moduleId"] = _moduleId;
    map["code"] = _code;
    map["moduleName"] = _moduleName;
    map["institutionID"] = _institutionID;
    map["faculty"] = _faculty;
    map['year'] = _year;
    return map;
  }

  Modules.fromObject(dynamic o) {
    _moduleId = o["moduleId"];
    _code = o["code"];
    _moduleName = o["moduleName"];
    _institutionID = o["institutionId"];
    _faculty = o["faculty"];
    _year = o['year'];
  }

  static fromJson(model) {}
}
