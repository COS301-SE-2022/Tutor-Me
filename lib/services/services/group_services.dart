import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/groups.dart';

import '../models/users.dart';

class GroupServices {
  static createGroup(
    String moduleId,
    String tutorId,
  ) async {
    final groupsURL =
        Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Groups');

    String data = jsonEncode({
      'moduleId': moduleId,
      'description': 'No description added',
      'userId': tutorId,
    });

    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final response = await http.post(groupsURL, headers: header, body: data);
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create ' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static getGroups() async {
    Uri groupsURL =
        Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Groups');
    try {
      final response = await http.get(groupsURL, headers: {
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
        return list.map((json) => Groups.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getGroup(String id) async {
    Uri url = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Groups/$id');
    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
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

  static Future getGroupByUserID(String userId) async {
    Uri url = Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com',
        'api/GroupMembers/group/$userId');

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
        return list.map((json) => Groups.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getGroupTutees(String groupId) async {
    Uri url = Uri.http('tutorme-dev.us-east-1.elasticbeanstalk.com',
        'api/GroupMembers/tutee/$groupId');

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
        return list.map((json) => Users.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateGroupDescription(String description, Groups group) async {
    // String data = jsonEncode({
    //   'id': group.getId,
    //   'description': group.getDescription,
    // });

    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = group.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Groups/description/$id');
      final response =
          await http.put(modulesURL, headers: header, body: description);
      print(response.statusCode);
      if (response.statusCode == 204) {
        return group;
      } else {
        throw Exception('Failed to update' + response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateGroupVideoId(String videoId, Groups group) async {
    // String data = jsonEncode({
    //   'id': group.getId,
    //   'description': group.getDescription,
    // });

    final header = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    try {
      final id = group.getId;
      final modulesURL = Uri.parse(
          'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Groups/videoId/$id?videoId=$videoId');
      final response =
          await http.put(modulesURL, headers: header, body: videoId);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return group;
      } else {
        throw Exception('Failed to update' + response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  static deleteGroup(String id) async {
    try {
      final url = Uri.http(
          'tutorme-dev.us-east-1.elasticbeanstalk.com', 'api/Groups/$id');
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
}
