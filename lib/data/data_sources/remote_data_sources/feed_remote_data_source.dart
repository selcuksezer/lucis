import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FeedRemoteDataSource {
  Future<void> createFeed({
    required String userID,
    required String userName,
    required dynamic position,
    required String imageID,
    int favorites = 0,
    int pins = 0,
  });
  Future<User> getFeedWithin(
    dynamic center,
    double radius,
  );
  Future<void> feedExists(String id);
  Future<void> updateFeedFavorites(int incrementBy);
  Future<void> updateFeedPins(int incrementBy);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {}
