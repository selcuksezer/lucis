import 'dart:io';
import 'package:lucis/data/data_sources/remote_data_sources/user_remote_data_source.dart';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/infrastructure/network/network_info.dart';
import 'package:lucis/data/exceptions.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl(
    this._userRemoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> createNewUser(
    String id,
    String name,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final User user = await _userRemoteDataSource.createNewUser(
          id,
          name,
        );
        return Right(user);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final User user = await _userRemoteDataSource.getUser(id);
        return Right(user);
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
  }

  @override
  Future<Either<Failure, Map<String?, List<String>>>> getUserImagePage(
    String id, {
    required int limit,
    String? pageToken,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final imagePage = await _userRemoteDataSource.getUserImagePage(
          id,
          limit: limit,
          pageToken: pageToken,
        );
        return Right(imagePage);
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
  }

  @override
  Future<Either<Failure, bool>> updateUserFavorites(
    String id,
    String newFavorite, {
    bool add = true,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _userRemoteDataSource.updateUserFavorites(
          id,
          newFavorite,
          add: add,
        );
        return const Right(true);
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
  }

  @override
  Future<Either<Failure, bool>> updateUserImages(
    String id,
    String newImageId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _userRemoteDataSource.updateUserImages(
          id,
          newImageId,
        );
        return const Right(true);
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
  }

  @override
  Future<Either<Failure, bool>> updateUserPins(
    String id,
    Location newPin, {
    bool add = true,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _userRemoteDataSource.updateUserPins(
          id,
          newPin,
          add: add,
        );
        return const Right(true);
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
  }

  @override
  Future<Either<Failure, bool>> updateUserAvatar(
    String id,
    File newAvatar,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _userRemoteDataSource.updateUserAvatar(
          id,
          newAvatar,
        );
        return const Right(true);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }
}
