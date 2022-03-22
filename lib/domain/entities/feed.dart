import 'package:lucis/domain/entities/location.dart';

class Feed {
  final String userId;
  final String userName;
  final String? avatar;
  final String imageId;
  final Location location;
  int favorites;
  int pins;

  Feed({
    required this.userId,
    required this.userName,
    this.avatar,
    required this.imageId,
    required this.location,
    required this.favorites,
    required this.pins,
  });
}
