import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/groups.dart';

import '../models/globals.dart';
import '../models/users.dart';

class GroupServices {
  static createGroup(String moduleId, String tutorId, Globals global) async {
    final groupsURL =
        Uri.http(global.getTutorMeUrl, '/api/Groups');

    String data = jsonEncode({
      'moduleId': moduleId,
      'description': 'No description added',
      'userId': tutorId,
    });

    try {
      final response =
          await http.post(groupsURL, headers: global.getHeader, body: data);
      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/account/authtoken');

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
          createGroup(moduleId, tutorId, global);
        }
      } else {
        throw Exception('Failed to create ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static getGroups(Globals globals) async {
    Uri groupsURL =
        Uri.http(globals.getTutorMeUrl, '/api/Groups');
    try {
      final response = await http.get(groupsURL, headers: globals.getHeader);

      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Groups.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            globals.getTutorMeUrl,
            'api/account/authtoken');

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
          getGroups(globals);
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getGroup(String id, Globals globals) async {
    Uri url = Uri.http(
        globals.getTutorMeUrl, 'api/Groups/$id');
    try {
      final response = await http.get(url, headers: globals.getHeader);
      if (response.statusCode == 200) {
        final group = Groups.fromObject(json.decode(response.body));
        return group;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            globals.getTutorMeUrl,
            'api/account/authtoken');

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
          getGroup(id, globals);
        }
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getGroupByUserID(String userId, Globals global) async {
    Uri url = Uri.http(global.getTutorMeUrl,
        'api/GroupMembers/group/$userId');
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
        return list.map((json) => Groups.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/account/authtoken');

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
          getGroupByUserID(userId, global);
        }
      } else {
        throw Exception('Failed to load' + response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getGroupTutees(String groupId, Globals global) async {
    Uri url = Uri.http(global.getTutorMeUrl,
        'api/GroupMembers/tutee/$groupId');

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
        return list.map((json) => Users.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/account/authtoken');

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
          getGroupTutees(groupId, global);
        }
      } else {
        throw Exception('Failed to load' + response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateGroupDescription(
      String description, Groups group, Globals global) async {
    // String data = jsonEncode({
    //   'id': group.getId,
    //   'description': group.getDescription,
    // });

    try {
      final id = group.getId;
      final modulesURL = Uri.parse(
          'http://${global.getTutorMeUrl}/api/Groups/description/$id');
      final response =
          await http.put(modulesURL, headers: global.header, body: description);
      if (response.statusCode == 204) {
        return group;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/account/authtoken');

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
          updateGroupDescription(description, group, global);
        }
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateGroupVideoId(
      String videoId, Groups group, Globals global) async {
    // String data = jsonEncode({
    //   'id': group.getId,
    //   'description': group.getDescription,
    // });

    try {
      final id = group.getId;
      final modulesURL = Uri.parse(
          'http://${global.getTutorMeUrl}/api/Groups/videoId/$id?videoId=$videoId');
      final response =
          await http.put(modulesURL, headers: global.getHeader, body: videoId);
      if (response.statusCode == 200) {
        return group;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/account/authtoken');

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
          updateGroupVideoId(videoId, group, global);
        }
      } else {
        throw Exception('Failed to update' + response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  static deleteGroup(String id, Globals global) async {
    try {
      final url = Uri.http(
          global.getTutorMeUrl, 'api/Groups/$id');

      final response = await http.delete(url, headers: global.getHeader);
      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        final refreshUrl = Uri.http(
            global.getTutorMeUrl,
            'api/account/authtoken');

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
          deleteGroup(id, global);
        }
      } else {
        throw Exception(
            'Failed to decline. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
