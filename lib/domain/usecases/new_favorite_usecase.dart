import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class NewFavoriteUseCase implements BaseUseCase<bool, NewFavoriteParams> {
  final FeedRepository _feedRepository;
  final UserRepository _userRepository;
  final Session _session;

  NewFavoriteUseCase(
    this._feedRepository,
    this._userRepository,
    this._session,
  );

  @override
  Future<Either<Failure, bool>> execute(NewFavoriteParams params) async {
    final userUpdateResult = await _userRepository.updateUserFavorites(
      params.userId,
      params.feedId,
      add: params.incrementBy > 0,
    );
    if (userUpdateResult.isRight()) {
      final failOrSuccess = await _feedRepository.updateFeedFavorites(
        params.feedId,
        incrementBy: params.incrementBy,
      );
      if (failOrSuccess.isRight()) {
        if (params.incrementBy > 0) {
          _session.user!.favorites.add(params.feedId);
        } else {
          _session.user!.favorites.remove(params.feedId);
        }
      }
      return failOrSuccess;
    } else {
      return userUpdateResult;
    }
  }
}

class NewFavoriteParams extends Equatable {
  final String userId;
  final String feedId;
  final int incrementBy;

  const NewFavoriteParams(
    this.userId,
    this.feedId,
    this.incrementBy,
  );

  @override
  List<Object> get props => [
        userId,
        feedId,
        incrementBy,
      ];
}
