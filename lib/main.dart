import 'package:flutter/material.dart';
import 'package:lucis/screens/places_list_screen.dart';

void main() => runApp(const Lucis());

class Lucis extends StatelessWidget {
  const Lucis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(primarySwatch: Colors.indigo);
    return MaterialApp(
      home: PlacesListScreen(),
      title: 'Lucis',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.amber,
        ),
      ),
    );
  }
}
