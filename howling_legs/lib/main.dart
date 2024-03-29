import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:howling_legs/Place.dart';
import 'package:howling_legs/location_selector.dart';
import 'package:howling_legs/PathCreator.dart';
import 'package:howling_legs/time_display.dart';
import 'package:howling_legs/webservice.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

import 'MevoFinder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart City',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Smart City'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController mapController = MapController();
  PathCreator pathCrator = const PathCreator();
  List<Marker> markers = [];
  List<Polyline> polylines = [];

  void clearPaths() {
    polylines.clear();
  }

  void addPath(List<List<double>> points, Color color) {
    List<LatLng> pointsLat = [];

    for (var point in points) {
      pointsLat.add(LatLng(point[0], point[1]));
    }

    polylines.add(Polyline(points: pointsLat, color: color, strokeWidth: 5));
    debugPrint(polylines.length.toString());
  }

  Future<Address> _determineAddress() async {
    final currentAddress = await GeoCode().reverseGeocoding(
        latitude: mapController.center.latitude,
        longitude: mapController.center.longitude);

    return currentAddress;
  }

  Future<Address> _determineAddressWithPos(
      double latitude, double longitude) async {
    final currentAddress = await GeoCode()
        .reverseGeocoding(latitude: latitude, longitude: longitude);

    return currentAddress;
  }

  Future<Coordinates> _determinePosition(String address) async {
    //"532 S Olive St, Los Angeles, CA 90013"
    final coordinates = await GeoCode().forwardGeocoding(address: address);
    return coordinates;
  }

  void addMarker(double latitude, double longitude, Widget icon,
      {width = 80, height = 80}) {
    markers.add(Marker(
      point: LatLng(latitude, longitude),
      width: width,
      height: height,
      child: icon,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialCenter: LatLng(54.34663, 18.64392),
              initialZoom: 16.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
              PolylineLayer(polylines: polylines),
              MarkerLayer(markers: markers),
            ],
          ),
          // Positioned(
          //   top: 20,
          //   left: 20,
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       //mapController.move(const LatLng(0.0, 0.0), 10.0);
          //       debugPrint(await _determineAddress()
          //           .then((value) => value.streetAddress));
          //       debugPrint(await _determinePosition(
          //               "532 S Olive St, Los Angeles, CA 90013")
          //           .then((value) =>
          //               value.latitude.toString() +
          //               value.longitude.toString()));
          //       addMarker(54.34663, 18.64392,
          //           Icon(Icons.location_on, size: 30.0, color: Colors.red));
          //     },
          //     child: const Text('Go to Address'),
          //   ),
          // ),
          // Positioned(
          //   top: 60,
          //   left: 20,
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       List<List<double>> points = await Webservice.pathBetweenPoints([
          //         Location(
          //           latitude: 54.510225,
          //           longitude: 18.483229,
          //           timestamp: DateTime.now(),
          //         ),
          //         Location(
          //           latitude: 54.502609,
          //           longitude: 18.502044,
          //           timestamp: DateTime.now(),
          //         ),
          //         Location(
          //           latitude: 54.481975,
          //           longitude: 18.513702,
          //           timestamp: DateTime.now(),
          //         ),
          //       ]);

          //       debugPrint("response:");
          //       print(points);

          //       addPath(points, Colors.red);
          //     },
          //     child: const Text('Ask Kamil'),
          //   ),
          // ),
          Positioned(
            top: 20,
            left: 20,
            child: LocationSelector(
              mapController: mapController,
              pathCreator: pathCrator,
              markers: markers,
              onDraw: (List<Place> places) async {
                polylines.clear();
                if (places.length > 1) {
                  debugPrint(places.length.toString());
                  List<List<double>> coordinates = [];
                  List<Location> locations = [];
                  for (var place in places) {
                    locations.add(Location(
                        latitude: place.latitude,
                        longitude: place.longitude,
                        timestamp: DateTime.now()));
                  }
                  coordinates = await Webservice.pathBetweenPoints(locations);
                  addPath(coordinates, Colors.red);
                  for (Place place in places) {
                    addMarker(
                        place.latitude,
                        place.longitude,
                        const CircleAvatar(
                          backgroundColor: Colors.yellow,
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        width: 30,
                        height: 30);
                  }
                }
                setState(() {});
              },
            ),
          ),
          //const Positioned(bottom: 10, right: 30, child: TimeDisplay()),
          Positioned(
              top: 30,
              left: 620,
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: () async {
                  Position userPosition = await determinePosition();
                  addMarker(
                      userPosition.latitude,
                      userPosition.longitude,
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      width: 30,
                      height: 30);

                  List<Location> mevoPosition = await FindNearestMevo(Location(
                      latitude: userPosition.latitude,
                      longitude: userPosition.longitude,
                      timestamp: DateTime.now()));
                  mevoPosition.forEach((station) => addMarker(
                      station.latitude,
                      station.longitude,
                      const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.pedal_bike,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      width: 30,
                      height: 30));
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Find Mevo',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
