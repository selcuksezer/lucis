import 'package:geoflutterfire/geoflutterfire.dart';

class Location {
  final GeoFirePoint? geoFirePoint;

  Location(this.geoFirePoint);
}

enum LocationStatus {
  enabled,
  noPermission,
  noPermissionForever,
  noService,
}
