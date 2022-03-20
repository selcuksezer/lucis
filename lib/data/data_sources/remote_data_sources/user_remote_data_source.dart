import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserRemoteDataSource {
  Future<void> createUser(
    String id,
    String name,
  );
  Future<User> getUser(String id);
  Future<void> userExists();
  Future<void> updateUserFavorites(String newFavorite);
  Future<void> updateUserImages(String newImageId);
  Future<void> updateUserPins(dynamic newPin);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {}
