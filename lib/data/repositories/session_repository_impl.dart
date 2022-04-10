import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/data/data_sources/remote_data_sources/user_remote_data_source.dart';
import 'package:lucis/infrastructure/location/location_service.dart';
import 'package:lucis/data/exceptions.dart';
import 'package:lucis/domain/repositories/session_repository.dart';
import 'package:lucis/infrastructure/network/network_info.dart';

class SessionRepositoryImpl extends SessionRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final LocationService _locationService;
  final NetworkInfo _networkInfo;

  SessionRepositoryImpl(
    this._userRemoteDataSource,
    this._locationService,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Session>> initSession(String userId) async {
    // get user data
    if (await _networkInfo.isConnected) {
      try {
        final user = await _userRemoteDataSource.getUser(userId);
        Session().updateUser(user);
      } on BadRequestException {
        return const Left(Failure.badRequestFailure);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }

    // get location
    if (!(await _locationService.hasPermission())) {
      if (!(await _locationService.requestPermission())) {
        return await _locationService.permissionDeniedForever()
            ? const Left(Failure.locationNoPermissionForeverFailure)
            : const Left(Failure.locationNoPermissionFailure);
      }
    }
    if (!(await _locationService.serviceEnabled())) {
      if (!(await _locationService.requestService())) {
        return const Left(Failure.locationNoServiceFailure);
      }
    }

    final location = await _locationService.getLocation();
    Session().updateLocation(location);

    return Right(Session());
  }

  @override
  Either<Failure, Session> getSession() {
    return Session().user == null
        ? const Left(Failure.sessionNotInitializedFailure)
        : Right(Session());
  }
}
