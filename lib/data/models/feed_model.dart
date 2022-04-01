import 'dart:io';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/location.dart';

class FeedModel extends Feed {
  FeedModel({
    required String userId,
    required String userName,
    required String imageId,
    required Location location,
    int favorites = 0,
    int pins = 0,
    String? avatar,
    String? imageUrl,
    File? imageFile,
  }) : super(
          userId: userId,
          userName: userName,
          imageId: imageId,
          location: location,
          favorites: favorites,
          pins: pins,
          avatar: avatar,
          imageUrl: imageUrl,
          imageFile: imageFile,
        );

  factory FeedModel.fromDocument(Map<String, dynamic> doc) {
    return FeedModel(
      userId: doc['userID'],
      userName: doc['userName'],
      imageId: doc['imageID'],
      location: Location(doc['position']),
      favorites: doc['favorites'],
      pins: doc['pins'],
    );
  }

  factory FeedModel.fromFeed(Feed feed) {
    return FeedModel(
      userId: feed.userId,
      userName: feed.userName,
      imageId: feed.imageId,
      location: feed.location,
      favorites: feed.favorites,
      pins: feed.pins,
    );
  }

  Map<String, dynamic>? toDocument() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final position = location.geoFirePoint?.data;
    return position == null
        ? null
        : {
            'timestamp': timestamp,
            'position': position,
            'userID': userId,
            'userName': userName,
            'favorites': favorites,
            'pins': pins,
            'imageID': imageId,
          };
  }
}
