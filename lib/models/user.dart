import 'dart:io';
import 'package:lucis/helpers/firebase_firestore_helper.dart';
import 'package:lucis/helpers/firebase_storage_helper.dart';

class User {
  User._({
    required this.id,
    required this.name,
    required this.lucis,
    required this.favorites,
    required this.pins,
    required this.images,
    this.avatar,
  });

  final String id;
  final String name;
  int lucis;
  List<dynamic> favorites;
  List<dynamic> pins;
  List<dynamic> images;
  File? avatar;

  static Future<User?> getUser({
    required String userID,
    required String userName,
  }) async {
    final userExists = await FirebaseFirestoreHelper.userExists(userID);
    if (userExists) {
      final userData = await FirebaseFirestoreHelper.queryUserData(userID);
      return User._(
        id: userData['userID'],
        name: userData['userName'],
        lucis: userData['lucis'],
        favorites: userData['favorites'] ?? [],
        pins: userData['pins'] ?? [],
        images: userData['images'] ?? [],
      );
    } else {
      final result = await FirebaseFirestoreHelper.addNewUser(
        userID: userID,
        userName: userName,
      );
      if (!result) {
        return null;
      }
      final avatarImage =
          await FirebaseStorageHelper.downloadAvatar(userID: userID);

      return User._(
        id: userID,
        name: userName,
        lucis: 0,
        favorites: <String>[],
        pins: <dynamic>[],
        images: <String>[],
        avatar: avatarImage,
      );
    }
  }

  void addNewImage(String imageID) {
    images.add(imageID);
    lucis++;
  }

  Future<File?> fetchUserAvatar() async {
    final userAvatar = await FirebaseStorageHelper.downloadAvatar(userID: id);
    if (userAvatar != null) {
      avatar = userAvatar;
    }
    return userAvatar;
  }

  Future<bool> updateUserAvatar(File avatarImage) async {
    final result =
        await FirebaseStorageHelper.uploadAvatar(avatarImage, userID: id);
    if (result) {
      avatar = avatarImage;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addNewFavorite(String imageID) async {
    final result = await FirebaseFirestoreHelper.updateFirestoreUserFavorites(
        userID: id, favoriteID: imageID);
    if (result) {
      favorites.add(imageID);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addNewPin(dynamic pin) async {
    final result = await FirebaseFirestoreHelper.updateFirestoreUserPins(
        userID: id, pin: pin);
    if (result) {
      pins.add(pin);
      return true;
    } else {
      return false;
    }
  }
}
