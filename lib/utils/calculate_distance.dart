import 'dart:math';

double calculateDistance(lat1, lon1, lat2, lon2) {
  const double degToRadRatio = 0.017453292519943295;
  const int earthDiameterInKm = 12742;
  var a = 0.5 -
      cos((lat2 - lat1) * degToRadRatio) / 2 +
      cos(lat1 * degToRadRatio) *
          cos(lat2 * degToRadRatio) *
          (1 - cos((lon2 - lon1) * degToRadRatio)) /
          2;
  return earthDiameterInKm * asin(sqrt(a));
}
