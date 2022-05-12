class Tutee {
  // ignore: prefer_typing_uninitialized_variables
  var username;
  // ignore: prefer_typing_uninitialized_variables
  var location;
  // ignore: prefer_typing_uninitialized_variables
  var bio;
  // ignore: prefer_typing_uninitialized_variables
  var gender;
  // ignore: prefer_typing_uninitialized_variables
  var age;

  Tutee({this.bio, this.location, this.username, this.age, this.gender});

  void setAttributes(bio, location, username, gender, age) {
    this.bio =
        bio; //"I am hardworker,I absolutely love the field I am in.I'm constantly looking for ways to get things done";
    this.location = location; //'Evander, Secunda\n';
    this.username = username; //'Rose Tamil\n';
    this.gender = age; //'Female\n';
    this.age = age; //'21 years old\n';
  }
}
