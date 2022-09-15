class Event {
  String _title;
  String _description;
  DateTime _date;
  DateTime _time;
  String _owner;

  Event(this._title, this._description, this._date, this._time, this._owner);
  
  String get getTitle => _title;
  String get getDescription => _description;
  DateTime get getDate => _date;
  DateTime get getTime => _time;
  String get getOwner => _owner;

  set setTitle(String newTitle) {
    _title = newTitle;
  }

  set setDescription(String newDescription) {
    _description = newDescription;
  }

  set setDate(DateTime newDate) {
    _date = newDate;
  }


  set setTime(DateTime newTime) {
    _time = newTime;
  }

  set setOwner(String newOwner) {
    _owner = newOwner;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["description"] = _description;
    map["date"] = _date;
    map["time"] = _time;
    map["owner"] = _owner;
    return map;
  }
}
