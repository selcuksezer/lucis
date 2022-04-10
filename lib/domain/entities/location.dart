import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final GeoFirePoint geoFirePoint;

  Location(this.geoFirePoint);

  @override
  bool operator ==(Object other) =>
      other is Location &&
      other.runtimeType == runtimeType &&
      other.geoFirePoint.latitude == geoFirePoint.latitude &&
      other.geoFirePoint.longitude == geoFirePoint.longitude;

  @override
  int get hashCode => [
        geoFirePoint.latitude,
        geoFirePoint.longitude,
      ].hashCode;

  get latLng => LatLng(
        geoFirePoint.latitude,
        geoFirePoint.longitude,
      );
}
