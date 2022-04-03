import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/domain/entities/session.dart';

abstract class SessionRepository {
  Future<Either<Failure, Session>> initSession(String userId);

  Either<Failure, Session> getSession();
}
