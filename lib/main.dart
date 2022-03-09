import 'package:flutter/material.dart';

import 'package:lucis/screens/add_place_screen.dart';

import 'package:lucis/screens/home_screen.dart';
import 'package:lucis/screens/image_import_screen.dart';
import 'package:lucis/screens/image_upload_screen.dart';
import 'package:lucis/view_models/image_view_model.dart';
import 'package:lucis/view_models/location_view_model.dart';
import 'package:lucis/view_models/user_view_model.dart';

import 'package:provider/provider.dart';
import 'package:lucis/view_models/favorite_places.dart';
import 'screens/place_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Lucis());
}

class Lucis extends StatelessWidget {
  const Lucis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritePlaces>(create: (_) => FavoritePlaces()),
        Provider<ImageViewModel>(create: (_) => ImageViewModel()),
        Provider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<LocationViewModel>(
            create: (_) => LocationViewModel()),
      ],
      child: MaterialApp(
        initialRoute: HomeScreen.route,
        routes: {
          HomeScreen.route: (context) => const HomeScreen(),
          ImageImportScreen.route: (context) => const ImageImportScreen(),
          ImageUploadScreen.route: (context) => const ImageUploadScreen(),
          AddPlaceScreen.route: (context) => const AddPlaceScreen(),
          PlaceDetailScreen.route: (context) => const PlaceDetailScreen(),
        },
        title: 'Lucis',
      ),
    );
  }
}
