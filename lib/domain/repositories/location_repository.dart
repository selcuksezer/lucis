import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/location.dart';

abstract class LocationRepository {
  Future<Either<LocationStatus, Location?>> getLocation();
  Future<bool> serviceEnabled();
  Future<bool> requestService();
  Future<bool> hasPermission();
  Future<bool> requestPermission();
}
