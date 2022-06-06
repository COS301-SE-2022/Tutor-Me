import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tutor_me/services/models/modules.dart';

class ModuleServices {
  static getModules() async {
    Uri modulesURL = Uri.https('tutormeapi.azurewebsites.net', '/api/Modules');
    try {
      final response = await http.get(modulesURL, headers: {
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
        return list.map((json) => Modules.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getModule(String id) async {
    Uri tutorURL =
        Uri.https('tutormeapi.azurewebsites.net', '/api/Modules/$id');
    try {
      final response = await http.get(tutorURL, headers: {
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
        return list.map((json) => Modules.fromObject(json)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      return null;
    }
  }

  static getModulesByInstitution(String institution) async {
    List<Modules> modules = await getModules();
    List<Modules> modulesByInstitution = [];
    for (int i = 0; i < modules.length; i++) {
      if (modules[i].getInstitution == institution) {
        modulesByInstitution.add(modules[i]);
      }
    }
    return modulesByInstitution;
  }
}
