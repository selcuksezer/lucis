import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lucis/data/models/user_model.dart';
import 'package:lucis/infrastructure/location/location_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> createNewUser(
    String id,
    String name,
  );
  Future<UserModel> getUser(String id);
  Future<bool> userExists(String id);
  Future<void> updateUserFavorites(String id, String newFavorite);
  Future<void> updateUserImages(String id, String newImageId);
  Future<void> updateUserPins(String id, LocationModel newPin);
  Future<void> updateUserAvatar(String id, File newAvatar);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserModel> createNewUser(
    String id,
    String name,
  ) async {
    final user = UserModel(id: id, name: name);

    final usersRef = FirebaseFirestore.instance.collection('users');
    await usersRef.doc(id).set(user.toDocument());

    return user;
  }

  @override
  Future<UserModel> getUser(String id) async {
    final userQueryData = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: id)
        .get();
    final userDoc = userQueryData.docs.first.data();
    return UserModel.fromDocument(userDoc);
  }

  @override
  Future<bool> userExists(String id) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: id)
        .get();
    if (userDoc.size > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> updateUserFavorites(String id, String newFavorite) async {
    final usersRef = FirebaseFirestore.instance.collection('users').doc(id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(usersRef);
      if (!snapshot.exists) {
        throw Exception("User $id does not exist!");
      }
      List<dynamic> newFavorites = snapshot.data()?['favorites'] ?? [];
      if (newFavorites.contains(newFavorite)) {
        return;
      } else {
        newFavorites.add(newFavorite);
        transaction.update(usersRef, {'favorites': newFavorites});
      }
    });
  }

  @override
  Future<void> updateUserImages(String id, String newImageId) async {
    final usersRef = FirebaseFirestore.instance.collection('users').doc(id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(usersRef);
      if (!snapshot.exists) {
        throw Exception("User $id does not exist!");
      }
      List<dynamic> newImages = snapshot.data()?['images'] ?? [];
      if (newImages.contains(newImageId)) {
        return;
      } else {
        final newLucis = snapshot.data()?['lucis'] + 1;
        newImages.add(newImageId);
        transaction.update(usersRef, {'images': newImages, 'lucis': newLucis});
      }
    });
  }

  @override
  Future<void> updateUserPins(String id, LocationModel newPin) async {
    final usersRef = FirebaseFirestore.instance.collection('users').doc(id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(usersRef);
      if (!snapshot.exists) {
        throw Exception("User $id does not exist!");
      }
      List<dynamic> newPins = snapshot.data()?['pins'] ?? [];
      if (newPins.contains(newPin)) {
        return;
      } else {
        newPins.add(newPin);
        transaction.update(usersRef, {'pins': newPins});
      }
    });
  }

  @override
  Future<void> updateUserAvatar(String id, File newAvatar) async {
    await FirebaseStorage.instance.ref('$id/$id-avatar').putFile(newAvatar);
  }
}
