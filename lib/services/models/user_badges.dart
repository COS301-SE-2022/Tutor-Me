class UserBadge {
  String _userBadgeId = "";
  String _userId = "";
  String _badgeId = "";
  int _pointAchieved = 0;

  UserBadge(this._userId, this._badgeId, this._pointAchieved);

  String get getUserBadgeId => _userBadgeId;
  String get getUserId => _userId;
  String get getBadgeId => _badgeId;
  int get getPointAchieved => _pointAchieved;

  set setUserBadgeId(String newUserBadgeId) {
    _userBadgeId = newUserBadgeId;
  }

  set setUserId(String newUserId) {
    _userId = newUserId;
  }

  set setBadgeId(String newBadgeId) {
    _badgeId = newBadgeId;
  }

  set setPointAchieved(int newPointAchieved) {
    _pointAchieved = newPointAchieved;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["userBadgeId"] = _userBadgeId;
    map["userId"] = _userId;
    map["badgeId"] = _badgeId;
    map["pointAchieved"] = _pointAchieved;
    return map;
  }

  UserBadge.fromObject(dynamic o) {
    _userBadgeId = o["userBadgeId"];
    _userId = o["userId"];
    _badgeId = o["badgeId"];
    _pointAchieved = o["pointAchieved"];
  }
}
