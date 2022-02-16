import 'package:flutter/material.dart';
import 'package:lucis/widgets/rounded_popup_menu_button.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {}),
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
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
