import 'package:flutter/material.dart';
import 'package:lucis/widgets/rounded_popup_menu_button.dart';
import 'package:lucis/screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import 'package:lucis/providers/favorite_places.dart';

class FavoritePlacesScreen extends StatelessWidget {
  const FavoritePlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AddPlaceScreen.route);
          }),
      appBar: AppBar(
        title: const Text('Favorite Places'),
        actions: [
          RoundedPopupMenuButton(
            menuItems: [
              MenuItem(textData: 'Share', iconData: Icons.share, onTap: () {}),
              MenuItem(textData: 'Sort', iconData: Icons.sort, onTap: () {}),
            ],
          ),
        ],
      ),
      body: Consumer<FavoritePlaces>(
        builder: (context, favoritePlaces, child) =>
            favoritePlaces.items.isEmpty
                ? child!
                : ListView.builder(
                    itemCount: favoritePlaces.items.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            FileImage(favoritePlaces.items[index].image),
                      ),
                      title: Text(favoritePlaces.items[index].title),
                      onTap: () {},
                    ),
                  ),
        child: const Center(
          child: Text('No places yet, start adding some!'),
        ),
      ),
    );
  }
}
