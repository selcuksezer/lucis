import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/repositories/location_repository.dart';
import 'package:lucis/infrastructure/location/location_service.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService _locationService;

  LocationRepositoryImpl(this._locationService);

  @override
  Future<Either<LocationStatus, Location?>> getLocation() async {
    if (!(await _locationService.hasPermission())) {
      if (!(await _locationService.requestPermission())) {
        return await _locationService.permissionDeniedForever()
            ? const Left(LocationStatus.noPermissionForever)
            : const Left(LocationStatus.noPermission);
      }
    }
    if (!(await _locationService.serviceEnabled())) {
      if (!(await _locationService.requestService())) {
        return const Left(LocationStatus.noService);
      }
    }
    return Right(await _locationService.getLocation());
  }

  @override
  Future<bool> serviceEnabled() async {
    return await _locationService.serviceEnabled();
  }

  @override
  Future<bool> requestService() async {
    return await _locationService.requestService();
  }

  @override
  Future<bool> hasPermission() async {
    return await _locationService.hasPermission();
  }

  @override
  Future<bool> requestPermission() async {
    return await _locationService.requestPermission();
  }
}
