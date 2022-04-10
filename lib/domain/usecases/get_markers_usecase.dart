import 'package:dartz/dartz.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/domain/entities/marker.dart';
import 'package:lucis/domain/repositories/marker_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetMarkerUseCase
    implements BaseUseCase<Stream<List<ImageMarker>>, GetMarkerParams> {
  final MarkerRepository _markerRepository;

  GetMarkerUseCase(this._markerRepository);

  @override
  Future<Either<Failure, Stream<List<ImageMarker>>>> execute(
      GetMarkerParams params) async {
    return await _markerRepository.getMarkerStream(
      center: params.center,
      radius: params.radius,
      onTap: params.onTap,
    );
  }
}

class GetMarkerParams extends Equatable {
  final GeoFirePoint center;
  final double radius;
  final void Function(String markerId) onTap;

  const GetMarkerParams(
    this.center,
    this.radius,
    this.onTap,
  );

  @override
  List<Object> get props => [
        center,
        radius,
        onTap,
      ];
}
