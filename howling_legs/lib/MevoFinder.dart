
import 'dart:ffi';
import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<Location> FindNearest(Location userPosition) async {
  var stationsURL = Uri.parse('https://gbfs.urbansharing.com/rowermevo.pl/station_information.json');
  var response = await http.get(stationsURL);
  if (response.statusCode == 200) {
    var stationsJson = convert.jsonDecode(response.body) as Map<String, dynamic>;
    //const int stationsNumber = 5;        
    //List<Station> bestStations = [];
    Station? bestStation;
    double smallestDistance = double.infinity;
    
    for(var stationJson in stationsJson["data"]["stations"]){
      Station station = Station(
          Location(
            longitude: stationJson['longitude'],
            latitude: stationJson['latitude'],
            timestamp: DateTime.now()
          ),
          stationJson['station_id']);
      double testedDistance = Distance(station.location,userPosition);
      if(bestStation == null ||
          testedDistance < smallestDistance){
          smallestDistance = testedDistance;
          bestStation = station; 
        }
    }    

    return bestStation!.location;
  } else {
    return Location(latitude: 0, longitude: 0, timestamp: DateTime.now());
  }    
}


double Distance(Location a, Location b){
  return sqrt(pow(a.latitude - b.latitude,2) - pow(a.longitude - b.longitude,2));
}

class Station{
  final Location location;
  final int stationID;

  Station(
    this.location,
    this.stationID
  )
  {}
}

class StationDetails{  
  late int stationID;
  late bool is_installed;
  late bool is_renting;
  late bool is_returning;    
  late int num_vehicles_available;
  late int num_bikes_available;
  late int num_docks_available;
  late List<VehicleStation> vehicle_types_available=[];

  StationDetails.StationDetails(
    this.stationID,
    this.is_installed,
    this.is_renting,
    this.is_returning,
    this.num_vehicles_available,
    this.num_bikes_available,
    this.num_docks_available,
    this.vehicle_types_available
  ){}

  StationDetails.FromJson(Map<String, dynamic> json){    
      stationID = json['stationID'];
      stationID = 0;
      is_installed = json['is_installed'];
      is_renting = json['is_renting'];
      is_returning = json['is_returning'];
      num_vehicles_available = json['num_vehicles_available'];
      num_bikes_available = json['num_bikes_available'] ;
      num_docks_available = json['num_docks_available']; 

      for( Map<String, dynamic> vehicleStation in json['vehicle_types_available']){
        vehicle_types_available.add(
          VehicleStation(
            vehicleStation['vehicle_type_id'],
            vehicleStation['count'])
        );
      }

  }
}

class VehicleStation{
  final String vehicle_type_id;
  final int count;
  VehicleStation(
    this.vehicle_type_id,
    this.count
  ){}
}