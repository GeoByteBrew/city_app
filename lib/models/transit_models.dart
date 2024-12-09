import 'package:latlong2/latlong.dart';

class TransitStop {
  final String id;
  final String name;
  final LatLng location;
  final List<int> nextArrivals;
  
  TransitStop({
    required this.id,
    required this.name,
    required this.location,
    required this.nextArrivals,
  });
}

class BikeStation {
  final String id;
  final String name;
  final LatLng location;
  final int availableBikes;
  final int emptySlots;
  
  BikeStation({
    required this.id,
    required this.name,
    required this.location,
    required this.availableBikes,
    required this.emptySlots,
  });
}

class ParkingLot {
  final String id;
  final String name;
  final LatLng location;
  final int availableSpaces;
  final int totalSpaces;
  
  ParkingLot({
    required this.id,
    required this.name,
    required this.location,
    required this.availableSpaces,
    required this.totalSpaces,
  });
} 