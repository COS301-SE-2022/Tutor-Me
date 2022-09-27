// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/models/globals.dart';

import 'package:http/http.dart' as http;

import '../models/user_badges.dart';

class UserBadges {
  static getAllUserBadgesByUserId(Globals globals) async {
    try {
      var response = await http.get(
          Uri.http(globals.getTutorMeUrl,
              '/api/UserBadges/user/${globals.getUser.getId}'),
          headers: globals.getHeader);

      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);

        return list.map((json) => UserBadge.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await getAllUserBadgesByUserId(globals);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
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

  static addUserBadge(
      String userId, String badgeId, int num, Globals globals) async {
    try {
      String data = jsonEncode({
        "userBadgeId": userId,
        "userId": globals.getUser.getId,
        'badgeId': badgeId,
        "pointAchieved": num
      });
      Uri badgesURL = Uri.http(globals.getTutorMeUrl, '/api/UserBadges/');

      var response =
          await http.post(badgesURL, headers: globals.getHeader, body: data);
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await addUserBadge(userId, badgeId, num, globals);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateUserBadge(
      String userId, String badgeId, int newPoints, Globals globals) async {
    try {
      var response = await http.put(
          Uri.http(globals.getTutorMeUrl,
              '/api/UserBadges/$userId?pointAchieved=$newPoints'),
          headers: globals.getHeader);
    } catch (e) {
      throw Exception(e);
    }
  }
}
