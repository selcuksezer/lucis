import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/splash_viewmodel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<SplashViewModel>(
      builder: (context, viewModel, child) => FutureBuilder(
        future: viewModel.initSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (viewModel.status == Status.ready) {
              Navigator.pushNamed(context, '/home');
            } else if (viewModel.status == Status.failure) {
              Navigator.pop(context);
            }
            return Container(
              color: Colors.white,
              constraints: const BoxConstraints.expand(),
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
        },
      ),
    );
  }
}
