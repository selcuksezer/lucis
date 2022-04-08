import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/splash_viewmodel.dart';
import 'package:lucis/presentation/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<SplashViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.status == Status.ready) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.pushNamed(
              context,
              Routes.homeScreen,
            );
          });
        } else if (viewModel.status == Status.failure) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }
        return Container(
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          child: const Center(
            child: SpinKitDoubleBounce(
              color: Colors.black54,
            ),
          ),
        );
      },
    );
  }
}
