import 'package:lucis/auth/maps_api.dart';

class StaticMapHelper {
  static String getStaticMapURL({
    required double latitude,
    required double longitude,
    String type = 'terrain',
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?&zoom=13&size=600x300&maptype=$type&markers=color:red%7C$latitude,$longitude&key=$kApiKey';
  }
}
