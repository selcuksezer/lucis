import 'package:flutter/material.dart';
import 'package:lucis/screens/favorite_places_screen.dart';
import 'package:lucis/screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import 'package:lucis/providers/favorite_places.dart';
import 'screens/place_detail_screen.dart';

void main() => runApp(const Lucis());

class Lucis extends StatelessWidget {
  const Lucis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(primarySwatch: Colors.indigo);
    return ChangeNotifierProvider(
      create: (_) => FavoritePlaces(),
      child: MaterialApp(
        home: const FavoritePlacesScreen(),
        routes: {
          AddPlaceScreen.route: (context) => const AddPlaceScreen(),
          PlaceDetailScreen.route: (context) => const PlaceDetailScreen(),
        },
        title: 'Lucis',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.amber,
          ),
        ),
      ),
    );
  }
}
