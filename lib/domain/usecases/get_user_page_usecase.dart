import 'package:dartz/dartz.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetUserPageUseCase
    implements BaseUseCase<Map<String?, List<String>>, GetUserPageParams> {
  final UserRepository _userRepository;

  GetUserPageUseCase(this._userRepository);

  @override
  Future<Either<Failure, Map<String?, List<String>>>> execute(
      GetUserPageParams params) async {
    return await _userRepository.getUserImagePage(
      params.id,
      limit: params.limit,
      pageToken: params.pageToken,
    );
  }
}

class GetUserPageParams extends Equatable {
  final String id;
  final int limit;
  final String? pageToken;

  const GetUserPageParams(
    this.id,
    this.limit,
    this.pageToken,
  );

  @override
  List<Object> get props => pageToken == null
      ? [
          id,
          limit,
        ]
      : [
          id,
          limit,
          pageToken!,
        ];
}
