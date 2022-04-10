import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/session_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetSessionUseCase implements BaseUseCase<Session, GetSessionParams> {
  final SessionRepository _sessionRepository;

  GetSessionUseCase(this._sessionRepository);

  @override
  Future<Either<Failure, Session>> execute(GetSessionParams params) async {
    return _sessionRepository.getSession();
  }
}

class GetSessionParams extends Equatable {
  const GetSessionParams();

  @override
  List<Object> get props => [];
}
