import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class UploadFeedUseCase implements BaseUseCase<bool, UploadFeedParams> {
  final FeedRepository _feedRepository;

  UploadFeedUseCase(this._feedRepository);

  @override
  Future<Either<Failure, bool>> execute(UploadFeedParams params) async {
    if (params.session.user == null || params.session.location == null) {
      return const Left(Failure.sessionNotInitializedFailure);
    }
    final feed = Feed(
      userId: params.session.user!.id,
      userName: params.session.user!.name,
      imageId:
          '${params.session.user!.id}-${DateTime.now().millisecondsSinceEpoch}',
      location: params.session.location!,
      favorites: 0,
      pins: 0,
      imageFile: params.image,
    );
    return await _feedRepository.uploadFeed(feed);
  }
}

class UploadFeedParams extends Equatable {
  final File image;
  final Session session;

  const UploadFeedParams(
    this.image,
    this.session,
  );

  @override
  List<Object> get props => [
        image,
        session,
      ];
}
