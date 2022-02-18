import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:lucis/models/place.dart';
import 'dart:io';

class FavoritePlaces with ChangeNotifier {
  final List<Place> _items = [];

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
    }
  }
}
