import 'package:dartz/dartz.dart';
import 'package:lucis/domain/repositories/auth_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class LogoutUseCase implements BaseUseCase<bool, Params> {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  @override
  Future<Either<Failure, bool>> execute(Params params) async {
    return await _authRepository.logOut();
  }
}

class Params extends Equatable {
  const Params();

  @override
  List<Object> get props => [];
}
