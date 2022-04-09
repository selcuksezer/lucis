import 'dart:io';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createNewUser(
    String id,
    String name,
  );

  Future<Either<Failure, User>> getUser(String id);

  Future<Either<Failure, Map<String?, List<String>>>> getUserImagePage(
    String id, {
    required int limit,
    String? pageToken,
  });

  Future<Either<Failure, bool>> updateUserFavorites(
    String id,
    String newFavorite, {
    bool add,
  });
  Future<Either<Failure, bool>> updateUserImages(
    String id,
    String newImageId,
  );
  Future<Either<Failure, bool>> updateUserPins(
    String id,
    Location newPin, {
    bool add,
  });
  Future<Either<Failure, String>> updateUserAvatar(
    String id,
    File newAvatar,
  );
}
