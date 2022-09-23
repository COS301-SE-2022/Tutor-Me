import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:tutor_me/services/models/admins.dart';
import 'package:crypt/crypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/models/users.dart';

import '../models/globals.dart';

class AdminServices {
  static getAdmins(Globals global) async {
    Uri adminsURL = Uri.http(global.getTutorMeUrl, '/api/Admins');
    try {
      final response = await http.get(adminsURL, headers: global.getHeader);

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
        return await getAdmins(global);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static addInstitution(String name, String location, Globals global) async {
    try {
      final url = Uri.http(global.getTutorMeUrl, 'api/Institutions');

      final data = jsonEncode({
        'institutionId': '00000000-0000-0000-0000-000000000000',
        'name': name,
        'location': location,
      });
      final response =
          await http.post(url, body: data, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await addInstitution(name, location, global);
      } else {
        throw Exception(
            'Failed to send request. Please make sure your internet connect is on and try again ' +
                response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static addModule(String code, String moduleName, String institutionId,
      String faculty, String year, Globals global) async {
    try {
      final url = Uri.http(global.getTutorMeUrl, 'api/Modules');

      final data = jsonEncode({
        'moduleId': '00000000-0000-0000-0000-000000000000',
        'code': code,
        'moduleName': moduleName,
        'institutionId': institutionId,
        'faculty': faculty,
        'year': year
      });
      final response =
          await http.post(url, body: data, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await addModule(
            code, moduleName, institutionId, faculty, year, global);
      } else {
        throw Exception(
            'Failed to send request. Please make sure your internet connect is on and try again ' +
                response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateAdmin(Users admin, Globals global) async {
    String data = jsonEncode({
      'id': admin.getId,
      'name': admin.getName,
      'email': admin.getEmail,
      'password': admin.getPassword,
    });
    try {
      final id = admin.getId;
      final adminsURL =
          Uri.parse('http://${global.getTutorMeUrl}/api/Admins/$id');
      final response =
          await http.put(adminsURL, headers: global.getHeader, body: data);
      if (response.statusCode == 204) {
        return admin;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateAdmin(admin, global);
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future getAdmin(String id, Globals global) async {
    Uri tutorURL = Uri.http(global.getTutorMeUrl, '/api/Admins/$id');
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
        return await getAdmin(id, global);
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
      'typeId': '475ED4B3-D159-4FDF-B6D1-D37C14AB8A60'
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
        final Users admin = Users.fromObject(jsonDecode(response.body)['user']);
        Globals global = Globals(admin, json.decode(response.body)['token'],
            json.decode(response.body)['refreshToken']);

        return global;
      } else {
        throw Exception('Failed to log in' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Globals> refreshToken(Globals globals) async {
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
