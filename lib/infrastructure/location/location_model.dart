import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel(
    double? latitude,
    double? longitude,
  ) : super(latitude == null || longitude == null
            ? null
            : GeoFirePoint(
                latitude,
                longitude,
              ));
}
