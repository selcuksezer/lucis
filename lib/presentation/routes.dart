import 'package:flutter/material.dart';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/presentation/screens/feed_screen.dart';
import 'package:lucis/presentation/screens/login_screen.dart';
import 'package:lucis/presentation/screens/registration_screen.dart';
import 'package:lucis/presentation/screens/user_screen.dart';
import 'package:lucis/presentation/screens/map_screen.dart';
import 'package:lucis/presentation/screens/image_import_screen.dart';
import 'package:lucis/presentation/screens/image_upload_screen.dart';
import 'package:lucis/presentation/screens/home_screen.dart';
import 'package:lucis/presentation/screens/splash_screen.dart';
import 'package:lucis/presentation/screens/welcome_screen.dart';

class Routes {
  static const welcomeScreen = '/';
  static const loginScreen = '/login';
  static const registrationScreen = '/registration';
  static const splashScreen = '/splash';
  static const homeScreen = '/home';
  static const imageImportScreen = '/image-import';
  static const imageUploadScreen = '/image-upload';
  static const feedScreen = '/feed';
  static const userScreen = '/user';
  static const mapScreen = '/map';
}

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcomeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WelcomeScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case Routes.registrationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegistrationScreen(),
        );
      case Routes.splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case Routes.imageImportScreen:
        var isAvatar = settings.arguments as bool?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ImageImportScreen(isAvatar: isAvatar),
        );
      case Routes.imageUploadScreen:
        var imageUploadArgs = settings.arguments as ImageUploadArgs;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ImageUploadScreen(imageUploadArgs),
        );
      case Routes.feedScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FeedScreen(),
        );
      case Routes.userScreen:
        var id = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => UserScreen(userId: id),
        );
      case Routes.mapScreen:
        var initLoc = settings.arguments as Location;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MapScreen(
            initialLocation: initLoc,
          ),
        );
      default:
        return invalidRoute();
    }
  }

  static Route<dynamic> invalidRoute() {
    return MaterialPageRoute(
      builder: (ctx) => const Scaffold(
        body: Center(
          child: Text("This route is not valid!"),
        ),
      ),
    );
  }
}
