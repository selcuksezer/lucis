import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/models/user.dart';

class FirebaseFirestoreHelper {
  static Future<void> test() async {
    // final geo = Geoflutterfire();
    // final _firestore = FirebaseFirestore.instance;
    // GeoFirePoint myLocation =
    //     geo.point(latitude: 12.960632, longitude: 81.641603);
    //
    // final val = await FirebaseFirestoreHelper.incrementFirestoreFeedPins(
    //     imageID: 'mycat.jpg');
    // print(val);
    final user = await User.getUser(userID: '@tolstoy', userName: 'boitoi');
    //  final user = await queryUserData('@oramakoma');
    print(user?.favorites);
    // _firestore.collection('feed').add({'position': myLocation.data});
  }

  static Map<String, dynamic> createFirestoreFeedDoc({
    required int timestamp,
    required GeoFirePoint position,
    required String userID,
    required String userName,
    required int favorites,
    required int pins,
    required String imageID,
  }) =>
      {
        'timestamp': timestamp,
        'position': position.data,
        'userID': userID,
        'userName': userName,
        'favorites': favorites,
        'pins': pins,
        'imageID': imageID,
      };

  static Map<String, dynamic> createFirestoreUserDoc({
    required int timestamp,
    required String userID,
    required String userName,
    required int lucis,
    List<String>? favorites,
    List<dynamic>? pins,
    List<String>? images,
  }) =>
      {
        'timestamp': timestamp,
        'userID': userID,
        'userName': userName,
        'lucis': lucis,
        'favorites': favorites,
        'pins': pins,
        'images': images,
      };

