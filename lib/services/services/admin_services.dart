import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:tutor_me/services/models/admins.dart';
import 'package:crypt/crypt.dart';
import 'package:tutor_me/services/models/users.dart';

class AdminServices {
  static getAdmins() async {
    Uri adminsURL =
        Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Admins');
    try {
      final response = await http.get(adminsURL, headers: {
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
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateAdmin(Users admin) async {
    String data = jsonEncode({
      'id': admin.getId,
      'name': admin.getName,
      'email': admin.getEmail,
      'password': admin.getPassword,
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = admin.getId;
      final adminsURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Admins/$id');
      final response = await http.put(adminsURL, headers: header, body: data);
      if (response.statusCode == 204) {
        return admin;
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future getAdmin(String id) async {
    Uri tutorURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Admins/$id');
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
        throw Exception('Failed to load');
      }
    } catch (e) {
      return null;
    }
  }

  static hashPassword(String password) {
    String hashedPassword =
        Crypt.sha256(password, salt: 'Thisisagreatplatformforstudentstolearn')
            .toString();
    return hashedPassword;
  }

  static logInAdmin(String email, String password) async {
    String data = jsonEncode({
      'email': email,
      'password': password,
      'typeId': 'a29c0734-aec9-4ed0-957b-01f2caef7169'
    });
    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final modulesURL =
          Uri.parse('http://tutorme-dev.us-east-1.elasticbeanstalk.com/Login');
      final response = await http.post(modulesURL, headers: header, body: data);
      if (response.statusCode == 200) {
        final Users admin = Users.fromObject(jsonDecode(response.body));
        return admin;
      } else {
        throw Exception('Failed to log in' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }
}
