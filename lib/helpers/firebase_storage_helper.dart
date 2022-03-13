import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageHelper {
  static Future<bool> uploadImage(
    File file, {
    required String userID,
    required String imageID,
  }) async {
    try {
      await FirebaseStorage.instance.ref('$userID/$imageID').putFile(file);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<bool> uploadAvatar(
    File file, {
    required String userID,
  }) async {
    try {
      await FirebaseStorage.instance
          .ref('$userID/$userID-avatar')
          .putFile(file);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<String?> downloadImageURL({
    required String userID,
    required String imageID,
  }) async {
    try {
      final imageURL = await FirebaseStorage.instance
          .ref('$userID/$imageID')
          .getDownloadURL();
      return imageURL;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<File?> downloadImage({
    required String userID,
    required String imageID,
  }) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$userID-$imageID');

    try {
      await FirebaseStorage.instance
          .ref('$userID/$imageID')
          .writeToFile(downloadToFile);
      return downloadToFile;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<String?> downloadAvatarURL({
    required String userID,
  }) async {
    try {
      final imageURL = await FirebaseStorage.instance
          .ref('$userID/$userID-avatar')
          .getDownloadURL();
      return imageURL;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<File?> downloadAvatar({
    required String userID,
  }) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$userID-avatar');

    try {
      await FirebaseStorage.instance
          .ref('$userID/$userID-avatar')
          .writeToFile(downloadToFile);
      return downloadToFile;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<List<String?>> downloadImageURLBatch({
    required List<String> userIDs,
    required List<String> imageIDs,
  }) async {
    final _storage = FirebaseStorage.instance;
    List<String?> imageURLs = [];
    for (var i = 0; i < imageIDs.length; i++) {
      try {
        final url = await _storage
            .ref('${userIDs[i]})/${imageIDs[i]}')
            .getDownloadURL();
        imageURLs.add(url);
      } catch (e) {
        imageURLs.add(null);
      }
    }
    return imageURLs;
  }

  static Future<Map<String?, List<File>>> downloadImageFilesPaginated(
      {required String userID, required int limit, String? pageToken}) async {
    List<File> downloadedFiles = [];
    Directory tempDir = await getTemporaryDirectory();
    if (pageToken == null) {
      final listResult = await FirebaseStorage.instance
          .ref('$userID/')
          .list(ListOptions(maxResults: limit));

      for (var ref in listResult.items) {
        File downloadToFile =
            File('${tempDir.path}/storage_download_temp_${ref.name}');
        await ref
            .writeToFile(downloadToFile)
            .then((p0) => downloadedFiles.add(downloadToFile));
      }
      return {listResult.nextPageToken: downloadedFiles};
    }

    final listResult = await FirebaseStorage.instance.ref('$userID/').list(
          ListOptions(
            maxResults: limit,
            pageToken: pageToken,
          ),
        );

    for (var ref in listResult.items) {
      File downloadToFile =
          File('${tempDir.path}/storage_download_temp_${ref.name}');
      await ref
          .writeToFile(downloadToFile)
          .then((p0) => downloadedFiles.add(downloadToFile));
    }
    return {listResult.nextPageToken: downloadedFiles};
  }

  static Future<Map<String?, List<String>>> downloadImageURLsPaginated({
    required String userID,
    required int limit,
    String? pageToken,
  }) async {
    List<String> urls = [];
    if (pageToken == null) {
      final listResult = await FirebaseStorage.instance
          .ref('$userID/')
          .list(ListOptions(maxResults: limit));

      for (var ref in listResult.items) {
        await ref.getDownloadURL().then((url) => urls.add(url));
      }
      return {listResult.nextPageToken: urls};
    }

    final listResult = await FirebaseStorage.instance.ref('$userID/').list(
          ListOptions(
            maxResults: limit,
            pageToken: pageToken,
          ),
        );

    for (var ref in listResult.items) {
      await ref.getDownloadURL().then((url) => urls.add(url));
    }
    return {listResult.nextPageToken: urls};
  }
}
