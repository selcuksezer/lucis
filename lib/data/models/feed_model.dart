import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/location.dart';

class FeedModel extends Feed {
  FeedModel({
    required String userId,
    required String userName,
    required String? avatar,
    required String imageId,
    required Location location,
    int favorites = 0,
    int pins = 0,
  }) : super(
          userId: userId,
          userName: userName,
          avatar: avatar,
          imageId: imageId,
          location: location,
          favorites: favorites,
          pins: pins,
        );

  factory FeedModel.fromDocument(Map<String, dynamic> doc) {
    return FeedModel(
      userId: doc['userID'],
      userName: doc['userName'],
      avatar: doc['avatar'] ?? '${doc['userID']}-avatar',
      imageId: doc['imageID'],
      location: Location(doc['position']),
      favorites: doc['favorites'],
      pins: doc['pins'],
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
