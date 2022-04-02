import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/user.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetUserUseCase implements BaseUseCase<User, Params> {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  @override
  Future<Either<Failure, User>> execute(Params params) async {
    return await _userRepository.getUser(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params(this.id);

  @override
  List<Object> get props => [id];
}
