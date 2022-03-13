import 'dart:async';
import 'dart:collection';
import 'package:lucis/helpers/firebase_storage_helper.dart';
import 'package:lucis/models/location.dart';
import 'package:lucis/models/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FeedItem {
  FeedItem({
    required this.userID,
    required this.userName,
    this.avatar,
    required this.image,
    required this.location,
    required this.favorites,
    required this.pins,
  });

  final String userID;
  final String userName;
  final Image? avatar;
  final Image image;
  final Location location;
  int favorites;
  int pins;
}

class Feed {
  Feed({required this.userID, required this.feedLocation});

  final List<FeedItem> _feed = [];
  final _documentSnapshotCache =
      ListQueue<DocumentSnapshot<Map<String, dynamic>>>();
  StreamSubscription<List<FeedItem>>? _streamSubscription;
  Location feedLocation;
  String userID;
  bool streamOn = false;

  Future<List<FeedItem>> getFeedPage(int pageNumber, int pageSize) async {
    while (!streamOn) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    final index = pageSize * pageNumber;
    if (index <= _feed.length) {
      return _feed.sublist(index);
    } else {
      return [];
    }
  }

  void updateFeed(dynamic feedList) {
    streamOn = true;
  }

  void startFeed({
    Function(List<FeedItem>)? listener,
    double fetchRadius = 1000.0,
  }) {
    if (feedLocation.geoLocation != null) {
      final firestoreRef = FirebaseFirestore.instance.collection('feed');

      final geoRef = Geoflutterfire().collection(collectionRef: firestoreRef);

      final stream = geoRef.within(
          center: feedLocation.geoLocation!,
          radius: fetchRadius,
          field: 'position');

      //   stream.listen(updateFeed);
      Stream<List<FeedItem>> feedStream =
          stream.asyncMap((event) => _toFeed(event));
      _streamSubscription = feedStream.listen(updateFeed);
    }
  }

  void cancelFeed() {
    _streamSubscription?.cancel();
  }

  Future<List<FeedItem>> _toFeed(
      List<DocumentSnapshot<Map<String, dynamic>>> docList) async {
    List<DocumentSnapshot<Map<String, dynamic>>> newDocsList;
    if (_documentSnapshotCache.isNotEmpty) {
      newDocsList =
          docList.toSet().difference(_documentSnapshotCache.toSet()).toList();
    } else {
      newDocsList = docList;
    }
    _documentSnapshotCache.addAll(docList);
    for (var doc in newDocsList) {
      final avatarURL = await FirebaseStorageHelper.downloadAvatarURL(
        userID: doc['userID'],
      );
      final imageURL = await FirebaseStorageHelper.downloadImageURL(
        userID: doc['userID'],
        imageID: doc['imageID'],
      );
      if (imageURL == null) {
        continue;
      }

      final avatar = avatarURL != null
          ? Image.fromURL(
              url: avatarURL,
              id: '${doc['userID']}-avatar',
            )
          : null;

      final image = Image.fromURL(
        url: imageURL,
        id: doc['userID'],
      );

      _feed.add(FeedItem(
        userID: doc['userID'],
        userName: doc['userName'],
        avatar: avatar,
        image: image,
        location: Location.fromGeoPoint(doc['position']['geopoint']),
        favorites: doc['favorites'],
        pins: doc['pins'],
      ));
    }

    return _feed;
  }
}
