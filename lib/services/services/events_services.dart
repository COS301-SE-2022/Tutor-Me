import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/event.dart';
import '../models/globals.dart';
import '../models/users.dart';

class EventServices {
  static getEventsByUserId(String userId, Globals global) async {
    Uri url = Uri.http(global.getTutorMeUrl, "api/Events/$userId");

    try {
      final response = await http.get(url, headers: global.getHeader);

      log("============================");
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

        return list.map((json) => Event.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getEventsByUserId(userId, global);
      } else {
        throw Exception('Failed to load' + response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static deleteEventEventId(String eventId, Globals global) async {
    try {
      log(eventId);
      log(global.getToken);
      final url = Uri.http(global.getTutorMeUrl, 'api/Events/$eventId');

      final response = await http.delete(url, headers: global.getHeader);
      log(response.body);
      log('fffff' + response.statusCode.toString());
      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await deleteEventEventId(eventId, global);
      } else {
        throw Exception(
            'Failed to deleted. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static createEvent(Event event, Globals global) async {
    try {
      final url = Uri.http(global.getTutorMeUrl, 'api/Events');

      final data = jsonEncode({
        'eventId': global.getUser.getId,
        'groupId': null,
        'ownerId': global.getUser.getId,
        'userId': global.getUser.getId,
        'dateOfEvent': event.getDateOfEvent,
        'videoLink': event.getVideoLink,
        'timeOfEvent': event.getTimeOfEvent,
        'title': event.getTitle,
        'description': event.getDescription,
      });
      // print("*======================*");
      // print(data);
      // print("*======================*");

      final response =
          await http.post(url, body: data, headers: global.getHeader);
      // print(response.body);
      // print(response.statusCode);
      // print("*========&&==============*");
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await createEvent(event, global);
      } else {
        throw Exception(
            'Failed to create event. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static bookTutorEvent(Users tutor, Event event, Globals global) async {
    try {
      final url = Uri.http(global.getTutorMeUrl, 'api/Events');

      final data = jsonEncode({
        'eventId': global.getUser.getId,
        'groupId': null,
        'ownerId': global.getUser.getId,
        'userId': tutor.getId,
        'dateOfEvent': event.getDateOfEvent,
        'videoLink': event.getVideoLink,
        'timeOfEvent': event.getTimeOfEvent,
        'title': event.getTitle,
        'description': event.getDescription,
      });
      // print("*======================*");
      // print(data);
      // print("*======================*");

      final response =
          await http.post(url, body: data, headers: global.getHeader);
      // print(response.body);
      // print(response.statusCode);
      // print("*========&&==============*");
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await createEvent(event, global);
      } else {
        throw Exception(
            'Failed to create event. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateEventTime(String eventId, String time, Globals global) async {
    try {
      final url =
          Uri.http(global.getTutorMeUrl, 'api/Events/$eventId?newTime=$time');

      final response = await http.put(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateEventTime(eventId, time, global);
      } else {
        throw Exception(
            'Failed to update event time. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateEventDate(String eventId, String date, Globals global) async {
    try {
      final url =
          Uri.http(global.getTutorMeUrl, 'api/Events/$eventId?newDate=$date');

      final response = await http.put(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateEventDate(eventId, date, global);
      } else {
        throw Exception(
            'Failed to update event date. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateEventTitle(String eventId, String title, Globals global) async {
    try {
      final url =
          Uri.http(global.getTutorMeUrl, 'api/Events/$eventId?newTitle=$title');

      final response = await http.put(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateEventTitle(eventId, title, global);
      } else {
        throw Exception(
            'Failed to update event title. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateEventDescription(
      String eventId, String description, Globals global) async {
    try {
      final url = Uri.http(global.getTutorMeUrl,
          'api/Events/$eventId?newDescription=$description');

      final response = await http.put(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateEventDescription(eventId, description, global);
      } else {
        throw Exception(
            'Failed to update event description. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateGroupId(String eventId, String groupId, Globals global) async {
    try {
      final url = Uri.http(
          global.getTutorMeUrl, 'api/Events/$eventId?newGroupId=$groupId');

      final response = await http.put(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateGroupId(eventId, groupId, global);
      } else {
        throw Exception(
            'Failed to update event group. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

 static updateVideoId(String eventId, String videoLink, Globals global) async {
    try {
      final url = Uri.http(
          global.getTutorMeUrl, 'api/Events/$eventId?newVideoLink=$videoLink');

      final response = await http.put(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await updateGroupId(eventId, videoLink, global);
      } else {
        throw Exception(
            'Failed to update event group. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
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
      log('token refreshed');
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
