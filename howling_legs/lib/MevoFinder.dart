
import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:location/location.dart' as LocationGetter;


Future<List<Location>> FindNearestMevo(Location userPosition, {int maxStations =10}) async {
  var stationsURL = Uri.parse('https://gbfs.urbansharing.com/rowermevo.pl/station_information.json');
  var response = await http.get(stationsURL);  

  if (response.statusCode == 200) {
    var stationsJson = convert.jsonDecode(response.body) as Map<String, dynamic>;
    //const int stationsNumber = 5;        
    List<Station> bestStations = [];

    for(var stationJson in stationsJson["data"]["stations"]){
      Station station = Station(
          Location(
            longitude: stationJson['lon'],
            latitude: stationJson['lat'],
            timestamp: DateTime.timestamp()
          ),
          int.parse(stationJson['station_id']));
      station.distance = Distance(station.location,userPosition);
      bestStations.add(station);
      //check if too many stations      
      int furthestStation=0;
      if(bestStations.length > maxStations){
        //find the furthest
        for(int i=0;i<bestStations.length;i++){
          if(bestStations[furthestStation].distance < bestStations[i].distance){
            furthestStation = i;
          }
        }
        //delete the furthest
        bestStations.removeAt(furthestStation);
      }
    }    

    return bestStations.map((e) => e.location).toList();
  } else {
    return [Location(latitude: 0, longitude: 0, timestamp: DateTime.now())];
  }    
}


double Distance(Location a, Location b){
  return sqrt(pow(a.latitude - b.latitude,2) + pow(a.longitude - b.longitude,2));
}

class Station{
  final Location location;
  final int stationID;
  late double distance=0;

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


/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  LocationGetter.Location location = new LocationGetter.Location();

  bool _serviceEnabled;
  LocationGetter.PermissionStatus _permissionGranted;
  LocationGetter.LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy:0, speed: 0, speedAccuracy: 0);
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == LocationGetter.PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != LocationGetter.PermissionStatus.granted) {
      return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy:0, speed: 0, speedAccuracy: 0);
    }
  }

  _locationData = await location.getLocation();
  return await Geolocator.getCurrentPosition();
}