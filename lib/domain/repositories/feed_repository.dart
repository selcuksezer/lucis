import 'package:dartz/dartz.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/feed_stream.dart';
import 'package:lucis/domain/failure.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

abstract class FeedRepository {
  Future<Either<Failure, bool>> uploadFeed(Feed feed);

  Future<Either<Failure, FeedStream>> getFeedWithin(
    GeoFirePoint center,
    double radius,
  );

  Future<Either<Failure, bool>> updateFeedFavorites(
    String id, {
    required int incrementBy,
  });

  Future<Either<Failure, bool>> updateFeedPins(
    String id, {
    required int incrementBy,
  });
}
