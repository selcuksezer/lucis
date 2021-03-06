import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lucis/data/models/user_model.dart';
import 'package:lucis/data/exceptions.dart';
import 'package:lucis/domain/entities/location.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> createNewUser(
    String id,
    String name,
  );
  Future<UserModel> getUser(String id);
  Future<Map<String?, List<String>>> getUserImagePage(
    String id, {
    required int limit,
    String? pageToken,
  });
  Future<bool> userExists(String id);
  Future<void> updateUserFavorites(
    String id,
    String newFavorite, {
    bool add = true,
  });
  Future<void> updateUserImages(String id, String newImageId);
  Future<void> updateUserPins(
    String id,
    Location newPin, {
    bool add = true,
  });
  Future<String> updateUserAvatar(String id, File newAvatar);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserModel> createNewUser(
    String id,
    String name,
  ) async {
    final user = UserModel(id: id, name: name);
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      await usersRef.doc(id).set(user.toDocument());
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
    return user;
  }

  @override
  Future<UserModel> getUser(String id) async {
    if (await userExists(id)) {
      try {
        final userQueryData = await FirebaseFirestore.instance
            .collection('users')
            .where('userID', isEqualTo: id)
            .get();
        final userDoc = userQueryData.docs.first.data();
        final userModel = UserModel.fromDocument(userDoc);
        String? avatarUrl;

        final avatarRef = FirebaseStorage.instance.ref('$id/$id-avatar');

        try {
          avatarUrl = await avatarRef.getDownloadURL();
        } on FirebaseException {
          // no avatar exists
        }

        userModel.avatarUrl = avatarUrl;

        return userModel;
      } on FirebaseException catch (e) {
        throw (ServerException(
            'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
      } catch (e) {
        throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
      }
    } else {
      throw (BadRequestException('User $id does not exist!'));
    }
  }

  @override
  Future<Map<String?, List<String>>> getUserImagePage(
    String id, {
    required int limit,
    String? pageToken,
  }) async {
    try {
      List<String> urls = [];
      final listResult = await FirebaseStorage.instance.ref('$id/').list(
            ListOptions(
              maxResults: limit,
              pageToken: pageToken,
            ),
          );

      for (var ref in listResult.items) {
        await ref.getDownloadURL().then((url) => urls.add(url));
      }
      return {listResult.nextPageToken: urls};
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
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
  Future<void> updateUserFavorites(
    String id,
    String newFavorite, {
    bool add = true,
  }) async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users').doc(id);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(usersRef);
        if (!snapshot.exists) {
          throw BadRequestException("User $id does not exist!");
        }
        List<dynamic> newFavorites = snapshot.data()?['favorites'] ?? [];
        if (newFavorites.contains(newFavorite)) {
          return;
        } else {
          if (add) {
            newFavorites.add(newFavorite);
          } else {
            newFavorites.remove(newFavorite);
          }
          transaction.update(usersRef, {'favorites': newFavorites});
        }
      });
    } on BadRequestException {
      throw BadRequestException("User $id does not exist!");
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
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
  Future<void> updateUserPins(
    String id,
    Location newPin, {
    bool add = true,
  }) async {
    final pin = newPin.geoFirePoint.geoPoint;

    try {
      final usersRef = FirebaseFirestore.instance.collection('users').doc(id);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(usersRef);
        if (!snapshot.exists) {
          throw Exception("User $id does not exist!");
        }
        List<dynamic> newPins = snapshot.data()?['pins'] ?? [];
        if (newPins.contains(pin)) {
          return;
        } else {
          if (add) {
            newPins.add(pin);
          } else {
            newPins.remove(pin);
          }

          transaction.update(usersRef, {'pins': newPins});
        }
      });
    } on BadRequestException {
      throw BadRequestException("User $id does not exist!");
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
  }

  @override
  Future<String> updateUserAvatar(String id, File newAvatar) async {
    try {
      final storageRef = FirebaseStorage.instance.ref('$id/$id-avatar');
      await storageRef.putFile(newAvatar);
      return await storageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      throw (ServerException(
          'FirebaseException. Code: ${e.code}. Message: ${e.message}. StackTrace: ${e.stackTrace}'));
    } catch (e) {
      throw (UnknownException('Unknown exception occurred! ${e.toString()}'));
    }
  }
}
