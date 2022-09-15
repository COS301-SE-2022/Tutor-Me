import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/modules.dart';
import 'package:tutor_me/services/models/user_modules.dart';

import '../models/globals.dart';

class ModuleServices {
  static getModules(Globals global) async {
    Uri modulesURL =
        Uri.http(global.getTutorMeUrl, '/api/Modules');
    try {
      final response = await http.get(modulesURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Modules.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/accoun/refreshToken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          getModules(global);
        }
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getAllUserModules(Globals global) async {
    Uri modulesURL = Uri.http(
        global.getTutorMeUrl, '/api/UserModules');
    try {
      final response = await http.get(modulesURL, headers: global.getHeader);

      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => UserModules.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/accoun/refreshToken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          getAllUserModules(global);
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getUserModules(String id, Globals global) async {
    Uri url = Uri.http(
        global.getTutorMeUrl, 'api/UserModules/$id');

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
        return list.map((json) => Modules.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/accoun/refreshToken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          getUserModules(id, global);
        }
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateModule(Modules module, Globals global) async {
    String data = jsonEncode({
      'code': module.getCode,
      'moduleName': module.getModuleName,
      'institution': module.getInstitution,
      'faculty': module.getFaculty,
      'year': module.getYear,
    });

    try {
      final code = module.getCode;
      final modulesURL = Uri.parse(
          'http://${global.getTutorMeUrl}/api/Modules/$code');
      final response =
          await http.put(modulesURL, headers: global.getHeader, body: data);
      if (response.statusCode == 204) {
        return module;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/accoun/refreshToken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          updateModule(module, global);
        }
      } else {
        throw Exception('Failed to upload ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static deleteUserModule(String id, Globals global) async {
    try {
      final modulesURL = Uri.parse(
          'http://${global.getTutorMeUrl}/api/UserModules/$id');
      final response = await http.delete(modulesURL, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/accoun/refreshToken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          deleteUserModule(id, global);
        }
      } else {
        throw Exception('Failed to delete ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static deleteModule(String id, Globals global) async {
    try {
      final modulesURL = Uri.parse(
          'http://${global.getTutorMeUrl}/api/Modules/$id');
      final response = await http.delete(modulesURL, headers: global.getHeader);
      if (response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204) {
        Fluttertoast.showToast(
            msg: "Module Deleted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/accoun/refreshToken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          deleteModule(id, global);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to delete module",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception(
            'Failed to delete module' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future getModule(String id, Globals globals) async {
    Uri tutorURL = Uri.http(
        globals.getTutorMeUrl, '/api/Modules/$id');
    try {
      final response = await http.get(tutorURL, headers: globals.getHeader);
      if (response.statusCode == 200) {
        final module = Modules.fromObject(json.decode(response.body));
        return module;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.parse(
            'http://${globals.getTutorMeUrl}/api/account/refreshToken');

        final data = jsonEncode({
          'expiredToken': globals.getToken,
          'refreshToken': globals.getRefreshToken
        });
        final refreshResponse =
            await http.post(refreshUrl,headers: globals.getHeader, body: data );

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          globals.setToken = refreshData['token'];
          globals.setRefreshToken = refreshData['refreshToken'];
          getModule(id, globals);
        }
        else
        {
          throw Exception('Failed to get module ' + response.statusCode.toString());
          
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      return null;
    }
  }

  static getModulesByInstitution(String institution, Globals globals) async {
    List<Modules> modules = await getModules(globals);
    List<Modules> modulesByInstitution = [];
    for (int i = 0; i < modules.length; i++) {
      if (modules[i].getInstitution == institution) {
        modulesByInstitution.add(modules[i]);
      }
    }
    return modulesByInstitution;
  }

  static addUserModule(String userId, Modules module, Globals globals) async {
    String data = jsonEncode({
      'userModuleId': userId,
      'moduleId': module.getModuleId,
      'userId': userId
    });

    Uri url = Uri.http(
        globals.getTutorMeUrl, '/api/UserModules');
    try {
      final response =
          await http.post(url, headers: globals.getHeader, body: data);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            globals.getTutorMeUrl,
            'api/accoun/refreshToken');

        final data = jsonEncode({
          'expiredToken': globals.getToken,
          'refreshToken': globals.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: globals.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          globals.setToken = refreshData['token'];
          globals.setRefreshToken = refreshData['refreshToken'];
          addUserModule(userId, module, globals);
        }
      } else {
        throw Exception('Failed to load' + response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
