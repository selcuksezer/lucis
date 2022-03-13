import 'package:flutter/material.dart';
import 'package:lucis/screens/home_screen.dart';
import 'package:lucis/screens/image_import_screen.dart';
import 'package:lucis/screens/image_upload_screen.dart';
import 'package:lucis/screens/login_screen.dart';
import 'package:lucis/screens/registration_screen.dart';
import 'package:lucis/screens/user_screen.dart';
import 'package:lucis/screens/welcome_screen.dart';
import 'package:lucis/view_models/image_view_model.dart';
import 'package:lucis/view_models/location_view_model.dart';
import 'package:lucis/view_models/user_view_model.dart';
import 'package:provider/provider.dart';
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
        Provider<ImageViewModel>(create: (_) => ImageViewModel()),
        Provider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<LocationViewModel>(
            create: (_) => LocationViewModel()),
      ],
      child: MaterialApp(
        home: WelcomeScreen(),
        // initialRoute: HomeScreen.route,
        routes: {
          WelcomeScreen.route: (context) => const WelcomeScreen(),
          LoginScreen.route: (context) => const LoginScreen(),
          RegistrationScreen.route: (context) => const RegistrationScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          ImageImportScreen.route: (context) => const ImageImportScreen(),
          ImageUploadScreen.route: (context) => const ImageUploadScreen(),
        },
        title: 'Lucis',
      ),
    );
  }
}
