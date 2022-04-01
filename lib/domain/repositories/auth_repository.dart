import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/domain/entities/session.dart';

abstract class AuthRepository {
  Future<Either<Failure, Session>> register({
    required String userId,
    required String userName,
    required String email,
    required String password,
  });

  Future<Either<Failure, Session>> logIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> logOut();
}