  static Future<bool> userExists(String userID) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: userID)
        .get();
    if (userDoc.size > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> feedExists(String imageID) async {
    final feedDoc = await FirebaseFirestore.instance
        .collection('feed')
        .where('imageID', isEqualTo: imageID)
        .get();
    if (feedDoc.size > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Map<String, dynamic>> queryUserData(String userID) async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: userID)
        .get();
    return userData.docs.first.data();
  }

  static Future<bool> addNewUser({
    required String userID,
    required String userName,
    List<String>? favorites,
    List<dynamic>? pins,
    List<String>? images,
  }) async {
    if (await userExists(userID)) {
      return false;
    }
    bool isSuccess = false;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final lucis = images?.length ?? 0;

    final data = FirebaseFirestoreHelper.createFirestoreUserDoc(
      timestamp: timestamp,
      userID: userID,
      userName: userName,
      lucis: lucis,
      favorites: favorites,
      pins: pins,
      images: images,
    );

    final usersRef = FirebaseFirestore.instance.collection('users');
    await usersRef
        .doc(userID)
        .set(data)
        .then((value) => isSuccess = true)
        .catchError((onError) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> updateFeed({
    /// This method adds new feed to firestore. To ensure user and feed
    /// collections remain in sync, updating user collection is also done here.
    required GeoFirePoint position,
    required String userID,
    required String userName,
    required String imageID,
    int favorites = 0,
    int pins = 0,
  }) async {
    if (await feedExists(imageID)) {
      return false;
    }

    final addedToUser =
        await _updateFirestoreUserImages(userID: userID, imageID: imageID);
    if (!addedToUser) return false;

    bool isSuccess = false;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = FirebaseFirestoreHelper.createFirestoreFeedDoc(
      timestamp: timestamp,
      position: position,
      userID: userID,
      userName: userName,
      imageID: imageID,
      favorites: favorites,
      pins: pins,
    );

    final usersRef = FirebaseFirestore.instance.collection('feed');
    await usersRef
        .doc(imageID)
        .set(data)
        .then((value) => isSuccess = true)
        .catchError((onError) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> _updateFirestoreUserImages({
    required String userID,
    required String imageID,
  }) async {
    bool isSuccess = false;
    final usersRef = FirebaseFirestore.instance.collection('users').doc(userID);
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(usersRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          List<dynamic> newImages = snapshot.data()?['images'] ?? [];
          if (newImages.contains(imageID)) {
            return;
          } else {
            final newLucis = snapshot.data()?['lucis'] + 1;
            newImages.add(imageID);
            transaction
                .update(usersRef, {'images': newImages, 'lucis': newLucis});
          }
        })
        .then((value) => isSuccess = true)
        .catchError((error) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> updateFirestoreUserFavorites({
    required String userID,
    required String favoriteID,
  }) async {
    bool isSuccess = false;
    final usersRef = FirebaseFirestore.instance.collection('users').doc(userID);
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(usersRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          List<dynamic> newFavorites = snapshot.data()?['favorites'] ?? [];
          if (newFavorites.contains(favoriteID)) {
            return;
          } else {
            newFavorites.add(favoriteID);
            transaction.update(usersRef, {'favorites': newFavorites});
          }
        })
        .then((value) => isSuccess = true)
        .catchError((error) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> updateFirestoreUserPins({
    required String userID,
    required dynamic pin,
  }) async {
    bool isSuccess = false;
    final usersRef = FirebaseFirestore.instance.collection('users').doc(userID);
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(usersRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          List<dynamic> newPins = snapshot.data()?['pins'] ?? [];
          if (newPins.contains(pin)) {
            return;
          } else {
            newPins.add(pin);
            transaction.update(usersRef, {'pins': newPins});
          }
        })
        .then((value) => isSuccess = true)
        .catchError((error) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> incrementFirestoreFeedFavorites({
    required String imageID,
  }) async {
    bool isSuccess = false;
    final usersRef = FirebaseFirestore.instance.collection('feed').doc(imageID);
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(usersRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          final newFavorites = snapshot.data()?['favorites'] + 1;
          transaction.update(usersRef, {'favorites': newFavorites});
        })
        .then((value) => isSuccess = true)
        .catchError((error) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> decrementFirestoreFeedFavorites({
    required String imageID,
  }) async {
    bool isSuccess = false;
    final usersRef = FirebaseFirestore.instance.collection('feed').doc(imageID);
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(usersRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          final newFavorites = snapshot.data()?['favorites'] - 1;
          transaction.update(usersRef, {'favorites': newFavorites});
        })
        .then((value) => isSuccess = true)
        .catchError((error) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> incrementFirestoreFeedPins({
    required String imageID,
  }) async {
    bool isSuccess = false;
    final usersRef = FirebaseFirestore.instance.collection('feed').doc(imageID);
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(usersRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          final newPins = snapshot.data()?['pins'] + 1;
          transaction.update(usersRef, {'pins': newPins});
        })
        .then((value) => isSuccess = true)
        .catchError((error) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> decrementFirestoreFeedPins({
    required String imageID,
  }) async {
    bool isSuccess = false;
    final usersRef = FirebaseFirestore.instance.collection('feed').doc(imageID);
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(usersRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          final newPins = snapshot.data()?['pins'] - 1;
          transaction.update(usersRef, {'pins': newPins});
        })
        .then((value) => isSuccess = true)
        .catchError((error) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> addAuth({
    required String userID,
    required String email,
  }) async {
    bool isSuccess = false;
    final authRef = FirebaseFirestore.instance.collection('auth');
    await authRef
        .doc(email)
        .set({userID: userID})
        .then((value) => isSuccess = true)
        .catchError((onError) => isSuccess = false);
    return isSuccess;
  }

  static Future<bool> checkAuth({
    required String userID,
    required String email,
  }) async {
    bool isSuccess = false;
    final authRef = FirebaseFirestore.instance.collection('auth');
    await authRef.doc(email).get().then((value) {
      if (value.data()?.keys.first == userID) {
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    }).catchError((onError) {
      print(onError);
      isSuccess = false;
    });
    return isSuccess;
  }

  static Future<String?> getAuth({
    required String email,
  }) async {
    String? id;
    final authRef = FirebaseFirestore.instance.collection('auth');
    await authRef.doc(email).get().then((value) {
      id = value.data()?.keys.first;
    }).catchError((onError) => null);
    return id;
  }
}
