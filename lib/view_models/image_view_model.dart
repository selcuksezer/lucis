import 'package:lucis/models/image.dart';
import 'package:lucis/models/location.dart';
import 'package:lucis/models/user.dart';

class ImageViewModel {
  Image? image;

  Future<Image?> takePicture(String id) async {
    final cameraImage = await Image.imageFromCamera(id);
    if (cameraImage != null) {
      image = cameraImage;
    }
    return cameraImage;
  }

  Future<Image?> pickImageFromGallery(String id) async {
    final galleryImage = await Image.imageFromGallery(id);
    if (galleryImage != null) {
      image = galleryImage;
    }
    return galleryImage;
  }

  Future<bool> uploadImage(User user, Location location) async {
    if (location.geoLocation == null) {
      await location.updateLocation();
    }
    final result =
        await image?.uploadImageToFirebase(user: user, location: location) ??
            false;
    return result;
  }

  Future<void> saveImage() async {}
}

//   Future<void> addPlace(
//       String pickedTitle,
//       File? pickedImage,
//       PlaceLocation pickedLocation,
//       ) async {
//     final address = await StaticMapHelper.getLocationAddress(
//       latitude: pickedLocation.latitude,
//       longitude: pickedLocation.longitude,
//     );
//     final updatedLocation = PlaceLocation(
//       latitude: pickedLocation.latitude,
//       longitude: pickedLocation.longitude,
//       address: address,
//     );
//
//     if (pickedImage != null) {
//       final newPlace = Place(
//           id: DateTime.now().toString(),
//           image: pickedImage,
//           title: pickedTitle,
//           location: updatedLocation);
//       _items.add(newPlace);
//       notifyListeners();
//       DBHelper.insert(
//         'user_places',
//         {
//           'id': newPlace.id,
//           'title': newPlace.title,
//           'image': newPlace.image.path,
//           'loc_lat': newPlace.location?.latitude,
//           'loc_lng': newPlace.location?.longitude,
//           'address': newPlace.location?.address,
//         },
//       );
//     }
//   }
//
//   Future<void> fetchSetPlaces() async {
//     final dataList = await DBHelper.getData('user_places');
//     _items = dataList
//         .map(
//           (item) => Place(
//         id: item['id'],
//         title: item['title'],
//         image: File(item['image']),
//         location: PlaceLocation(
//           latitude: item['loc_lat'],
//           longitude: item['loc_lng'],
//           address: item['address'],
//         ),
//       ),
//     )
//         .toList();
// }
//
