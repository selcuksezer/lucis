import 'dart:io';
import 'package:lucis/models/location.dart';
import 'package:lucis/models/user.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;
import 'package:image_picker/image_picker.dart';
import 'package:lucis/helpers/firebase_storage_helper.dart';
import '../helpers/firebase_firestore_helper.dart';

class Image {
  Image({required this.imageID, this.image, this.imageURL});

  Image.fromURL({required String url, required String id})
      : imageURL = url,
        imageID = '$id-${DateTime.now().millisecondsSinceEpoch}';
  Image.fromFile({required File file, required String id})
      : image = file,
        imageID = '$id-${DateTime.now().millisecondsSinceEpoch}';

  File? image;
  String? imageURL;
  String imageID;

  static Future<Image?> imageFromCamera(String id) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );
    if (image != null) {
      return Image.fromFile(file: File(image.path), id: id);
    }
    return null;
  }

  static Future<Image?> imageFromGallery(String id) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 600,
    );
    if (image != null) {
      return Image.fromFile(file: File(image.path), id: id);
    }
    return null;
  }

  Future<bool> uploadImageToFirebase({
    required User user,
    required Location location,
  }) async {
    if (image == null) {
      return false;
    }
    final storageSuccess = await FirebaseStorageHelper.uploadImage(
      image!,
      userID: user.id,
      imageID: imageID,
    );

    if (!storageSuccess) {
      return false;
    }

    final geoPoint = location.geoLocation;
    if (geoPoint == null) {
      return false;
    }
    final result = await FirebaseFirestoreHelper.updateFeed(
      position: geoPoint,
      userID: user.id,
      userName: user.name,
      imageID: imageID,
    );

    return result;
  }

  Future<void> saveImageToDocuments() async {
    if (image != null) {
      final appDir = await sys_path.getApplicationDocumentsDirectory();
      final fileName = path.basename(image!.path);
      image!.copy('${appDir.path}/$fileName');
    }
  }
}
