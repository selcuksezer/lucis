import 'package:flutter/material.dart';
import 'package:lucis/utils/constants.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/home_viewmodel.dart';
import 'package:lucis/presentation/components/vertical_icon_button.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/presentation/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<HomeViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(child: Image.asset(kHomeScreenLogoPath)),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VerticalIconButton(
                            icon: kCameraIcon,
                            onPressed: () {
                              if (viewModel.status == Status.ready) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.imageImportScreen,
                                );
                              } else if (viewModel.status == Status.failure) {
                                //TODO: show location dialog
                              }
                            },
                            label: 'NEW LUCIS',
                          ),
                          VerticalIconButton(
                            icon: kYouIcon,
                            onPressed: () {
                              if (viewModel.status == Status.ready) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.userScreen,
                                  arguments: viewModel.userId,
                                );
                              }
                            },
                            label: 'YOU',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VerticalIconButton(
                            icon: kExploreIcon,
                            onPressed: () {
                              if (viewModel.status == Status.ready) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.feedScreen,
                                );
                              } else if (viewModel.status == Status.failure) {
                                //TODO: show location dialog
                              }
                            },
                            label: 'EXPLORE',
                          ),
                          VerticalIconButton(
                            icon: kMapIcon,
                            onPressed: () {
                              if (viewModel.status == Status.ready) {
                                if (viewModel.location != null) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.mapScreen,
                                    arguments: viewModel.location!,
                                  );
                                }
                              } else if (viewModel.status == Status.failure) {
                                //TODO: show location dialog
                              }
                            },
                            label: 'MAP',
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
