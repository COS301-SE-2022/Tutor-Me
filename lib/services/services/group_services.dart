import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/groups.dart';

import '../models/globals.dart';
import '../models/users.dart';

class GroupServices {
  static createGroup(String moduleId, String tutorId, Globals global) async {
    final groupsURL =
        Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Groups');

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
      } else {
        throw Exception('Failed to create ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static getGroups(Globals globals) async {
    Uri groupsURL =
        Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Groups');
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
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getGroup(String id, Globals globals) async {
    Uri url = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Groups/$id');
    try {
      final response = await http.get(url, headers: globals.getHeader);
      if (response.statusCode == 200) {
        final group = Groups.fromObject(json.decode(response.body));
        return group;
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getGroupByUserID(String userId, Globals global) async {
    Uri url = Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com',
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
      } else {
        throw Exception('Failed to load' + response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getGroupTutees(String groupId, Globals global) async {
    Uri url = Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com',
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
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Groups/description/$id');
      final response =
          await http.put(modulesURL, headers: global.header, body: description);
      if (response.statusCode == 204) {
        return group;
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
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Groups/videoId/$id?videoId=$videoId');
      final response =
          await http.put(modulesURL, headers: global.getHeader, body: videoId);
      if (response.statusCode == 200) {
        return group;
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
          'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Groups/$id');

      final response = await http.delete(url, headers: global.getHeader);
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
}
