import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/intitutions.dart';

class InstitutionServices {
  static getInstitutions() async {
    Uri institutionsURL = Uri.http(
        'tutorme-dev.us-east-1.elasticbeanstalk.com', '/api/Institutions');
    try {
      final response = await http.get(institutionsURL, headers: {
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
        return list.map((json) => Institutions.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getUserInstitution(String id) async {
    Uri url = Uri.parse(
        'http://tutorme-dev.us-east-1.elasticbeanstalk.com/api/Institutions/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Institutions institution =
            Institutions.fromObject(json.decode(response.body));

        return institution;
      } else {
        throw Exception('Failed to load' + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
