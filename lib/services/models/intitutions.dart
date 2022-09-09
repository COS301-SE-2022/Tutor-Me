class Institutions {
  String _id = "";
  String _name = "";
  String _location = "";

  Institutions(this._id, this._name, this._location);

  String get getId => _id;
  String get getName => _name;
  String get getLocation => _location;

  set setId(String newId) {
    _id = newId;
  }

  set setName(String newName) {
    _name = newName;
  }

  set setLocation(String newLocation) {
    _location = newLocation;
  }

  Institutions.fromObject(dynamic o) {
    _id = o["institutionId"];
    _name = o["name"];
    _location = o["location"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["institutionId"] = _id;
    map["name"] = _name;
    map["location"] = _location;
    return map;
  }
}
