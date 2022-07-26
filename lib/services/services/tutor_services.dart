import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_me/services/models/modules.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:crypt/crypt.dart';
import 'package:tutor_me/services/services/tutee_services.dart';
import '../models/requests.dart';
import '../models/tutees.dart';

class TutorServices {
  getRequests(String id) async {
    final url = Uri.http(
        'tutorme-prod.us-east-1.elasticbeanstalk.com', 'api/Requests/');
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
        final requests = list.map((json) => Requests.fromObject(json)).toList();

        List<Requests> finalRequests = requests.where((request) {
          return request.getReceiverId.contains(id);
        }).toList();

        return finalRequests;
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getRequest(String id) async {
    Uri url = Uri.http(
        'tutorme-prod.us-east-1.elasticbeanstalk.com', '/api/Requests/$id');
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
      final url = Uri.http('tutorme-prod.us-east-1.elasticbeanstalk.com',
          'api/Requests/Tutor/$id');
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

  static updateTutorByEmail(String oldEmail, String newEmail) async {
    Tutors tutor = await getTutorByEmail(oldEmail);
    if (isThereTutorByEmail(newEmail) == false) {
      tutor.setEmail = newEmail;
      await TutorServices.updateTutor(tutor);
    }

    String data = jsonEncode({
      'id': tutor.getId,
      'firstName': tutor.getName,
      'lastName': tutor.getLastName,
      'dateOfBirth': tutor.getDateOfBirth,
      'gender': tutor.getGender,
      'status': tutor.getStatus,
      'faculty': tutor.getFaculty,
      'course': tutor.getCourse,
      'institution': tutor.getInstitution,
      'modules': tutor.getModules,
      'location': tutor.getLocation,
      'tuteesCode': tutor.getTuteesCode,
      'email': newEmail,
      'password': tutor.getPassword,
      'bio': tutor.getBio,
      'connections': tutor.getConnections,
      'rating': tutor.getRating,
      'year': tutor.getYear,
      'groupIds': tutor.getGroupIds
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutor.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-prod.us-east-1.elasticbeanstalk.com/api/Tutors/$id');
      final response = await http.put(modulesURL, headers: header, body: data);
      if (response.statusCode == 204) {
        Fluttertoast.showToast(
            msg: "Tutor Email Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return tutor;
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update Tutor Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static deleteTutor(String id) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final tutorsURL = Uri.parse(
          'http://tutorme-prod.us-east-1.elasticbeanstalk.com/api/Tutors/$id');
      final response = await http.delete(tutorsURL, headers: header);
      if (response.statusCode == 204) {
        Fluttertoast.showToast(
            msg: "Tutor Deleted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to delete Tutor",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception(
            'Failed to delete Tutor' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  acceptRequest(String requestId) async {
    try {
      final request = await getRequest(requestId);
      final tutor1 = await getTutor(request[0].getReceiverId);
      Tutors tutor = tutor1[0];
      final tutee1 = await TuteeServices.getTutee(request[0].getRequesterId);

      Tutees tutee = tutee1[0];
      if (!tutee.getConnections.contains(request[0].getReceiverId)) {
        if (tutee.getConnections.contains('No connections added')) {
          tutee.setConnections = request[0].getReceiverId;
        } else {
          tutee.setConnections =
              tutee.getConnections + ',' + request[0].getReceiverId;
        }
      }
      if (!tutor.getConnections.contains(request[0].getRequesterId)) {
        if (tutor.getConnections.contains('No connections added')) {
          tutor.setConnections = request[0].getRequesterId;
        } else {
          tutor.setConnections =
              tutor.getConnections + ',' + request[0].getRequesterId;
        }
      }

      await updateTutor(tutor);
      await TuteeServices.updateTutee(tutee);

      //Delete the request
      final url = Uri.http('tutorme-prod.us-east-1.elasticbeanstalk.com',
          'api/Requests/$requestId');
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
            'Failed to accept. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getTutors() async {
    Uri tutorURL =
        Uri.http('tutorme-prod.us-east-1.elasticbeanstalk.com', '/api/Tutors');
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
        return list.map((json) => Tutors.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getTutor(String id) async {
    Uri tutorURL = Uri.http(
        'tutorme-prod.us-east-1.elasticbeanstalk.com', '/api/Tutors/$id');
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
        return list.map((json) => Tutors.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static hashPassword(String password) {
    String hashedPassword =
        Crypt.sha256(password, salt: 'Thisisagreatplatformforstudentstolearn')
            .toString();
    return hashedPassword;
  }

  static Future registerTutor(
      String name,
      String lastName,
      String date,
      String gender,
      String institution,
      String email,
      String password,
      String confirmPassword,
      String year,
      String course) async {
    List<Tutors> tutors = await getTutors();
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getEmail == email) {
        throw "Email already exists";
      }
    }
    final modulesURL =
        Uri.http('tutorme-prod.us-east-1.elasticbeanstalk.com', '/api/Tutors/');
    //source: https://protocoderspoint.com/flutter-encryption-decryption-using-flutter-string-encryption/#:~:text=open%20your%20flutter%20project%20that,IDE(android%2Dstudio).&text=Then%20after%20you%20have%20added,the%20password%20the%20user%20enter.

    password = hashPassword(password);

    String data = jsonEncode({
      'firstName': name,
      'lastName': lastName,
      'dateOfBirth': date,
      'gender': gender,
      'status': "T",
      'faculty': "No faculty added",
      'course': course,
      'institution': institution,
      'modules': "No modules added",
      'location': "No Location added",
      'tuteesCode': "No tutees",
      'email': email,
      'password': password,
      'bio': "No bio added",
      'connections': "No connections added",
      'rating': "0,0",
      'year': year,
      'groupIds': "no groups",
      'requests': 'no requests'
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
        List<Tutors> tutors =
            list.map((json) => Tutors.fromObject(json)).toList();
        await createFileRecord(tutors[0].getId);
        return tutors[0];
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static createFileRecord(String id) async {
    String data =
        jsonEncode({'id': id, 'tutorImage': '', 'tutorTranscript': ''});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url = Uri.parse(
        'http://filesystem-prod.us-east-1.elasticbeanstalk.com/api/TutorFiles');
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

  static updateTutor(Tutors tutor) async {
    List<Tutors> tutors = await getTutors();
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getEmail == tutor.getEmail &&
          tutors[i].getId != tutor.getId) {
        throw Exception("Email already exists");
      }
    }
    String data = jsonEncode({
      'id': tutor.getId,
      'firstName': tutor.getName,
      'lastName': tutor.getLastName,
      'dateOfBirth': tutor.getDateOfBirth,
      'gender': tutor.getGender,
      'status': tutor.getStatus,
      'faculty': tutor.getFaculty,
      'course': tutor.getCourse,
      'institution': tutor.getInstitution,
      'modules': tutor.getModules,
      'location': tutor.getLocation,
      'tuteesCode': tutor.getTuteesCode,
      'email': tutor.getEmail,
      'password': tutor.getPassword,
      'bio': tutor.getBio,
      'connections': tutor.getConnections,
      'rating': tutor.getRating,
      'year': tutor.getYear,
      'groupIds': tutor.getGroupIds
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutor.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-prod.us-east-1.elasticbeanstalk.com/api/Tutors/$id');
      final response = await http.put(modulesURL, headers: header, body: data);
      if (response.statusCode == 204) {
        return tutor;
      } else {
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

  static logInTutor(String email, String password) async {
    List<Tutors> tutors = await getTutors();

    late Tutors tutor;
    bool got = false;
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getEmail == email &&
          tutors[i].getPassword == hashPassword(password)) {
        got = true;
        tutor = tutors[i];
        break;
      }
    }
    if (got == false) {
      throw Exception("Email or password is incorrect");
    } else {
      return tutor;
    }
  }

  static getTutorByEmail(String email) async {
    List<Tutors> tutors = await getTutors();
    late Tutors tutor;
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

  static isThereTutorByEmail(String email) async {
    List<Tutors> tutors = await getTutors();
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

  static uploadProfileImage(File? image, String id) async {
    final imageByte = base64Encode(image!.readAsBytesSync());
    String data = jsonEncode({'id': id, 'tutorImage': imageByte});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url = Uri.parse(
        'http://filesystem-prod.us-east-1.elasticbeanstalk.com/api/TutorFiles/$id');
    try {
      final response = await http.put(url, headers: header, body: data);
      if (response.statusCode == 204) {
        return image;
      } else {
        throw "failed to upload";
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future getTutorProfileImage(String id) async {
    Uri tuteeURL = Uri.parse(
        'http://filesystem-prod.us-east-1.elasticbeanstalk.com/api/TutorFiles/$id');

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
        String byteString = list[0]['tutorImage'];
        if (byteString.isEmpty) {
          throw Exception('No Image found');
        }

        Uint8List image = const Base64Codec().decode(byteString);
        return image;
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
