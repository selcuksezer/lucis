import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/repositories/location_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetLocationUseCase implements BaseUseCase<Location, GetLocationParams> {
  final LocationRepository _locationRepository;

  GetLocationUseCase(this._locationRepository);

  @override
  Future<Either<Failure, Location>> execute(GetLocationParams params) async {
    return await _locationRepository.getLocation();
  }
}

class GetLocationParams extends Equatable {
  const GetLocationParams();

  @override
  List<Object> get props => [];
}
