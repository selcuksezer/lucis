import 'package:lucis/domain/entities/location.dart';

class User {
  final String id;
  final String name;
  final List<String> imageIds;
  int lucis;
  final List<String> favorites;
  final List<Location> pins;
  List<String>? imageUrls;
  String? avatarUrl;

  User(
      {required this.id,
      required this.name,
      required this.imageIds,
      required this.lucis,
      required this.favorites,
      required this.pins,
      this.imageUrls,
      this.avatarUrl});
}
