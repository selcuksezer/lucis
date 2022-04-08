import 'package:flutter/material.dart';
import 'presentation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const Lucis());
}

class Lucis extends StatelessWidget {
  const Lucis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: Routes.welcomeScreen,
      onGenerateRoute: RouteGenerator.generateRoutes,
      title: 'Lucis',
    );
  }
}
