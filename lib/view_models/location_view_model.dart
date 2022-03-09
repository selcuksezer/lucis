import 'package:flutter/material.dart';
import 'package:lucis/models/location.dart';

class LocationViewModel with ChangeNotifier {
  Location location = Location.fromLocationService();

  void updateLocation() {
    location.updateLocation().then(
          (value) => notifyListeners(),
        );
  }

  Future<void> retryUpdateLocation() async {
    await location.updateLocation();
    notifyListeners();
  }
}
