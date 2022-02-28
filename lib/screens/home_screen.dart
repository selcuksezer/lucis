import 'package:flutter/material.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/screens/image_import_screen.dart';
import 'package:lucis/widgets/vertical_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Navigator.of(context)
                                .pushNamed(ImageImportScreen.route);
                          },
                          label: 'NEW LUCIS',
                        ),
                        VerticalIconButton(
                          icon: kYouIcon,
                          onPressed: () {},
                          label: 'YOU',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VerticalIconButton(
                          icon: kExploreIcon,
                          onPressed: () {},
                          label: 'EXPLORE',
                        ),
                        VerticalIconButton(
                          icon: kMapIcon,
                          onPressed: () {},
                          label: 'MAP',
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
