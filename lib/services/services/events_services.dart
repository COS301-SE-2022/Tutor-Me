import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/event.dart';
import '../models/globals.dart';

class EventServices {
  static getEventsByUserId(String userId, Globals global) async {
    Uri url = Uri.http(global.getTutorMeUrl, "api/Events/$userId");

    try {
      final response = await http.get(url, headers: global.getHeader);

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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/authtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          getEventsByUserId(userId, global);
        }
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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/authtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          deleteEventEventId(eventId, global);
        }
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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/authtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          createEvent(event, global);
        }
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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/refreshtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          updateEventTime(eventId, time, global);
        }
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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/refreshtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          updateEventDate(eventId, date, global);
        }
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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/refreshtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          updateEventTitle(eventId, title, global);
        }
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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/refreshtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          updateEventDescription(eventId, description, global);
        }
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
        final refreshUrl =
            Uri.http(global.getTutorMeUrl, 'api/account/refreshtoken');

        final data = jsonEncode({
          'expiredToken': global.getToken,
          'refqreshToken': global.getRefreshToken
        });

        final refreshResponse =
            await http.post(refreshUrl, body: data, headers: global.getHeader);

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          global.setToken = refreshData['token'];
          global.setRefreshToken = refreshData['refreshToken'];
          updateGroupId(eventId, groupId, global);
        }
      } else {
        throw Exception(
            'Failed to update event group. Please make sure your internet connect is on and try again');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
