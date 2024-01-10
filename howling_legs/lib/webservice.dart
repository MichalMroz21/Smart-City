import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Webservice {
  static Future<String> pathBetweenPoints(Location from, Location to) async {
    var url = Uri.parse(
        'http://192.168.1.121:8989/route?point=${from.latitude}%2C${from.longitude}&point=${to.latitude}%2C${to.longitude}&profile=bike');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // var jsonResponse =
      //     convert.jsonDecode(response.body) as Map<String, dynamic>;
      return response.body;
    } else {
      return 'Request failed with status: ${response.statusCode}.';
    }
  }
}
