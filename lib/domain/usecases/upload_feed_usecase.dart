import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class UploadFeedUseCase implements BaseUseCase<bool, Params> {
  final FeedRepository _feedRepository;

  UploadFeedUseCase(this._feedRepository);

  @override
  Future<Either<Failure, bool>> execute(Params params) async {
    final session = Session();
    if (session.user == null || session.location == null) {
      return const Left(Failure.sessionNotInitializedFailure);
    }
    final feed = Feed(
      userId: session.user!.id,
      userName: session.user!.name,
      imageId: '${session.user!.id}-${DateTime.now().millisecondsSinceEpoch}',
      location: session.location!,
      favorites: 0,
      pins: 0,
      imageFile: params.image,
    );

    return await _feedRepository.uploadFeed(feed);
  }
}

class Params extends Equatable {
  final File image;

  const Params(this.image);

  @override
  List<Object> get props => [image];
}
