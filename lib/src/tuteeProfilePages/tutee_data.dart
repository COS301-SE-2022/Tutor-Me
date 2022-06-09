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
  var connections=[];

  Tutee({this.bio, this.location, this.username, this.age, this.gender});

  void setAttributes(bio, location, username, age, gender) {
    this.bio =
        bio; //"I am hardworker,I absolutely love the field I am in.I'm constantly looking for ways to get things done";
    this.location = location; //'Evander, Secunda\n';
    this.username = username; //'Rose Tamil\n';
    this.gender = gender; //'Female\n';
    this.age ='21 years old\n'; //'21 years old\n';
    connections = ["c79fbb77-3674-48f1-aee2-389b15490da6","f5b88fb9-a702-4394-89ed-5fce49174cdc"];
  }
}
