import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:lucis/models/place.dart';
import 'dart:io';
import 'package:lucis/helpers/db_helper.dart';
import 'package:lucis/helpers/static_map_helper.dart';

class FavoritePlaces with ChangeNotifier {
  List<Place> _items = [];

  UnmodifiableListView<Place> get items {
    return UnmodifiableListView(_items);
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File? pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await StaticMapHelper.getLocationAddress(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
    );
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );

    if (pickedImage != null) {
      final newPlace = Place(
          id: DateTime.now().toString(),
          image: pickedImage,
          title: pickedTitle,
          location: updatedLocation);
      _items.add(newPlace);
      notifyListeners();
      DBHelper.insert(
        'user_places',
        {
          'id': newPlace.id,
          'title': newPlace.title,
          'image': newPlace.image.path,
          'loc_lat': newPlace.location?.latitude,
          'loc_lng': newPlace.location?.longitude,
          'address': newPlace.location?.address,
        },
      );
    }
  }

  Future<void> fetchSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
