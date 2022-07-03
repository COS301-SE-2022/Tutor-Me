import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:tutor_me/services/models/modules.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:crypt/crypt.dart';

class TutorServices {
  static getTutors() async {
    Uri tutorURL = Uri.https('tutormeapi1.azurewebsites.net', '/api/Tutors');
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
    Uri tutorURL = Uri.https('tutormeapi1.azurewebsites.net', '/api/Tutors/$id');
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

  static Future registerTutor(
      String name,
      String lastName,
      String date,
      String gender,
      String institution,
      String email,
      String password,
      String confirmPassword) async {
    List<Tutors> tutors = await getTutors();
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getEmail == email) {
        throw "Email already exists";
      }
    }
    final modulesURL =
        Uri.https('tutormeapi1.azurewebsites.net', '/api/Tutors/');
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
      'tuteesCode': "No tutees",
      'email': email,
      'password': password,
      'bio': "No bio added",
      'connections': "No connections added",
      'rating': 0.toString()
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
        return tutors[0];
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
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
      'rating': tutor.getRating
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = tutor.getId;
      final modulesURL =
          Uri.parse('https://tutormeapi1.azurewebsites.net/api/Tutors/$id');
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
      if (tutors[i].getEmail == email && tutors[i].getPassword == password) {
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

  static uploadProfileImage(File? image, String id) async {
    final imageByte = base64Encode(image!.readAsBytesSync());
    String data = jsonEncode({'id': id, 'tutorImage': imageByte});
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    };
    final url = Uri.parse(
        'https://tutormetutorfiles.azurewebsites.net/api/TutorFiles/$id');
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
    Uri tuteeURL =
        Uri.https('tutormetutorfiles.azurewebsites.net', 'api/TutorFiles/$id');
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
        Uint8List image = const Base64Codec().decode(byteString);
        return image;
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static hashPassword(String password) {
    String hashedPassword = Crypt.sha256(password).toString();
    return hashedPassword;
  }
}
