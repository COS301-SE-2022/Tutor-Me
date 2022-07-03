import 'dart:io';
import 'dart:typed_data';

import 'package:crypt/crypt.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_me/services/models/modules.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/services/services/module_services.dart';

import '../models/requests.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class TuteeServices {
  getRequests(String id) async {
    final url =
        Uri.https('tutormeapi1.azurewebsites.net', 'api/Requests/Tutee/$id');
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

  static getTutees() async {
    Uri tuteeURL = Uri.https('tutormeapi1.azurewebsites.net', '/api/Tutees');
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
        return list.map((json) => Tutees.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getTutee(String id) async {
    Uri tuteeURL =
        Uri.https('tutormeapi1.azurewebsites.net', '/api/Tutees/$id');
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
        return list.map((json) => Tutees.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static registerTuee(
      String name,
      String lastName,
      String date,
      String gender,
      String institution,
      String email,
      String password,
      String confirmPassword) async {
    List<Tutees> tutees = await getTutees();
    for (int i = 0; i < tutees.length; i++) {
      if (tutees[i].getEmail == email) {
        throw Exception("Email already exists");
      }
    }
    final modulesURL =
        Uri.https('tutormeapi1.azurewebsites.net', '/api/Tutees/');
    //source: https://protocoderspoint.com/flutter-encryption-decryption-using-flutter-string-encryption/#:~:text=open%20your%20flutter%20project%20that,IDE(android%2Dstudio).&text=Then%20after%20you%20have%20added,the%20password%20the%20user%20enter.
    // password = hashPassword(password);

    String data = jsonEncode({
      'firstName': name,
      'lastName': lastName,
      'dateOfBirth': date,
      'gender': gender,
      'status': "T",
      'faculty': "No faculty added",
      'course': "No course added",
      'institution': institution,
      'modules': "No modules added",
      'location': "No Location added",
      'tutorsCode': "No tutees",
      'email': email,
      'password': password,
      'bio': "No bio added",
      'connections': "No connections added",
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
        List<Tutees> tutees =
            list.map((json) => Tutees.fromObject(json)).toList();
        return tutees[0];
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateTutee(Tutees tutee) async {
    List<Tutees> tutees = await getTutees();
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
      'gender': tutee.getGender,
      'status': tutee.getStatus,
      'faculty': tutee.getFaculty,
      'course': tutee.getCourse,
      'institution': tutee.getInstitution,
      'modules': tutee.getModules,
      'location': tutee.getLocation,
      'tutorsCode': tutee.getTutorsCode,
      'email': tutee.getEmail,
      'password': tutee.getPassword,
      'bio': tutee.getBio,
      'connections': tutee.getConnections
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutee.getId;
      final modulesURL =
          Uri.parse('https://tutormeapi1.azurewebsites.net/api/Tutees/$id');
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

  static getTuteeModules(String id) async {
    try {
      List tutee = await getTutee(id);
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

  static uploadProfileImage(File? image, String id) async {
    final imageByte = base64Encode(image!.readAsBytesSync());
    String data = jsonEncode({'id': id, 'tutorImage': imageByte});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url =
        Uri.parse('https://tutormefiles1.azurewebsites.net/api/TuteeFiles/$id');
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

  static Future getTuteeProfileImage(String id) async {
    Uri tuteeURL =
        Uri.https('tutormefiles1.azurewebsites.net', 'api/TuteeFiles/$id');
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
    List<Tutees> tutees = await getTutees();
    late Tutees tutee;
    bool got = false;
    for (int i = 0; i < tutees.length; i++) {
      if (tutees[i].getEmail == email && tutees[i].getPassword == password) {
        got = true;
        tutee = tutees[i];
        break;
      }
    }
    if (got == false) {
      throw Exception("Email or password is incorrect");
    } else {
      return tutee;
    }
  }

  static hashPassword(String password) {
    String hashedPassword = Crypt.sha256(password).toString();
    return hashedPassword;
  }
}
