import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/data/models/feed_model.dart';
import 'package:lucis/data/models/feed_stream_model.dart';
import 'package:lucis/infrastructure/location/location_model.dart';

abstract class FeedRemoteDataSource {
  Future<void> uploadFeed(FeedModel feed);

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
  Future<void> uploadFeed(FeedModel feed) async {
    if ((await feedExists(feed.imageId)) || feed.imageFile == null) {
      return;
    }
    await FirebaseStorage.instance
        .ref('${feed.userId}/${feed.imageId}')
        .putFile(feed.imageFile!);

    final feedDoc = feed.toDocument();
    if (feedDoc == null) return; // TODO: throw LocationNotRetrieved
    await FirebaseFirestore.instance
        .collection('feed')
        .doc(feed.imageId)
        .set(feedDoc);
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
    });
    return FeedStreamModel(
      feedStream: feedStream,
      center: LocationModel.fromGeoFirePoint(center),
      radius: radius,
    );
  }

  @override
  Future<bool> feedExists(String id) async {
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
  }

  @override
  Future<void> updateFeedFavorites(
    String id, {
    required int incrementBy,
  }) async {
    final feedRef = FirebaseFirestore.instance.collection('feed').doc(id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(feedRef);
      if (!snapshot.exists) {
        throw Exception("Feed $id does not exist!");
      }
      final newFavorites = snapshot.data()?['favorites'] + incrementBy;
      transaction.update(feedRef, {'favorites': newFavorites});
    });
  }

  @override
  Future<void> updateFeedPins(
    String id, {
    required int incrementBy,
  }) async {
    final feedRef = FirebaseFirestore.instance.collection('feed').doc(id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(feedRef);
      if (!snapshot.exists) {
        throw Exception("Feed $id does not exist!");
      }
      final newFavorites = snapshot.data()?['pins'] + incrementBy;
      transaction.update(feedRef, {'pins': newFavorites});
    });
  }
}
