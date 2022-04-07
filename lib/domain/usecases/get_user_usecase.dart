import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/user.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetUserUseCase implements BaseUseCase<User, GetUserParams> {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  @override
  Future<Either<Failure, User>> execute(GetUserParams params) async {
    return await _userRepository.getUser(params.id);
  }
}

class GetUserParams extends Equatable {
  final String id;

  const GetUserParams(this.id);

  @override
  List<Object> get props => [id];
}
