import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/domain/entities/user.dart';
import 'package:lucis/domain/entities/location.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    List<String>? imageIds,
    int lucis = 0,
    List<String>? favorites,
    List<Location>? pins,
    List<String>? imageUrls,
    String? avatarUrl,
  }) : super(
          id: id,
          name: name,
          imageIds: imageIds ?? <String>[],
          lucis: lucis,
          favorites: favorites ?? <String>[],
          pins: pins ?? <Location>[],
          imageUrls: imageUrls,
          avatarUrl: avatarUrl,
        );

  factory UserModel.fromDocument(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['userID'],
      name: doc['userName'],
      imageIds: doc['images'] == null
          ? <String>[]
          : List<String>.from(
              doc['images'],
            ),
      lucis: doc['lucis'],
      favorites: doc['favorites'] == null
          ? <String>[]
          : List<String>.from(doc['favorites']),
      pins: doc['pins'] == null
          ? <Location>[]
          : List<GeoPoint>.from(doc['pins'])
              .map((geopoint) => Location(GeoFirePoint(
                    geopoint.latitude,
                    geopoint.longitude,
                  )))
              .toList(),
    );
  }

  Map<String, dynamic> toDocument() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return {
      'timestamp': timestamp,
      'userID': id,
      'userName': name,
      'images': imageIds.isEmpty ? null : imageIds,
      'lucis': lucis,
      'favorites': favorites.isEmpty ? null : favorites,
      'pins': pins.isEmpty ? null : pins,
    };
  }
}
