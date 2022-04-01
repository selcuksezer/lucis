import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/auth_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class RegisterUseCase implements BaseUseCase<Session, Params> {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  @override
  Future<Either<Failure, Session>> execute(Params params) async {
    return await _authRepository.register(
      userId: params.userId,
      userName: params.userName,
      email: params.email,
      password: params.password,
    );
  }
}

class Params extends Equatable {
  final String userId;
  final String userName;
  final String email;
  final String password;

  const Params({
    required this.userId,
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        userId,
        userName,
        email,
        password,
      ];
}
