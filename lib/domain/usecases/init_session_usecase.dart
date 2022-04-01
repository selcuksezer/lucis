import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/location_repository.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class InitSessionUseCase implements BaseUseCase<Session, Params> {
  final LocationRepository _locationRepository;
  final UserRepository _userRepository;

  InitSessionUseCase(
    this._locationRepository,
    this._userRepository,
  );

  @override
  Future<Either<Failure, Session>> execute(Params params) async {
    final session = Session();
    final userResult = await _userRepository.getUser(params.userId);

    if (userResult.isLeft()) {
      return Left(userResult as Failure);
    } else {
      userResult.fold(
        (failure) => null,
        (user) => session.updateUser(user),
      );
    }
    final locationResult = await _locationRepository.getLocation();

    if (locationResult.isLeft()) {
      return Left(locationResult as Failure);
    } else {
      locationResult.fold(
        (failure) => null,
        (location) => session.updateLocation(location),
      );
    }
    return Right(session);
  }
}

class Params extends Equatable {
  final String userId;

  const Params({
    required this.userId,
  });

  @override
  List<Object> get props => [
        userId,
      ];
}
