import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';

abstract class BaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> execute(Params params);
}
