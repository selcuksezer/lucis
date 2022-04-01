import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class NewPinUseCase implements BaseUseCase<bool, Params> {
  final FeedRepository _feedRepository;
  final UserRepository _userRepository;

  NewPinUseCase(
    this._feedRepository,
    this._userRepository,
  );

  @override
  Future<Either<Failure, bool>> execute(Params params) async {
    final session = Session();
    if (session.user == null) {
      return const Left(Failure.sessionNotInitializedFailure);
    }
    final userUpdateResult = await _userRepository.updateUserPins(
      session.user!.id,
      params.feedLocation,
    );
    if (userUpdateResult.isRight()) {
      return await _feedRepository.updateFeedPins(
        params.feedId,
        incrementBy: params.incrementBy,
      );
    } else {
      return userUpdateResult;
    }
  }
}

class Params extends Equatable {
  final String feedId;
  final Location feedLocation;
  final int incrementBy;

  const Params(
    this.feedId,
    this.feedLocation,
    this.incrementBy,
  );

  @override
  List<Object> get props => [
        feedId,
        feedLocation,
        incrementBy,
      ];
}
