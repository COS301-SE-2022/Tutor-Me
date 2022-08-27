class Users {
  String _id = "";
  String _firstName = "";
  String _lastName = "";
  String _dateOfBirth = "";
  bool _status = true;
  String _gender = "";
  String _email = "";
  String _password = "";
  String userTypeID = "";
  String _institutionID = "";
  String _location = "";
  String _bio = "";
  String _year = '';
  String _rating = "";
  String _age = "";

  Users(
      this._id,
      this._firstName,
      this._lastName,
      this._dateOfBirth,
      this._status,
      this._gender,
      this._email,
      this._password,
      this.userTypeID,
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
  String get getUserTypeID => userTypeID;
  String get getInstitutionID => _institutionID;
  String get getLocation => _location;
  String get getBio => _bio;
  String get getYear => _year;
  String get getRating => _rating;
  String get getAge => calculateAge(_dateOfBirth);

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

  set setRating(String newRating) {
    _rating = newRating;
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
    map["userTypeId"] = userTypeID;
    map["institutionId"] = _institutionID;
    map["location"] = _location;
    map["bio"] = _bio;
    map["year"] = _year;
    map["rating"] = _rating;
    return map;
  }

  Users.fromObject(dynamic o) {
    _id = o["id"];
    _firstName = o["firstName"];
    _lastName = o["lastName"];
    _bio = o["bio"];
    _location = o["location"];
    _status = o["status"];
    _dateOfBirth = o["dateOfBirth"];
    _gender = o["gender"];
    _email = o["email"];
    _password = o["password"];
    userTypeID = o["userTypeId"];
    _institutionID = o["institutionId"];
    _year = o["year"];
    _rating = o["rating"];
  }

  static fromJson(model) {}
}
