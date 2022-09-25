// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/models/globals.dart';
import '../models/badges.dart';

class BadgesServices {
  static getAllBages(Globals globals) async {
    try {
      Uri badgesURL = Uri.http(globals.getTutorMeUrl, '/api/Badges');

      var response = await http.get(badgesURL, headers: globals.getHeader);
      log("BadgesServices.getAllBages: " + response.body);

      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);

        return list.map((json) => Badge.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await getAllBages(globals);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // static getBadgesByUserId(String Id, Globals globals) async
  // {
  //   try {
  //     Uri badgesURL = Uri.http(globals.getTutorMeUrl, '/api/UserBadges/$Id');

  //     var response = http.get(badgesURL, headers: globals.getHeader);

  //     if (response.statusCode == 200) {
  //       String j = "";
  //       if (response.body[0] != "[") {
  //         j = "[" + response.body + "]";
  //       } else {
  //         j = response.body;
  //       }
  //       final List list = json.decode(j);

  //       return list.map((json) => Badge.fromObject(json)).toList();
  //     }else if(response.statusCode == 401){
  //       globals = await refreshToken(globals);
  //       return await getBadgesByUserId(Id, globals);
  //     }
  //     else {
  //       throw Exception('Failed to load');
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

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

  addUserBadge(String id, Globals globals) async {
    try {

      String data  = jsonEncode({"userBadgeId": id, "userId": globals.getUser.getId,'badgeId':'',"pointAchieved":0});
      Uri badgesURL = Uri.http(globals.getTutorMeUrl, '/api/UserBadges/');

      var response = await http.post(badgesURL, headers: globals.getHeader);

      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);

        return list.map((json) => Badge.fromObject(json)).toList();
      } else if (response.statusCode == 401) {
        globals = await refreshToken(globals);
        return await addUserBadge(id, globals);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
