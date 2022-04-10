import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/session_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class InitSessionUseCase implements BaseUseCase<Session, InitSessionParams> {
  final SessionRepository _sessionRepository;

  InitSessionUseCase(this._sessionRepository);

  @override
  Future<Either<Failure, Session>> execute(InitSessionParams params) async {
    return await _sessionRepository.initSession(params.userId);
  }
}

class InitSessionParams extends Equatable {
  final String userId;

  const InitSessionParams({
    required this.userId,
  });

  @override
  List<Object> get props => [
        userId,
      ];
}
