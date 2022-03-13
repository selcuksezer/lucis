import 'package:flutter/material.dart';
import 'package:lucis/screens/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/view_models/session_view_model.dart';
import 'package:provider/provider.dart';
import '../view_models/image_view_model.dart';
import '../view_models/location_view_model.dart';
import '../view_models/user_view_model.dart';

class SplashScreen extends StatelessWidget {
  static const route = 'splash-screen';

  const SplashScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  Widget build(BuildContext context) {
    final SessionViewModel sessionVM = SessionViewModel();
    return FutureBuilder(
        future: sessionVM.runSessionTasks(userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                Provider<ImageViewModel>(create: (_) => ImageViewModel()),
                Provider<UserViewModel>(create: (_) => UserViewModel()),
                ChangeNotifierProvider<LocationViewModel>(
                    create: (_) => LocationViewModel()),
              ],
              child: HomeScreen(
                  user: sessionVM.user!, location: sessionVM.location!),
            );
          } else {
            return Container(
              color: Colors.white,
              constraints: const BoxConstraints.expand(),
              child: const Center(
                child: SpinKitDoubleBounce(
                  color: Colors.black54,
                ),
              ),
            );
          }
        });
  }
}
