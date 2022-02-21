import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:lucis/models/place.dart';
import 'dart:io';
import 'package:lucis/helpers/db_helper.dart';

class FavoritePlaces with ChangeNotifier {
  List<Place> _items = [];

  UnmodifiableListView<Place> get items {
    return UnmodifiableListView(_items);
  }

  void addPlace(String pickedTitle, File? pickedImage) {
    if (pickedImage != null) {
      final newPlace = Place(
          id: DateTime.now().toString(),
          image: pickedImage,
          title: pickedTitle,
          location: null);
      _items.add(newPlace);
      notifyListeners();
      DBHelper.insert(
        'user_places',
        {
          'id': newPlace.id,
          'title': newPlace.title,
          'image': newPlace.image.path,
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
          ),
        )
        .toList();
    notifyListeners();
  }
}
