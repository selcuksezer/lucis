import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucis/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel(
    double latitude,
    double longitude,
  ) : super(GeoFirePoint(
          latitude,
          longitude,
        ));

  factory LocationModel.fromGeoFirePoint(GeoFirePoint geoFirePoint) {
    return LocationModel(
      geoFirePoint.latitude,
      geoFirePoint.longitude,
    );
  }

  LatLng? toLatLng() {
    return LatLng(
      geoFirePoint.latitude,
      geoFirePoint.longitude,
    );
  }
}
