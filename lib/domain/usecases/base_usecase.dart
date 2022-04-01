import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}
