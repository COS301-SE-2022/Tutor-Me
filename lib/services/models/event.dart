class Event {
  String _title = "";
  String _description = "";
  String _dateOfEvent = "";
  String _timeOfEvent = "";
  String _userId = "";
  String _groupId = "";
  String _videoLink = "";
  String _ownerId = "";

  Event(this._title, this._description, this._dateOfEvent, this._timeOfEvent,
      this._userId, this._groupId, this._videoLink, this._ownerId);

  set title(String title) {
    _title = title;
  }

  set description(String description) {
    _description = description;
  }

  set dateOfEvent(String dateOfEvent) {
    _dateOfEvent = dateOfEvent;
  }

  set timeOfEvent(String timeOfEvent) {
    _timeOfEvent = timeOfEvent;
  }

  set groupId(String groupId) {
    _groupId = groupId;
  }

  set videoLink(String videoLink) {
    _videoLink = videoLink;
  }

  set ownerId(String ownerId) {
    _ownerId = ownerId;
  }

  String get getTitle => _title;
  String get getDescription => _description;
  String get getDateOfEvent => _dateOfEvent;
  String get getTimeOfEvent => _timeOfEvent;
  String get getGroupId => _groupId;
  String get getVideoLink => _videoLink;
  String get getUserId => _userId;
  String get getOwnerId => _ownerId;

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['title'] = _title;
    data['description'] = _description;
    data['dateOfEvent'] = _dateOfEvent;
    data['timeOfEvent'] = _timeOfEvent;
    data['userId'] = _userId;
    data['groupId'] = _groupId;
    data['videoLink'] = _videoLink;
    data['ownerId'] = _ownerId;
    return data;
  }

  Event.fromObject(dynamic o) {
    _title = o["title"];
    _description = o['description'];
    _dateOfEvent = o['dateOfEvent'];
    _timeOfEvent = o['timeOfEvent'];
    _userId = o['userId'];
    _groupId = o['groupId'];
    _videoLink = o['videoLink'];
    _ownerId = o['ownerId'];
  }
}
