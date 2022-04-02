import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/data/exceptions.dart';
import 'package:lucis/data/models/feed_model.dart';
import 'package:lucis/data/models/feed_stream_model.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/infrastructure/location/location_model.dart';

abstract class FeedRemoteDataSource {
  Future<void> uploadFeed(Feed feed);

  Future<FeedStreamModel> getFeedWithin(
    GeoFirePoint center,
    double radius,
  );
  Future<bool> feedExists(String id);
  Future<void> updateFeedFavorites(
    String id, {
    required int incrementBy,
  });
  Future<void> updateFeedPins(
    String id, {
    required int incrementBy,
  });
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  @override
  Future<void> uploadFeed(Feed newFeed) async {
    FeedModel feed = FeedModel.fromFeed(newFeed);
    final feedDoc = feed.toDocument();
    if (feedDoc == null) {
      throw (const BadRequestException(
          'Tried to upload the feed with no location!'));
    }

    if ((await feedExists(feed.imageId))) {
      throw (const BadRequestException('Feed already exists!'));
    }

    if (feed.imageFile == null) {
      throw (const BadRequestException(
          'Tried to upload the feed with no image!'));
    }
    try {
      // update file db
      await FirebaseStorage.instance
          .ref('${feed.userId}/${feed.imageId}')
          .putFile(feed.imageFile!);

      // update feed db
      await FirebaseFirestore.instance
          .collection('feed')
          .doc(feed.imageId)
          .set(feedDoc);

      // update user db
      final usersRef =
          FirebaseFirestore.instance.collection('users').doc(feed.userId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(usersRef);
        if (!snapshot.exists) {
          throw BadRequestException("User ${feed.userId} does not exist!");
        }
        List<dynamic> newImages = snapshot.data()?['images'] ?? [];
        if (newImages.contains(feed.imageId)) {
          return;
        } else {
          final newLucis = snapshot.data()?['lucis'] + 1;
          newImages.add(feed.imageId);
          transaction
              .update(usersRef, {'images': newImages, 'lucis': newLucis});
        }
      });
    } on BadRequestException {
      throw BadRequestException("User ${feed.userId} does not exist!");
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
  }

  @override
  Future<FeedStreamModel> getFeedWithin(
    GeoFirePoint center,
    double radius,
  ) async {
    final firestoreRef = FirebaseFirestore.instance.collection('feed');
    final geoRef = Geoflutterfire().collection(collectionRef: firestoreRef);

    final stream =
        geoRef.within(center: center, radius: radius, field: 'position');

    Stream<List<FeedModel>> feedStream = stream.asyncMap((event) async {
      try {
        List<FeedModel> feedList = [];
        for (var docSnapshot in event) {
          if (docSnapshot.data() == null) continue;
          final feed = FeedModel.fromDocument(docSnapshot.data()!);
          final imageUrl = await FirebaseStorage.instance
              .ref('${feed.userId}/${feed.imageId}')
              .getDownloadURL();
          final avatarUrl = await FirebaseStorage.instance
              .ref('${feed.userId}/${feed.userId}-avatar')
              .getDownloadURL();
          feed.imageUrl = imageUrl;
          feed.avatar = avatarUrl;
          feedList.add(feed);
        }
        return feedList;
      } on FirebaseException catch (e) {
        throw (ServerException(
            'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
      } catch (e) {
        throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
      }
    });

    return FeedStreamModel(
      feedStream: feedStream,
      center: LocationModel.fromGeoFirePoint(center),
      radius: radius,
    );
  }

  @override
  Future<bool> feedExists(String id) async {
    try {
      final feedDoc = await FirebaseFirestore.instance
          .collection('feed')
          .where(
            'imageID',
            isEqualTo: id,
          )
          .get();
      if (feedDoc.size > 0) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
  }

  @override
  Future<void> updateFeedFavorites(
    String id, {
    required int incrementBy,
  }) async {
    final feedRef = FirebaseFirestore.instance.collection('feed').doc(id);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(feedRef);
        if (!snapshot.exists) {
          throw BadRequestException("Feed $id does not exist!");
        }
        final newFavorites = snapshot.data()?['favorites'] + incrementBy;
        transaction.update(feedRef, {'favorites': newFavorites});
      });
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
  }

  @override
  Future<void> updateFeedPins(
    String id, {
    required int incrementBy,
  }) async {
    final feedRef = FirebaseFirestore.instance.collection('feed').doc(id);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(feedRef);
        if (!snapshot.exists) {
          throw BadRequestException("Feed $id does not exist!");
        }
        final newFavorites = snapshot.data()?['pins'] + incrementBy;
        transaction.update(feedRef, {'pins': newFavorites});
      });
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
  }
}
