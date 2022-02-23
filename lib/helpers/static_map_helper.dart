import 'package:lucis/auth/maps_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaticMapHelper {
  static String getStaticMapURL({
    required double latitude,
    required double longitude,
    String type = 'terrain',
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?&zoom=13&size=600x300&maptype=$type&markers=color:red%7C$latitude,$longitude&key=$kApiKey';
  }

  static Future<String> getLocationAddress({
    required double latitude,
    required double longitude,
  }) async {
    final reverseGeocodeURL = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$kApiKey');
    final response = await http.get(reverseGeocodeURL);
    final address =
        json.decode(response.body)['results'][0]['formatted_address'];
    return address;
  }
}
