import 'package:dartz/dartz.dart';
import 'package:lucis/data/data_sources/remote_data_sources/feed_remote_data_source.dart';
import 'package:lucis/data/exceptions.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/feed_stream.dart';
import 'package:lucis/domain/failure.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/infrastructure/network/network_info.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _feedRemoteDataSource;
  final NetworkInfo _networkInfo;

  FeedRepositoryImpl(
    this._feedRemoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, bool>> uploadFeed(Feed feed) async {
    if (await _networkInfo.isConnected) {
      try {
        await _feedRemoteDataSource.uploadFeed(feed);
        return const Right(true);
      } on BadRequestException {
        return const Left(Failure.badRequestFailure);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }

  @override
  Future<Either<Failure, FeedStream>> getFeedWithin(
    GeoFirePoint center,
    double radius,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final feedStream = await _feedRemoteDataSource.getFeedWithin(
          center,
          radius,
        );
        return Right(feedStream);
      } on BadRequestException {
        return const Left(Failure.badRequestFailure);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }

  @override
  Future<Either<Failure, bool>> updateFeedFavorites(
    String id, {
    required int incrementBy,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _feedRemoteDataSource.updateFeedFavorites(
          id,
          incrementBy: incrementBy,
        );
        return const Right(true);
      } on BadRequestException {
        return const Left(Failure.badRequestFailure);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }

  @override
  Future<Either<Failure, bool>> updateFeedPins(
    String id, {
    required int incrementBy,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _feedRemoteDataSource.updateFeedPins(
          id,
          incrementBy: incrementBy,
        );
        return const Right(true);
      } on BadRequestException {
        return const Left(Failure.badRequestFailure);
      } on ServerException {
        return const Left(Failure.serverFailure);
      } on UnknownException {
        return const Left(Failure.unknownFailure);
      }
    } else {
      return const Left(Failure.connectionFailure);
    }
  }
}
