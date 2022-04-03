import 'package:lucis/models/feed.dart';
import 'package:lucis/models/location.dart';

class FeedViewModel {
  static const size = 10;

  FeedViewModel({required String userID, required Location location})
      : _userID = userID,
        _location = location,
        _feed = Feed(userID: userID, feedLocation: location) {
    _feed.startFeed();
  }

  Location _location;
  String _userID;
  final Feed _feed;

  set setFeedLocation(Location loc) {
    _location = loc;
  }

  Future<List<FeedItem>> fetchFeedPage(
    int pageKey,
  ) async {
    return await _feed.getFeedPage(pageKey, size);
  }
}
