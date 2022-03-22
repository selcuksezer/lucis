import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucis/data/models/feed_model.dart';
import 'package:lucis/data/models/feed_stream_model.dart';

abstract class FeedRemoteDataSource {
  Future<void> uploadFeed(FeedModel feed);

  Future<FeedStreamModel> getFeedWithin(
    dynamic center,
    double radius,
  );
  Future<bool> feedExists(String id);
  Future<void> updateFeedFavorites(int incrementBy);
  Future<void> updateFeedPins(int incrementBy);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  @override
  Future<void> uploadFeed({
    required String userID,
    required String userName,
    required dynamic position,
    required String imageID,
    int favorites = 0,
    int pins = 0,
  }) async {
    if (await feedExists(imageID)) {
      return;
    }
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
}
