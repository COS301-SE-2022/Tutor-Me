class Users {
  String _id = "";
  String _firstName = "";
  String _lastName = "";
  String _dateOfBirth = "";
  bool _status = true;
  String _gender = "";
  String _email = "";
  String _password = "";
  String _userTypeID = "";
  String _institutionID = "";
  String _location = "";
  String _bio = "";
  String _year = '';
  int _rating = 0;
  String _age = "";
  int _numberOfReviews = 0;
  bool _isVerified = false;

  Users(
      this._id,
      this._firstName,
      this._lastName,
      this._dateOfBirth,
      this._status,
      this._gender,
      this._email,
      this._password,
      this._userTypeID,
      this._institutionID,
      this._location,
      this._bio,
      this._year,
      this._rating,
      this._age);

  String get getId => _id;
  String get getName => _firstName;
  String get getLastName => _lastName;
  String get getDateOfBirth => _dateOfBirth;
  bool get getStatus => _status;
  String get getGender => _gender;
  String get getEmail => _email;
  String get getPassword => _password;
  String get getUserTypeID => _userTypeID;
  String get getInstitutionID => _institutionID;
  String get getLocation => _location;
  String get getBio => _bio;
  String get getYear => _year;
  int get getRating => _rating;
  int get getNumberOfReviews => _numberOfReviews;
  String get getAge => calculateAge(_dateOfBirth);
  bool get getIsVerified => _isVerified;

  set setStatus(bool newStatus) {
    _status = newStatus;
  }

  set setId(String newId) {
    _id = newId;
  }

  set setFirstName(String newFirstName) {
    _firstName = newFirstName;
  }

  set setLastName(String newLastName) {
    _lastName = newLastName;
  }

  set setBio(String newbio) {
    _bio = newbio;
  }

  set setLocation(String newLocation) {
    _location = newLocation;
  }

  String calculateAge(String date) {
    int age = 0;
    int year = 0;
    int month = 0;
    int day = 0;
    DateTime now = DateTime.now();
    List<String> dateList = date.split("/");
    year = int.parse(dateList[2]);
    month = int.parse(dateList[1]);
    day = int.parse(dateList[0]);

    if (month < now.month) {
      if (day < now.day) {
        age = now.year - year;
      } else {
        age = now.year - int.parse(dateList[2]) - 1;
      }
    } else {
      age = now.year - int.parse(dateList[2]) - 1;
    }
    _age = age.toString();
    setAge = age.toString();
    return _age.toString();
  }

  set setAge(String a) {
    _age = a;
  }

  set setEmail(String newEmail) {
    _email = newEmail;
  }

  set setPassword(String newPassword) {
    _password = newPassword;
  }

  set setGender(String newGender) {
    _gender = newGender;
  }

  set setYear(String newYear) {
    _year = newYear;
  }

  set setRating(int newRating) {
    _rating = newRating;
  }

  set setNumberOfReviews(int newNumberOfReviews) {
    _numberOfReviews = newNumberOfReviews;
  }

  set setISVerified(bool isVerified) {
    _isVerified = isVerified;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["userId"] = _id;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["dateOfBirth"] = _dateOfBirth;
    map["status"] = _status;
    map["gender"] = _gender;
    map["email"] = _email;
    map["password"] = _password;
    map["userTypeId"] = _userTypeID;
    map["institutionId"] = _institutionID;
    map["location"] = _location;
    map["bio"] = _bio;
    map["year"] = _year;
    map["rating"] = _rating;
    map["numberOfReviews"] = _numberOfReviews;
    map["verified"] = _isVerified;
    return map;
  }

  Users.fromObject(dynamic o) {
    _id = o["userId"];
    _firstName = o["firstName"];
    _lastName = o["lastName"];
    _dateOfBirth = o["dateOfBirth"];
    _status = o["status"];
    _gender = o["gender"];
    _email = o["email"];
    _password = o["password"];
    _userTypeID = o["userTypeId"];
    _institutionID = o["institutionId"];
    _location = o["location"];
    _bio = o["bio"];
    _year = o["year"];
    _rating = o["rating"];
    _numberOfReviews = o["numberOfReviews"];
    _isVerified = o["verified"];
  }
}

class UserType {
  String _id = "";
  String type = "";

  UserType(this._id, this.type);

  String get getId => _id;
  String get getType => type;

  set setId(String newId) {
    _id = newId;
  }

  set setType(String newType) {
    type = newType;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["userTypeId"] = _id;
    map["type"] = type;
    return map;
  }

  UserType.fromObject(dynamic o) {
    _id = o["userTypeId"];
    type = o["type"];
  }
}
