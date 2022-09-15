import 'package:http/http.dart' as http;
import 'package:tutor_me/services/models/globals.dart';
import 'dart:async';
import 'dart:convert';

import '../models/intitutions.dart';

class InstitutionServices {
  static getInstitutions() async {
    print('print man');
    Globals tempGlobals = Globals(null, '', '');
    print(tempGlobals.getTutorMeUrl);
    Uri institutionsURL =
        Uri.http(tempGlobals.getTutorMeUrl, '/api/Institutions');

    final header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*"
    };

    try {
      print('before');
      final response = await http.get(institutionsURL, headers: header);
      print('code ' + response.statusCode.toString());
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
          getUserInstitution(id, global);
        }
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
