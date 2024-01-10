import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:howling_legs/location_selector.dart';
import 'package:howling_legs/webservice.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<Marker> markers = [];

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

  void addMarker(double latitude, double longitude) {
    markers.add(Marker(
      point: LatLng(latitude, longitude),
      width: 80,
      height: 80,
      child: Icon(Icons.location_on, size: 30.0, color: Colors.red),
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
              MarkerLayer(markers: markers)
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () async {
                //mapController.move(const LatLng(0.0, 0.0), 10.0);
                debugPrint(await _determineAddress()
                    .then((value) => value.streetAddress));
                debugPrint(await _determinePosition(
                        "532 S Olive St, Los Angeles, CA 90013")
                    .then((value) =>
                        value.latitude.toString() +
                        value.longitude.toString()));
                addMarker(54.34663, 18.64392);
              },
              child: const Text('Go to Address'),
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: ElevatedButton(
              onPressed: () async {
                String response = await Webservice.pathBetweenPoints(
                  Location(
                    latitude: 54.474086,
                    longitude: 18.465274,
                    timestamp: DateTime.now(),
                  ),
                  Location(
                    latitude: 54.491926,
                    longitude: 18.538385,
                    timestamp: DateTime.now(),
                  ),
                );
                debugPrint("response:");
                debugPrint(response);
              },
              child: const Text('Ask Kamil'),
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: LocationSelector(),
          )
        ],
      ),
    );
  }
}
