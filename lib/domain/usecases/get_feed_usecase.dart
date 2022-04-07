import 'package:dartz/dartz.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/domain/entities/feed_stream.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetFeedUseCase implements BaseUseCase<FeedStream, GetFeedParams> {
  final FeedRepository _feedRepository;

  GetFeedUseCase(this._feedRepository);

  @override
  Future<Either<Failure, FeedStream>> execute(GetFeedParams params) async {
    return await _feedRepository.getFeedWithin(
      params.center,
      params.radius,
    );
  }
}

class GetFeedParams extends Equatable {
  final GeoFirePoint center;
  final double radius;

  const GetFeedParams(
    this.center, {
    required this.radius,
  });

  @override
  List<Object> get props => [
        center,
        radius,
      ];
}
