class Event {
  String _title = "";
  String _description = "";
  DateTime _dateOfEvent = DateTime.now();
  DateTime _timeOfEvent = DateTime.now();
  String _userId = "";
  String _groupId = "";
  String _videoLink = "";

  Event(this._title, this._description, this._dateOfEvent, this._timeOfEvent,
      this._userId, this._groupId, this._videoLink);

  set title(String title) {
    _title = title;
  }

  set description(String description) {
    _description = description;
  }

  set dateOfEvent(DateTime dateOfEvent) {
    _dateOfEvent = dateOfEvent;
  }

  set timeOfEvent(DateTime timeOfEvent) {
    _timeOfEvent = timeOfEvent;
  }

  set groupId(String groupId) {
    _groupId = groupId;
  }

  set videoLink(String videoLink) {
    _videoLink = videoLink;
  }

  String get getTitle => _title;
  String get getDescription => _description;
  DateTime get getDateOfEvent => _dateOfEvent;
  DateTime get getTimeOfEvent => _timeOfEvent;
  String get getGroupId => _groupId;
  String get getVideoLink => _videoLink;

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['title'] = this._title;
    data['description'] = this._description;
    data['dateOfEvent'] = this._dateOfEvent;
    data['timeOfEvent'] = this._timeOfEvent;
    data['userId'] = this._userId;
    data['groupId'] = this._groupId;
    data['videoLink'] = this._videoLink;
    return data;
  }

  Event.fromObject(dynamic o) {
    _title = o["title"];
    _description = o['description'];
    _dateOfEvent = DateTime.parse(o['dateOfEvent']);
    _timeOfEvent = DateTime.parse(o['timeOfEvent']);
    _userId = o['userId'];
    _groupId = o['groupId'];
    _videoLink = o['videoLink'];
  }
}
