import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucis/domain/repositories/marker_repository.dart';
import 'package:lucis/domain/entities/marker.dart';
import 'package:lucis/utils/extensions/image_extension.dart';
import 'package:image/image.dart';
import 'package:lucis/data/data_sources/remote_data_sources/feed_remote_data_source.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/infrastructure/network/network_info.dart';
import 'package:lucis/data/exceptions.dart';
import 'package:lucis/constants.dart';

class MarkerRepositoryImpl extends MarkerRepository {
  final FeedRemoteDataSource _feedDataSource;
  final NetworkInfo _networkInfo;

  MarkerRepositoryImpl(
    this._feedDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Stream<List<ImageMarker>>>> getMarkerStream({
    required GeoFirePoint center,
    required double radius,
    required void Function(String markerId) onTap,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final feedStream = await _feedDataSource.getFeedWithin(center, radius);
        final markerStream = feedStream.feedStream.asyncMap((feedList) async {
          final markerList = <ImageMarker>[];
          await Future.forEach<Feed>(feedList, (feed) async {
            if (feed.imageUrl != null) {
              final imageRect =
                  await MarkerUtils.imageFromNetwork(feed.imageUrl!);
              final image =
                  imageRect?.circularCropResize(radius: kDefaultMarkerSize);
              Image? avatar;

              if (feed.avatar != null) {
                final avatarRect =
                    await MarkerUtils.imageFromNetwork(feed.avatar!);
                avatar =
                    avatarRect?.circularCropResize(radius: kDefaultMarkerSize);
              } else {
                final avatarRect =
                    await MarkerUtils.imageFromAsset(kDefaultAvatarPath);
                avatar =
                    avatarRect?.circularCropResize(radius: kDefaultMarkerSize);
              }

              if (image != null) {
                markerList.add(
                  ImageMarker(
                    feed: feed,
                    markerId: MarkerId(feed.imageId),
                    position: LatLng(
                      feed.location.geoFirePoint.latitude,
                      feed.location.geoFirePoint.longitude,
                    ),
                    image: image,
                    onMarkerTap: onTap,
                    avatar: avatar,
                  ),
                );
              }
            }
          });
          return markerList;
        });
        return Right(markerStream);
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
  Future<Either<Failure, List<ImageMarker>>> getMarkers({
    required GeoFirePoint center,
    required double radius,
    required void Function(String markerId) onTap,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final feedStream = await _feedDataSource.getFeedWithin(center, radius);

        final markerList = <ImageMarker>[];
        await for (var feedList in feedStream.feedStream) {
          for (var feed in feedList) {
            if (feed.imageUrl != null) {
              final image = await MarkerUtils.imageFromNetwork(feed.imageUrl!);
              Image? avatar;

              if (feed.avatar != null) {
                avatar = await MarkerUtils.imageFromNetwork(feed.avatar!);
              } else {
                avatar = await MarkerUtils.imageFromAsset(kDefaultAvatarPath);
              }

              if (image != null) {
                markerList.add(
                  ImageMarker(
                    feed: feed,
                    markerId: MarkerId(feed.imageId),
                    position: LatLng(
                      feed.location.geoFirePoint.latitude,
                      feed.location.geoFirePoint.longitude,
                    ),
                    image: image,
                    onMarkerTap: onTap,
                    avatar: avatar,
                  ),
                );
              }
            }
          }
        }
        return Right(markerList);
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
