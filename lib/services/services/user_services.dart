import 'dart:io';
import 'dart:typed_data';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tutor_me/services/models/modules.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/users.dart';
import 'package:tutor_me/services/services/module_services.dart';

import '../models/requests.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class UserServices {
  //
  sendRequest(String receiverId, String requesterId, String moduleId) async {
    try {
      final url = Uri.http(
          'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Requests');

      final header = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      };

      var now = DateTime.now();
      var changeFormat = DateFormat('dd/MM/yyyy');
      String dateCreated = changeFormat.format(now);
      final data = jsonEncode({
        'requestId': moduleId,
        'tuteeId': requesterId,
        'tutorId': receiverId,
        'dateCreated': dateCreated,
        'moduleId': moduleId
      });
      final response = await http.post(url, body: data, headers: header);
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Failed to send request. Please make sure your internet connect is on and try again ' +
                response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getTutorRequests(String id) async {
    final url = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Requests/Tutor/$id');
    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Requests.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getTuteeRequests(String id) async {
    final url = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Requests/Tutee/$id');
    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Requests.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getRequest(String id) async {
    Uri url = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Requests/$id');
    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Requests.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  declineRequest(String id) async {
    try {
      final url = Uri.http(
          'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Requests/$id');
      final header = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      };
      final response = await http.delete(url, headers: header);
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
            'Failed to decline. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //

  acceptRequest(String requestId) async {
    try {
      final url = Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com',
          'api/Requests/$requestId');
      final header = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      };
      final response = await http.put(url, headers: header);
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
            'Failed to accept. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static deleteUser(String id) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final usersURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Users/$id');
      final response = await http.delete(usersURL, headers: header);
      if (response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204) {
        Fluttertoast.showToast(
            msg: "Tutee Deleted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to delete User",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception(
            'Failed to delete Tutee' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future getTutor(String id) async {
    Uri tuteeURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Users/$id');
    try {
      final response = await http.get(tuteeURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getTutee(String id) async {
    Uri tuteeURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Users/$id');
    try {
      final response = await http.get(tuteeURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getTutees() async {
    Uri tuteeURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Users/tutees');
    try {
      final response = await http.get(tuteeURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getUser(String id) async {
    Uri userURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Users/$id');
    try {
      final response = await http.get(userURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getUserType(String userTypeId) async {
    Uri userURL = Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com',
        '/api/UserTypes/$userTypeId');
    try {
      final response = await http.get(userURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        final UserType type = UserType.fromObject(json.decode(response.body));
        return type;
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getTutors() async {
    Uri tutorURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Users/tutors');
    try {
      final response = await http.get(tutorURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getConnections(String id) async {
    Uri connectionsURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Connections/$id');
    try {
      final response = await http.get(connectionsURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future registerTutor(
      String name,
      String lastName,
      String date,
      String gender,
      String email,
      String password,
      String institution,
      String confirmPassword,
      String year) async {
    final modulesURL = Uri.parse(
        'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Users/');

    //source: https://protocoderspoint.com/flutter-encryption-decryption-using-flutter-string-encryption/#:~:text=open%20your%20flutter%20project%20that,IDE(android%2Dstudio).&text=Then%20after%20you%20have%20added,the%20password%20the%20user%20enter.

    password = hashPassword(password);
    String data = jsonEncode({
      'userId': institution,
      'firstName': name,
      'lastName': lastName,
      'dateOfBirth': date,
      'status': false,
      'gender': gender,
      'email': email,
      'password': password,
      'userTypeID': "7654103a-01ba-4277-b5e9-82746855f9f4",
      'institutionId': institution,
      'location': "No Location added",
      'bio': "No bio added",
      'year': year,
      'rating': 0,
      'numberOfReviews': 0
    });

    final header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*"
    };
    try {
      final response = await http.post(modulesURL, headers: header, body: data);
      if (response.statusCode == 200) {
        final Users user = Users.fromObject(response.body);
        // await createFileRecord(tutors[0].getId);
        return user;
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static registerTutee(
      String name,
      String lastName,
      String date,
      String gender,
      String email,
      String password,
      String institution,
      String confirmPassword,
      String year) async {
    List<Users> tutees = await getTutees();
    for (int i = 0; i < tutees.length; i++) {
      if (tutees[i].getEmail == email) {
        throw Exception("Email already exists");
      }
    }
    final modulesURL =
        Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Users/');
    //source: https://protocoderspoint.com/flutter-encryption-decryption-using-flutter-string-encryption/#:~:text=open%20your%20flutter%20project%20that,IDE(android%2Dstudio).&text=Then%20after%20you%20have%20added,the%20password%20the%20user%20enter.
    password = hashPassword(password);

    String data = jsonEncode({
      'firstName': name,
      'lastName': lastName,
      'dateOfBirth': date,
      'status': "true",
      'gender': gender,
      'email': email,
      'password': password,
      'userTypeID': "54cca757-54ec-4671-a714-64208c5197fb",
      'institutionId': institution,
      'location': "No Location added",
      'bio': "No bio added",
      'year': year,
      'rating': 0,
      'numberOfReviews': 0
    });

    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final response = await http.post(modulesURL, headers: header, body: data);
      if (response.statusCode == 201) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        List<Users> tutees =
            list.map((json) => Users.fromObject(json)).toList();
        //initialize the files record too
        await createFileRecord(tutees[0].getId);
        return tutees[0];
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTutee(Users tutee) async {
    List<Users> tutees = await getTutees();
    for (int i = 0; i < tutees.length; i++) {
      if (tutees[i].getEmail == tutee.getEmail &&
          tutees[i].getId != tutee.getId) {
        throw Exception("Email already exists");
      }
    }
    String data = jsonEncode({
      'id': tutee.getId,
      'firstName': tutee.getName,
      'lastName': tutee.getLastName,
      'dateOfBirth': tutee.getDateOfBirth,
      'status': tutee.getStatus,
      'gender': tutee.getGender,
      'email': tutee.getEmail,
      'password': tutee.getPassword,
      'userTypeID': tutee.getUserTypeID,
      'institutionId': tutee.getInstitutionID,
      'location': tutee.getLocation,
      'bio': tutee.getBio,
      'year': tutee.getYear,
      'rating': tutee.getRating
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutee.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Users/Tutees/$id');
      final response = await http.put(modulesURL, headers: header, body: data);
      if (response.statusCode == 204) {
        return tutee;
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTuteeByEmail(String oldEmail, String newEmail) async {
    Users tutee = await getTuteeByEmail(oldEmail);
    if (isThereTuteeByEmail(newEmail) == false) {
      tutee.setEmail = newEmail;
      await UserServices.updateTutee(tutee);
    }

    String data = jsonEncode({
      'id': tutee.getId,
      'firstName': tutee.getName,
      'lastName': tutee.getLastName,
      'dateOfBirth': tutee.getDateOfBirth,
      'status': tutee.getStatus,
      'gender': tutee.getGender,
      'email': tutee.getEmail,
      'password': tutee.getPassword,
      'userTypeID': tutee.getUserTypeID,
      'institutionId': tutee.getInstitutionID,
      'location': tutee.getLocation,
      'bio': tutee.getBio,
      'year': tutee.getYear,
      'rating': tutee.getRating
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutee.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Users/Tutees/$id');
      final response = await http.put(modulesURL, headers: header, body: data);
      if (response.statusCode == 204) {
        Fluttertoast.showToast(
            msg: "Tutee Email Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return tutee;
      } else {
        Fluttertoast.showToast(
            msg: "Failed To Update Tutee Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTutor(Users tutor) async {
    String data = jsonEncode({
      'userId': tutor.getId,
      'firstName': tutor.getName,
      'lastName': tutor.getLastName,
      'dateOfBirth': tutor.getDateOfBirth,
      'status': tutor.getStatus,
      'gender': tutor.getGender,
      'email': tutor.getEmail,
      'password': tutor.getPassword,
      'userTypeID': tutor.getUserTypeID,
      'institutionId': tutor.getInstitutionID,
      'location': tutor.getLocation,
      'bio': tutor.getBio,
      'year': tutor.getYear,
      'rating': tutor.getRating,
      'numberOfReviews': tutor.getNumberOfReviews,
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutor.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Users/$id');
      final response = await http.put(modulesURL, headers: header, body: data);
      if (response.statusCode == 200) {
        return tutor;
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTutorByEmail(String oldEmail, String newEmail) async {
    Users tutor = await getTuteeByEmail(oldEmail);
    if (isThereTuteeByEmail(newEmail) == false) {
      tutor.setEmail = newEmail;
      await UserServices.updateTutee(tutor);
    }

    String data = jsonEncode({
      'id': tutor.getId,
      'firstName': tutor.getName,
      'lastName': tutor.getLastName,
      'dateOfBirth': tutor.getDateOfBirth,
      'status': tutor.getStatus,
      'gender': tutor.getGender,
      'email': tutor.getEmail,
      'password': tutor.getPassword,
      'userTypeID': tutor.getUserTypeID,
      'institutionId': tutor.getInstitutionID,
      'location': tutor.getLocation,
      'bio': tutor.getBio,
      'year': tutor.getYear,
      'rating': tutor.getRating
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutor.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Users/Tutors/$id');
      final response = await http.put(modulesURL, headers: header, body: data);
      if (response.statusCode == 204) {
        Fluttertoast.showToast(
            msg: "Tutee Email Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return tutor;
      } else {
        Fluttertoast.showToast(
            msg: "Failed To Update Tutee Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static getTutorModules(String id) async {
    try {
      List tutor = await getTutor(id);
      List moduleList = tutor[0].getModules.split(',');
      final allModules = await ModuleServices.getModules();
      List<Modules> modules = [];
      for (int i = 0; i < moduleList.length; i++) {
        for (int j = 0; j < allModules.length; j++) {
          if (moduleList[i] == allModules[j].getCode) {
            modules.add(allModules[j]);
          }
        }
      }

      return modules;
    } catch (e) {
      throw Exception(e);
    }
  }

  static getTuteeModules(String id) async {
    try {
      List tutee = await getUser(id);
      List moduleList = tutee[0].getModules.split(',');
      final allModules = await ModuleServices.getModules();
      List<Modules> modules = [];
      for (int i = 0; i < moduleList.length; i++) {
        for (int j = 0; j < allModules.length; j++) {
          if (moduleList[i] == allModules[j].getCode) {
            modules.add(allModules[j]);
          }
        }
      }

      return modules;
    } catch (e) {
      throw Exception(e);
    }
  }

  static logInTutor(String email, String password) async {
    String data = jsonEncode({
      'email': email,
      'password': password,
      'typeId': '7654103a-01ba-4277-b5e9-82746855f9f4'
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final modulesURL =
          Uri.parse('http://tutorme-dev.us-east-1.elasticbeanstalk.com/Login');
      final response = await http.post(modulesURL, headers: header, body: data);
      if (response.statusCode == 200) {
        final Users tutor = Users.fromObject(jsonDecode(response.body));
        return tutor;
        // return jsonDecode(response.body);
      } else {
        throw Exception('Failed to log in' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static createFileRecord(String id) async {
    String data =
        jsonEncode({'id': id, 'tuteeImage': '', 'tuteeTranscript': ''});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url = Uri.parse(
        'http://filesystem-prod.us-east-1.elasticbeanstalk.com/api/TuteeFiles');
    try {
      final response = await http.post(url, headers: header, body: data);
      if (response.statusCode == 201) {
        return true;
      } else {
        throw "failed to upload";
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateProfileImage(File? image, String id) async {
    final imageByte = base64Encode(image!.readAsBytesSync());
    String data =
        jsonEncode({'id': id, 'userImage': imageByte, 'userTranscript': ''});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url = Uri.parse(
        'http://tutorfilesystem-dev.us-east-1.elasticbeanstalk.com/api/UserFiles/$id');
    try {
      final response = await http.put(url, headers: header, body: data);
      if (response.statusCode == 200) {
        return image;
      } else {
        throw "failed to upload ${response.body}";
      }
    } catch (e) {
      rethrow;
    }
  }

  static uploadProfileImage(File? image, String id) async {
    final imageByte = base64Encode(image!.readAsBytesSync());
    String data =
        jsonEncode({'id': id, 'userImage': imageByte, 'userTranscript': ''});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url = Uri.parse(
        'http://tutorfilesystem-dev.us-east-1.elasticbeanstalk.com/api/UserFiles');
    try {
      final response = await http.post(url, headers: header, body: data);
      if (response.statusCode == 200) {
        return image;
      } else {
        throw "failed to upload ${response.body}";
      }
    } catch (e) {
      rethrow;
    }
  }

  static uploadTranscript(File? transcript, String id) async {
    final transcriptByte = base64Encode(transcript!.readAsBytesSync());
    String data = jsonEncode(
        {'id': id, 'userImage': '', 'userTranscript': transcriptByte});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url = Uri.parse(
        'http://tutorfilesystem-dev.us-east-1.elasticbeanstalk.com/api/UserFiles/$id');
    try {
      final response = await http.post(url, headers: header, body: data);
      if (response.statusCode == 200) {
        return transcript;
      } else {
        throw "failed to upload";
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future getProfileImage(String id) async {
    Uri tuteeURL = Uri.parse(
        'http://tutorfilesystem-dev.us-east-1.elasticbeanstalk.com/api/UserFiles/image/$id');
    try {
      final response = await http.get(tuteeURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });

      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }

        final List list = json.decode(j);
        String byteString = list[0]['tuteeImage'];

        if (byteString.isEmpty) {
          throw Exception('No Image found');
        }
        //covert to file from base64 bytes
        // String image = base64Decode(byteString);

        Uint8List image = const Base64Codec().decode(byteString);
        return image;
        // return Image.file(base64Decode(kk));
        // return list.map((json) => Tutees.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static logInTutee(String email, String password) async {
    String data = jsonEncode({
      'email': email,
      'password': password,
      'typeId': '54cca757-54ec-4671-a714-64208c5197fb'
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final modulesURL =
          Uri.parse('http://tutorme-dev.us-east-1.elasticbeanstalk.com/Login');
      final response = await http.post(modulesURL, headers: header, body: data);
      if (response.statusCode == 200) {
        final Users tutee = Users.fromObject(jsonDecode(response.body));
        return tutee;
      } else {
        throw Exception('Failed to log in' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static getTutorByEmail(String email) async {
    List<Users> tutors = await getTutors();
    late Users tutor;
    bool got = false;
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getEmail == email) {
        got = true;
        tutor = tutors[i];
        break;
      }
    }
    if (got == false) {
      throw Exception("Email is incorrect");
    } else {
      return tutor;
    }
  }

  static getTuteeByEmail(String email) async {
    List<Users> tutees = await getTutees();
    late Users tutee;
    bool got = false;
    for (int i = 0; i < tutees.length; i++) {
      if (tutees[i].getEmail == email) {
        got = true;
        tutee = tutees[i];
        break;
      }
    }
    if (got == false) {
      Fluttertoast.showToast(
          msg: "Email is incorrect",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception("Email is incorrect");
    } else {
      return tutee;
    }
  }

  static isThereTutorByEmail(String email) async {
    List<Users> tutors = await getTutors();
    bool got = false;
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getEmail == email) {
        got = true;
        break;
      }
    }
    if (got == false) {
      return false;
    } else {
      return true;
    }
  }

  static isThereTuteeByEmail(String email) async {
    List<Users> tutees = await getTutees();
    bool got = false;
    for (int i = 0; i < tutees.length; i++) {
      if (tutees[i].getEmail == email) {
        got = true;
        break;
      }
    }
    if (got == false) {
      return false;
    } else {
      return true;
    }
  }

  static hashPassword(String password) {
    String hashedPassword =
        Crypt.sha256(password, salt: 'Thisisagreatplatformforstudentstolearn')
            .toString();
    return hashedPassword;
  }

  //TODO: Tutorfiles Backend

  // static createFileRecord(String id) async {
  //   String data =
  //       jsonEncode({'id': id, 'tutorImage': '', 'tutorTranscript': ''});
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=utf-8'
  //   };
  //   final url = Uri.parse(
  //       'http://filesystem-prod.us-east-1.elasticbeanstalk.com/api/TutorFiles');
  //   try {
  //     final response = await http.post(url, headers: header, body: data);
  //     if (response.statusCode == 201) {
  //       return true;
  //     } else {
  //       throw "failed to upload";
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static uploadProfileImage(File? image, String id) async {
  //   final imageByte = base64Encode(image!.readAsBytesSync());
  //   String data = jsonEncode({'id': id, 'tutorImage': imageByte});
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=utf-8'
  //   };
  //   final url = Uri.parse(
  //       'http://filesystem-prod.us-east-1.elasticbeanstalk.com/api/TutorFiles/$id');
  //   try {
  //     final response = await http.put(url, headers: header, body: data);
  //     if (response.statusCode == 204) {
  //       return image;
  //     } else {
  //       throw "failed to upload";
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future getTutorProfileImage(String id) async {
    Uri tuteeURL = Uri.parse(
        'http://tutorfilesystem-dev.us-east-1.elasticbeanstalk.com/api/Userfiles/image/$id');

    try {
      final response = await http.get(tuteeURL, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        final image = response.body;
        List<String> imageList = image.split('"');

        if (image.isEmpty) {
          throw Exception('No Image found');
        } else {
          Uint8List bytes = base64Decode(imageList[1]);
          return bytes;
        }
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
