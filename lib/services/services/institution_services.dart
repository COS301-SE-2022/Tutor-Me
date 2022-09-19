import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'dart:async';
import 'dart:convert';

import '../models/intitutions.dart';

class InstitutionServices {
  static getInstitutions() async {
    Globals tempGlobals = Globals(null, '', '');
    Uri institutionsURL =
        Uri.http(tempGlobals.getTutorMeUrl, '/api/Institutions');

    final header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*"
    };

    try {
      final response = await http.get(institutionsURL, headers: header);
      if (response.statusCode == 200) {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        final List list = json.decode(j);
        return list.map((json) => Institutions.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getUserInstitution(String id, Globals global) async {
    Uri url = Uri.parse('http://${global.getTutorMeUrl}/api/Institutions/$id');
    try {
      final response = await http.get(url, headers: global.getHeader);
      if (response.statusCode == 200) {
        final Institutions institution =
            Institutions.fromObject(json.decode(response.body));

        return institution;
      } else if (response.statusCode == 401) {
        global = await refreshToken(global);
        return await getUserInstitution(id, global);
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
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
}
