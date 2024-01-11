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

  static Future<Iterable<Place>> searchByCategory(String category) async {
    String tag = "anemity";
    String cat = "restaurant";
    switch (category) {
      case "bank":
        cat = "bank";
        break;
      case "hospital":
        cat = "hospital";
        break;
      case "pub":
        cat = "restaurant";
        break;
      case "shop":
        tag = "shop";
        cat = "*";
        break;
      case "post-office":
        cat = "post-office";
        break;
    }
    String url =
        'http://overpass-api.de/api/interpreter/?data=[out:json][timeout:25];node["$tag"="$cat"](54.23674151771537,18.310780371668695,54.59832341427045,18.815464819910883);out geom;';

    var request = Uri.parse(url);

    var response = await http.get(request);
    List<Place> results = [];

    if (response.statusCode == 200) {
      String resp = response.body;

      // Parse the JSON string
      var jsonData = json.decode(resp);

      // Extract points from the JSON
      for (var data in jsonData["elements"]) {
        var tags = data["tags"];
        if (tags["name"] != null) {
          Place p = Place(
              name: tags["name"],
              latitude: double.parse(data["lat"].toString()),
              longitude: double.parse(data["lon"].toString()));
          results.add(p);
        }
      }
    }
    return results;
  }

  static Future<Iterable<Place>> searchPrompts(
      String prompt, bool isCategory) async {
    if (prompt == '') {
      return const Iterable<Place>.empty();
    }

    String search = "q";

    if (isCategory)
      search = "amenity";
    else
      search = "q";

    String url = "http://192.168.1.121:8080/search.php?" +
        search +
        "=$prompt" +
        "&limit=500";

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
