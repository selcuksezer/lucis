import 'dart:io';
import 'package:lucis/domain/entities/location.dart';

class Feed {
  final String userId;
  final String userName;
  final String imageId;
  final Location location;
  int favorites;
  int pins;
  String? avatar;
  String? imageUrl;
  File? imageFile;

  Feed({
    required this.userId,
    required this.userName,
    required this.imageId,
    required this.location,
    required this.favorites,
    required this.pins,
    this.avatar,
    this.imageUrl,
    this.imageFile,
  });
}
