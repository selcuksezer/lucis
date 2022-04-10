import 'package:lucis/data/exceptions.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/domain/repositories/auth_repository.dart';
import 'package:lucis/authentication/auth_service.dart';
import 'package:lucis/infrastructure/network/network_info.dart';
import 'package:lucis/data/data_sources/remote_data_sources/user_remote_data_source.dart';
import 'exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final UserRemoteDataSource _userRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._authService,
    this._userRemoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Session>> register({
    required String userId,
    required String userName,
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _authService.register(
          userId: userId,
          userName: userName,
          email: email,
          password: password,
        );
        final session = Session();
        session.user = await _userRemoteDataSource.createNewUser(
          userId,
          userName,
        );
        return Right(session);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UserAlreadyExistsException {
        return const Left(Failure.userAlreadyExistsFailure);
      } on MailAlreadyExistsException {
        return const Left(Failure.mailAlreadyExistsFailure);
      } on MailInvalidException {
        return const Left(Failure.mailInvalidFailure);
      } on WeakPasswordException {
        return const Left(Failure.weakPasswordFailure);
      } on UnknownAuthException {
        return const Left(Failure.unknownFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }

  @override
  Future<Either<Failure, Session>> logIn({
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final userId = await _authService.logIn(
          email: email,
          password: password,
        );
        if (userId == null) {
          return const Left(Failure.userNotFoundFailure);
        }
        final session = Session();
        session.user = await _userRemoteDataSource.getUser(userId);
        return Right(session);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UserNotFoundException {
        return const Left(Failure.userNotFoundFailure);
      } on PasswordIncorrectException {
        return const Left(Failure.passwordIncorrectFailure);
      } on MailInvalidException {
        return const Left(Failure.mailInvalidFailure);
      } on UserDisabledException {
        return const Left(Failure.userDisabledFailure);
      } on UnknownAuthException {
        return const Left(Failure.unknownFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    if (await _networkInfo.isConnected) {
      try {
        await _authService.logOut();

        final session = Session();
        session.resetSession();
        return const Right(true);
      } on UnknownAuthException {
        return const Left(Failure.unknownFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }
}
