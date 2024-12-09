import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CityApp());
}

class CityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CityMap(),
    );
  }
}

class CityMap extends StatefulWidget {
  @override
  _CityMapState createState() => _CityMapState();
}

class _CityMapState extends State<CityMap> {
  final mapController = MapController();
  LocationData? currentLocation;
  final location = Location();
  String userType = 'pedestrian';
  String selectedLayer = 'osm';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          print('Konum servisi aktif değil');
          return;
        }
      }

      PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Konum izni verilmedi');
          return;
        }
      }

      currentLocation = await location.getLocation();
      setState(() {});
    } catch (e) {
      print('Konum alınırken hata oluştu: $e');
    }
  }

  Future<void> fetchData(String userType) async {
    final response = await http.get(Uri.parse('https://portail-api.montpellier3m.fr/'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // Verileri işleyin ve haritaya ekleyin
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(43.6119, 3.8772),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: selectedLayer == 'osm'
              ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
              : 'https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.city_app',
          maxZoom: 19,
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(currentLocation!.latitude!,
                  currentLocation!.longitude!),
              width: 80.0,
              height: 80.0,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
