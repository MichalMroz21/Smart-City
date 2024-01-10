import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:howling_legs/Place.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Webservice {
  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static Future<Iterable<Place>> searchPrompts(String prompt) async {
    if (prompt == '') {
      return const Iterable<Place>.empty();
    }

    String url = "http://192.168.1.121:8080/search.php?q=$prompt";

    var request = Uri.parse(url);

    var response = await http.get(request);
    List<Place> results = [];

    if (response.statusCode == 200) {
      String resp = response.body;

      // Parse the JSON string
      List<dynamic> jsonData = json.decode(resp);

      // Extract points from the JSON
      for (var data in jsonData) {
        Place p = Place(
            name: data["display_name"].toString(),
            latitude: double.parse(data["lat"].toString()),
            longitude: double.parse(data["lon"].toString()));
        results.add(p);
      }
    }
    return results;
  }

  static Future<List<List<double>>> pathBetweenPoints(
      List<Location> locations) async {
    String url = "http://192.168.1.121:8989/route?";

    for (var location in locations) {
      url += ("point=" +
          location.latitude.toString() +
          "%2C" +
          location.longitude.toString() +
          "&");
    }

    url += "profile=bike&points_encoded=false";

    var request = Uri.parse(url);

    var response = await http.get(request);

    if (response.statusCode == 200) {
      String resp = response.body;

      // Parse the JSON string
      Map<String, dynamic> jsonData = json.decode(resp);

      // Extract points from the JSON

      String pointsStr =
          jsonData['paths'][0]['points']['coordinates'].toString();

      List<List<double>> points = [];

      List<double> currPair = [];

      String num = "";

      for (int i = 0; i < pointsStr.length; i++) {
        var ch = pointsStr[i];

        if (isNumeric(ch) || ch == '.') {
          num += ch;
        } else {
          if (num != "") {
            double db = double.parse(num);

            if (currPair.length == 2) {
              currPair = [];
              currPair.add(db);
            } else if (currPair.length == 1) {
              currPair.add(db);
              points.add(currPair);
            } else {
              currPair.add(db);
            }

            num = "";
          }
        }
      }

      for (int i = 0; i < points.length; i++) {
        points[i] = points[i].reversed.toList();
      }

      return points;
    } else {
      return [[]];
    }
  }
}
