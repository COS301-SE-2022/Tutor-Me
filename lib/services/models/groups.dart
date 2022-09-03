class Groups {
  String _id = "";
  String _moduleId = "";
  String _description = "";
  String userId = "";
  String videoId = "";

  Groups(
      this._id, this._description, this._moduleId, this.userId, this.videoId);

  String get getId => _id;
  String get getDescription => _description;
  String get getModuleId => _moduleId;
  String get getUserId => userId;
  String get getVideoId => videoId;

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

  set setVideoId(String newVideoId) {
    videoId = newVideoId;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['groupId'] = _id;
    map['moduleId'] = _moduleId;
    map['description'] = _description;
    map['userId'] = userId;
    map['videoId'] = videoId;
    return map;
  }

  Groups.fromObject(dynamic o) {
    _id = o["groupId"];
    _moduleId = o['moduleId'];
    _description = o['description'];
    userId = o['userId'];
    videoId = o['videoId'];
  }

  static fromJson(model) {}
}
