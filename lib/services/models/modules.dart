// import 'dart:html';

class Modules {
  String _code = "";
  String _moduleName = "";
  String _institution = "";
  String _faculty = "";

  Modules(this._code, this._moduleName, this._institution, this._faculty);

  String get getCode => _code;
  String get getModuleName => _moduleName;
  String get getInstitution => _institution;
  String get getFaculty => _faculty;

  set setCode(String newCode) {
    _code = newCode;
  }

  set setModuleName(String newModuleName) {
    _moduleName = newModuleName;
  }

  set setInstitution(String newInstitution) {
    _institution = newInstitution;
  }

  set setFaculty(String newFaculty) {
    _faculty = newFaculty;
  }


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["moduleName"] = _moduleName;
    map["institution"] = _institution;
    map["faculty"] = _faculty;
    return map;
  }

  Modules.fromObject(dynamic o) {
    _code = o["code"];
    _moduleName = o["moduleName"];
    _institution = o["institution"];
    _faculty = o["faculty"];
  }

  static fromJson(model) {}
}
