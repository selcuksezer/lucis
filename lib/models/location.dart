import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart' as loc;

class Location {
  Location(this.geoLocation);

  Location.fromCoordinates(double lat, double lon)
      : geoLocation = Geoflutterfire().point(
          latitude: lat,
          longitude: lon,
        );

  Location.fromGeoPoint(GeoPoint point)
      : geoLocation = Geoflutterfire().point(
          latitude: point.latitude,
          longitude: point.longitude,
        );

  Location.fromLocationService() {
    getLocation();
  }

  GeoFirePoint? geoLocation;

  Future<Location> getLocation() async {
    var location = loc.Location();
    GeoFirePoint? geoLocationData;

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == loc.PermissionStatus.granted && serviceEnabled) {
      try {
        var locationData = await location.getLocation();
        geoLocationData = Geoflutterfire().point(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
        );
      } catch (e) {
        print(e);
      }
    }
    return Location(geoLocationData);
  }

  Future<void> updateLocation() async {
    var location = loc.Location();
    GeoFirePoint? geoLocationData;

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == loc.PermissionStatus.granted && serviceEnabled) {
      try {
        var locationData = await location.getLocation();
        geoLocationData = Geoflutterfire().point(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
        );
      } catch (e) {
        print(e);
      }
    }
    geoLocation = geoLocationData;
  }
}
