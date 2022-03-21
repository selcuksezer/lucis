import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/repositories/location_repository.dart';
import 'package:lucis/infrastructure/location/location_service.dart';

 class LocationRepositoryImpl implements LocationRepository {
  final LocationService _locationService;

  LocationRepositoryImpl(this._locationService);


  Future<Location?> getLocation() async {

   if (!(await _locationService.hasPermission())) {
    _locationService.requestPermission();
   }



  };
  Future<bool> serviceEnabled();
  Future<bool> requestService();
  Future<bool> hasPermission();
  Future<bool> requestPermission();
}

