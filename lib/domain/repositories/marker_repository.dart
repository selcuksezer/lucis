import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/marker.dart';
import 'package:lucis/domain/failure.dart';

abstract class MarkerRepository {
  Future<Either<Failure, Stream<List<ImageMarker>>>> getMarkerStream({
    required GeoFirePoint center,
    required double radius,
    required void Function(String markerId) onTap,
  });
}
