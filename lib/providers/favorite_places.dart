import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:lucis/models/place.dart';

class FavoritePlaces with ChangeNotifier {
  List<Place> _items = [];

  UnmodifiableListView<Place> get items {
    return UnmodifiableListView(_items);
  }
}
