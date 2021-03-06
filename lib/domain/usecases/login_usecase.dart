import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/auth_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class LoginUseCase implements BaseUseCase<Session, LoginParams> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<Either<Failure, Session>> execute(LoginParams params) async {
    return await _authRepository.logIn(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}
