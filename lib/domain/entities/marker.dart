import 'package:lucis/domain/entities/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

abstract class Marker {

  final String markerId;
  final dynamic position;
  final void Function(String markerId)? onTap;


  Marker()
}


