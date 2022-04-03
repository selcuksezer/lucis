import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/failure.dart';

abstract class LocationRepository {
  Future<Either<Failure, Location>> getLocation();
  Future<bool> serviceEnabled();
  Future<bool> requestService();
  Future<bool> hasPermission();
  Future<bool> requestPermission();
}
