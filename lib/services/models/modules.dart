// import 'dart:html';

class Modules {
  String _code = "";
  String _moduleName = "";
  String _institution = "";
  String _faculty = "";
  String _year = '';

  Modules(this._code, this._moduleName, this._institution, this._faculty,
      this._year);

  String get getCode => _code;
  String get getModuleName => _moduleName;
  String get getInstitution => _institution;
  String get getFaculty => _faculty;
  String get getYear => _year;

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

  set setYear(String newYear) {
    _year = newYear;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["moduleName"] = _moduleName;
    map["institution"] = _institution;
    map["faculty"] = _faculty;
    map['year'] = _year;
    return map;
  }

  Modules.fromObject(dynamic o) {
    _code = o["code"];
    _moduleName = o["moduleName"];
    _institution = o["institution"];
    _faculty = o["faculty"];
    _year = o['year'];
  }

  static fromJson(model) {}
}
