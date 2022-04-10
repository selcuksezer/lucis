import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class NewPinUseCase implements BaseUseCase<bool, NewPinParams> {
  final FeedRepository _feedRepository;
  final UserRepository _userRepository;
  final Session _session;

  NewPinUseCase(
    this._feedRepository,
    this._userRepository,
    this._session,
  );

  @override
  Future<Either<Failure, bool>> execute(NewPinParams params) async {
    final userUpdateResult = await _userRepository.updateUserPins(
      params.userId,
      params.feedLocation,
    );
    if (userUpdateResult.isRight()) {
      final failOrSuccess = await _feedRepository.updateFeedPins(
        params.feedId,
        incrementBy: params.incrementBy,
      );
      if (failOrSuccess.isRight()) {
        if (params.incrementBy > 0) {
          _session.user!.pins.add(params.feedLocation);
        } else {
          _session.user!.pins.remove(params.feedLocation);
        }
      }
      return failOrSuccess;
    } else {
      return userUpdateResult;
    }
  }
}

class NewPinParams extends Equatable {
  final String userId;
  final String feedId;
  final Location feedLocation;
  final int incrementBy;

  const NewPinParams(
    this.userId,
    this.feedId,
    this.feedLocation,
    this.incrementBy,
  );

  @override
  List<Object> get props => [
        userId,
        feedId,
        feedLocation,
        incrementBy,
      ];
}
