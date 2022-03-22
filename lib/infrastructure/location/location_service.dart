import 'package:location/location.dart' as loc;
import 'package:lucis/infrastructure/location/location_model.dart';

abstract class LocationService {
  Future<LocationModel?> getLocation();
  Future<bool> serviceEnabled();
  Future<bool> requestService();
  Future<bool> hasPermission();
  Future<bool> permissionDeniedForever();
  Future<bool> requestPermission();
}

class LocationServiceImpl implements LocationService {
  @override
  Future<LocationModel?> getLocation() async {
    final locationData = await loc.Location().getLocation();
    return LocationModel(
      locationData.latitude,
      locationData.longitude,
    );
  }

  @override
  Future<bool> serviceEnabled() async {
    return await loc.Location().serviceEnabled();
  }

  @override
  Future<bool> requestService() async {
    return await loc.Location().requestService();
  }

  @override
  Future<bool> hasPermission() async {
    final permissionStatus = await loc.Location().hasPermission();
    return permissionStatus == loc.PermissionStatus.granted ||
            permissionStatus == loc.PermissionStatus.grantedLimited
        ? true
        : false;
  }

  @override
  Future<bool> permissionDeniedForever() async {
    final permissionStatus = await loc.Location().hasPermission();
    return permissionStatus == loc.PermissionStatus.deniedForever
        ? true
        : false;
  }

  @override
  Future<bool> requestPermission() async {
    final permissionStatus = await loc.Location().requestPermission();
    return permissionStatus == loc.PermissionStatus.granted ||
            permissionStatus == loc.PermissionStatus.grantedLimited
        ? true
        : false;
  }
}
