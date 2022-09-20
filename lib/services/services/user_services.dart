import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/users.dart';

import '../models/globals.dart';
import '../models/requests.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class UserServices {
  //
  sendRequest(String receiverId, String requesterId, String moduleId,
      Globals global) async {
    try {
      final url = Uri.http(global.getTutorMeUrl, 'api/Requests');

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
      final response =
          await http.post(url, body: data, headers: global.getHeader);
      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await sendRequest(receiverId, requesterId, moduleId, global);
      } else {
        throw Exception(
            'Failed to send request. Please make sure your internet connect is on and try again ' +
                response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getTutorRequests(String id, Globals global) async {
    final url = Uri.http(global.getTutorMeUrl, 'api/Requests/Tutor/$id');
    try {
      final response = await http.get(url, headers: global.getHeader);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Requests.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getTutorRequests(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getTuteeRequests(String id, Globals global) async {
    final url = Uri.http(global.getTutorMeUrl, 'api/Requests/Tutee/$id');
    try {
      final response = await http.get(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Requests.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getTuteeRequests(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getRequest(String id, Globals global) async {
    Uri url = Uri.http(global.getTutorMeUrl, '/api/Requests/$id');
    try {
      final response = await http.get(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Requests.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getRequest(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  declineRequest(String id, Globals global) async {
    try {
      final url = Uri.http(global.getTutorMeUrl, 'api/Requests/$id');

      final response = await http.delete(url, headers: global.getHeader);
      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await declineRequest(id, global);
      } else {
        throw Exception(
            'Failed to decline. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //

  acceptRequest(String requestId, Globals global) async {
    try {
      final url =
          Uri.http(global.getTutorMeUrl, 'api/Requests/accept/$requestId');
      final response = await http.get(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await acceptRequest(requestId, global);
      } else {
        throw Exception(
            'Failed to accept. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static deleteUser(String id, Globals global) async {
    try {
      final usersURL =
          Uri.parse('http://${global.getTutorMeUrl}/api/Users/$id');
      final response = await http.delete(usersURL, headers: global.getHeader);
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
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await deleteUser(id, global);
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

  static Future getTutor(String id, Globals globals) async {
    Uri tuteeURL = Uri.http(globals.getTutorMeUrl, '/api/Users/$id');
    try {
      final response = await http.get(tuteeURL, headers: globals.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await getTutor(id, globals);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getTutee(String id, Globals global) async {
    Uri tuteeURL = Uri.http(global.getTutorMeUrl, '/api/Users/$id');
    try {
      final response = await http.get(tuteeURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getTutee(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getTutees(Globals global) async {
    Uri tuteeURL = Uri.http(global.getTutorMeUrl, '/api/Users/tutees');
    try {
      final response = await http.get(tuteeURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getTutees(global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getUser(String id, Globals global) async {
    Uri userURL = Uri.http(global.getTutorMeUrl, '/api/Users/$id');
    try {
      final response = await http.get(userURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getUser(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getUserType(String userTypeId, Globals global) async {
    Uri userURL = Uri.http(global.getTutorMeUrl, '/api/UserTypes/$userTypeId');
    try {
      final response = await http.get(userURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        final UserType type = UserType.fromObject(json.decode(response.body));
        return type;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getUserType(userTypeId, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getTutors(Globals global) async {
    Uri tutorURL = Uri.http(global.getTutorMeUrl, '/api/Users/tutors');
    try {
      final response = await http.get(tutorURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getTutors(global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getConnections(
      String userId, String userTypeId, Globals global) async {
    log(global.getToken);
    Uri connectionsURL = Uri.parse(
        'http://${global.getTutorMeUrl}/api/Connections/users/$userId?userType=$userTypeId');

    try {
      final response =
          await http.get(connectionsURL, headers: global.getHeader);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log(response.body);
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Users.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getConnections(userId, userTypeId, global);
      } else {
        throw Exception('Failed to load' + response.body);
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
    Globals tempGlobals = Globals(null, '', '');

    final modulesURL =
        Uri.parse('http://${tempGlobals.getTutorMeUrl}/api/Users/');

    // password = hashPassword(password);
    String data = jsonEncode({
      'userId': institution,
      'firstName': name,
      'lastName': lastName,
      'dateOfBirth': date,
      'status': false,
      'gender': gender,
      'email': email,
      'password': password,
      'userTypeID': "98CA5264-1266-4158-82B6-5DE7FDD03599",
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
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final global = await logInTutor(email, password);

        return global;
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
    Globals tempGlobals = Globals(null, '', '');

    final modulesURL =
        Uri.parse('http://${tempGlobals.getTutorMeUrl}/api/Users/');

    // password = hashPassword(password);
    String data = jsonEncode({
      'userId': institution,
      'firstName': name,
      'lastName': lastName,
      'dateOfBirth': date,
      'status': false,
      'gender': gender,
      'email': email,
      'password': password,
      'userTypeID': "759FC22F-74EC-4852-9648-88878CA70983",
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
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final global = await logInTutee(email, password);

        return global;
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTutee(Users tutee, Globals global) async {
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
    try {
      final id = tutee.getId;
      final modulesURL =
          Uri.parse('http://${global.getTutorMeUrl}/api/Users/Tutees/$id');
      final response =
          await http.put(modulesURL, headers: global.getHeader, body: data);
      if (response.statusCode == 204) {
        return tutee;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateTutee(tutee, global);
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  //TODO fix this

  // static updateTuteeByEmail(
  //     String oldEmail, String newEmail, Globals global) async {
  //   Users tutee = await getTuteeByEmail(oldEmail, global);
  //   if (isThereTuteeByEmail(newEmail, global) == false) {
  //     tutee.setEmail = newEmail;
  //     await UserServices.updateTutee(tutee, global);
  //   }

  //   String data = jsonEncode({
  //     'id': tutee.getId,
  //     'firstName': tutee.getName,
  //     'lastName': tutee.getLastName,
  //     'dateOfBirth': tutee.getDateOfBirth,
  //     'status': tutee.getStatus,
  //     'gender': tutee.getGender,
  //     'email': tutee.getEmail,
  //     'password': tutee.getPassword,
  //     'userTypeID': tutee.getUserTypeID,
  //     'institutionId': tutee.getInstitutionID,
  //     'location': tutee.getLocation,
  //     'bio': tutee.getBio,
  //     'year': tutee.getYear,
  //     'rating': tutee.getRating
  //   });
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=utf-8',
  //   };
  //   try {
  //     final id = tutee.getId;
  //     final modulesURL = Uri.parse(
  //         'http://${globals.getTutorMeUrl}/api/Users/Tutees/$id');
  //     final response =
  //         await http.put(modulesURL, headers: global.getHeader, body: data);
  //     if (response.statusCode == 204) {
  //       Fluttertoast.showToast(
  //           msg: "Tutee Email Updated",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       return tutee;
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Failed To Update Tutee Email",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.grey,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       throw Exception('Failed to update' + response.statusCode.toString());
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static updateTutor(Users tutor, Globals global) async {
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

    try {
      final id = tutor.getId;
      final modulesURL =
          Uri.parse('http://${global.getTutorMeUrl}/api/Users/$id');
      final response =
          await http.put(modulesURL, headers: global.getHeader, body: data);
      if (response.statusCode == 200) {
        return tutor;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateTutee(tutor, global);
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTutorBio(String userId, String bio, Globals globals) async {
    try {
      final modulesURL = Uri.parse(
          'http://${globals.getTutorMeUrl}/api/Users/Bio/$userId?Bio=$bio');
      final response = await http.put(modulesURL, headers: globals.getHeader);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await updateTutorBio(userId, bio, globals);
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static changePassword(String password, Globals globals) async {
    String data =
        jsonEncode({'userId': globals.getUser.getId, 'password': password});

    try {
      final id = globals.getUser.getId;
      final passwordURL = Uri.parse(
          'http://${globals.getTutorMeUrl}/api/Authentication/password/$id');
      final response =
          await http.put(passwordURL, headers: globals.getHeader, body: data);
      if (response.statusCode == 200) {
        return globals.getUser;
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await changePassword(password, globals);
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  //TODO fix this

  // static updateTutorByEmail(
  //     String oldEmail, String newEmail, Globals global) async {
  //   Users tutor = await getTuteeByEmail(oldEmail, global);
  //   if (isThereTuteeByEmail(newEmail, global) == false) {
  //     tutor.setEmail = newEmail;
  //     await UserServices.updateTutee(tutor, global);
  //   }

  //   String data = jsonEncode({
  //     'id': tutor.getId,
  //     'firstName': tutor.getName,
  //     'lastName': tutor.getLastName,
  //     'dateOfBirth': tutor.getDateOfBirth,
  //     'status': tutor.getStatus,
  //     'gender': tutor.getGender,
  //     'email': tutor.getEmail,
  //     'password': tutor.getPassword,
  //     'userTypeID': tutor.getUserTypeID,
  //     'institutionId': tutor.getInstitutionID,
  //     'location': tutor.getLocation,
  //     'bio': tutor.getBio,
  //     'year': tutor.getYear,
  //     'rating': tutor.getRating
  //   });
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=utf-8',
  //   };
  //   try {
  //     final id = tutor.getId;
  //     final modulesURL = Uri.parse(
  //         'http://${globals.getTutorMeUrl}/api/Users/Tutors/$id');
  //     final response =
  //         await http.put(modulesURL, headers: global.getHeader, body: data);
  //     if (response.statusCode == 204) {
  //       Fluttertoast.showToast(
  //           msg: "Tutee Email Updated",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       return tutor;
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Failed To Update Tutee Email",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.grey,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       throw Exception('Failed to update' + response.statusCode.toString());
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static logInTutor(String email, String password) async {
    // password = hashPassword(password);
    String data = jsonEncode({
      'email': email,
      'password': password,
      'typeId': '98CA5264-1266-4158-82B6-5DE7FDD03599'
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    Globals tempGlobals = Globals(null, '', '');
    try {
      final modulesURL = Uri.parse(
          'http://${tempGlobals.getTutorMeUrl}/api/account/authtoken');
      final response = await http.post(modulesURL, headers: header, body: data);
      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200) {
        final Users tutor = Users.fromObject(jsonDecode(response.body)['user']);
        Globals global = Globals(tutor, json.decode(response.body)['token'],
            json.decode(response.body)['refreshToken']);

        return global;
      } else {
        throw Exception('Failed to log in' + response.statusCode.toString());
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // static createFileRecord(String id) async {
  //   String data =
  //       jsonEncode({'id': id, 'tuteeImage': '', 'tuteeTranscript': ''});
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=utf-8'
  //   };
  //   final url = Uri.parse(
  //       'http://filesystem-prod.us-east-1.elasticbeanstalk.com/api/TuteeFiles');
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

  static updateProfileImage(File? image, String id, Globals global) async {
    final imageByte = base64Encode(image!.readAsBytesSync());
    String data = jsonEncode(
        {'id': id, 'userImage': imageByte, 'userTranscript': 'trans'});

    final url =
        Uri.parse('http://${global.getFilesUrl}/api/UserFiles/image/$id');

    try {
      log('before');
      log(imageByte);
      final response = await http.put(url, headers: global.header, body: data);
      log('jjjj ' + response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200) {
        return image;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateProfileImage(image, id, global);
      } else {
        throw "failed to upload ${response.statusCode}";
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static uploadProfileImage(File? image, String id, Globals global) async {
    final imageByte = base64Encode(image!.readAsBytesSync());
    String data =
        jsonEncode({'id': id, 'userImage': imageByte, 'userTranscript': ''});

    final url = Uri.parse('http://${global.getFilesUrl}/api/UserFiles');
    try {
      final response =
          await http.post(url, headers: global.getHeader, body: data);
      if (response.statusCode == 200) {
        return image;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await uploadProfileImage(image, id, global);
      } else {
        throw "failed to upload ${response.statusCode}";
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTranscript(File? transcript, String id, Globals global) async {
    final transcriptByte = base64Encode(transcript!.readAsBytesSync());
    String data = jsonEncode(
        {'id': id, 'userImage': '', 'userTranscript': transcriptByte});
    log(data);

    final url =
        Uri.parse('http://${global.getFilesUrl}/api/UserFiles/image/$id');

    try {
      final response =
          await http.put(url, headers: global.getHeader, body: data);
      if (response.statusCode == 200) {
        return transcript;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateTranscript(transcript, id, global);
      } else {
        throw "failed to upload ${response.body}";
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static uploadTranscript(File? transcript, String id, Globals global) async {
    final transcriptByte = base64Encode(transcript!.readAsBytesSync());
    String data = jsonEncode(
        {'userId': id, 'userImage': '', 'userTranscript': transcriptByte});

    final url = Uri.parse('http://${global.getFilesUrl}/api/UserFiles');
    try {
      final response =
          await http.post(url, headers: global.getHeader, body: data);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return transcript;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await uploadTranscript(transcript, id, global);
      } else {
        throw "failed to upload";
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future getProfileImage(String id, Globals globals) async {
    Uri tuteeURL =
        Uri.parse('http://${globals.getFilesUrl}/api/UserFiles/image/$id');
    try {
      final response = await http.get(tuteeURL, headers: globals.getHeader);

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
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await getProfileImage(id, globals);
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
      'typeId': '759FC22F-74EC-4852-9648-88878CA70983'
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    Globals tempGlobals = Globals(null, '', '');
    try {
      final modulesURL = Uri.parse(
          'http://${tempGlobals.getTutorMeUrl}/api/account/authtoken');
      final response = await http.post(modulesURL, headers: header, body: data);
      if (response.statusCode == 200) {
        final Users tutor = Users.fromObject(jsonDecode(response.body)['user']);
        Globals global = Globals(tutor, json.decode(response.body)['token'],
            json.decode(response.body)['refreshToken']);

        return global;
      } else {
        throw Exception('Failed to log in' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static getTutorByEmail(String email, Globals global) async {
    List<Users> tutors = await getTutors(global);
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

  static getTuteeByEmail(String email, Globals global) async {
    List<Users> tutees = await getTutees(global);
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

  //TODO: is there tutor by email

  // static isThereTutorByEmail(String email) async {
  //  late Globals global;

  //   List<Users> tutors = await getTutors();
  //   bool got = false;
  //   for (int i = 0; i < tutors.length; i++) {
  //     if (tutors[i].getEmail == email) {
  //       got = true;
  //       break;
  //     }
  //   }
  //   if (got == false) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  //TODO: is there tutee by email

  // static isThereTuteeByEmail(String email, Globals global) async {
  //   List<Users> tutees = await getTutees(global);
  //   bool got = false;
  //   for (int i = 0; i < tutees.length; i++) {
  //     if (tutees[i].getEmail == email) {
  //       got = true;
  //       break;
  //     }
  //   }
  //   if (got == false) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

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
  //     final response = await http.post(url, headers: global.getHeader, body: data);
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
  //     final response = await http.put(url, headers: global.getHeader, body: data);
  //     if (response.statusCode == 204) {
  //       return image;
  //     } else {
  //       throw "failed to upload";
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future getTutorProfileImage(String id, Globals global) async {
    Uri tuteeURL =
        Uri.parse('http://${global.getFilesUrl}/api/Userfiles/image/$id');

    try {
      final response = await http.get(tuteeURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        final image = response.body;
        List<String> imageList = image.split('"');

        if (image.isEmpty) {
          throw Exception('No Image found');
        } else {
          Uint8List bytes = base64Decode(imageList[1]);
          return bytes;
        }
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getTutorProfileImage(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getTuteeProfileImage(String id, Globals global) async {
    Uri tuteeURL =
        Uri.parse('http://${global.getFilesUrl}/api/Userfiles/image/$id');

    try {
      final response = await http.get(tuteeURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        final image = response.body;
        List<String> imageList = image.split('"');

        if (image.isEmpty) {
          throw Exception('No Image found');
        } else {
          Uint8List bytes = base64Decode(imageList[1]);
          return bytes;
        }
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getTuteeProfileImage(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // static updateEvent(Globals global) async {
  //   Uri url = Uri.parse(
  //       'http://${global.getTutorMeUrl}/api/Events/date/75D2C06C-5051-4D6C-BBA7-E29D17E4E495?newDate=2022-09-29');

  //   try {
  //     final response = await http.put(url, headers: global.getHeader);
  //     if (response.statusCode == 204) {
  //       return true;
  //     } else {
  //       throw Exception('Failed to update' + response.statusCode.toString());
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  static Future<Globals> refreshToken(Globals globals) async {
    log('refreshing token');
    final refreshUrl =
        Uri.parse('http://${globals.getTutorMeUrl}/api/account/refreshToken');

    List<String> token = globals.getToken.split(' ');
    final data = jsonEncode(
        {'expiredToken': token[1], 'refreshToken': globals.getRefreshToken});
    final refreshResponse =
        await http.post(refreshUrl, headers: globals.getHeader, body: data);

    if (refreshResponse.statusCode == 200) {
      globals.setToken = 'Bearer ' + jsonDecode(refreshResponse.body)['token'];
      globals.setRefreshToken =
          jsonDecode(refreshResponse.body)['refreshToken'];
      globals.setHeader = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': globals.getToken,
      };
      final globalJson = json.encode(globals.toJson());
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setString('globals', globalJson);
      return globals;
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
