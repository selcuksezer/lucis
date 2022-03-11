import 'package:flutter/material.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/screens/feed_screen.dart';
import 'package:lucis/screens/image_import_screen.dart';
import 'package:lucis/screens/map_screen.dart';
import 'package:lucis/view_models/location_view_model.dart';
import 'package:lucis/view_models/user_view_model.dart';
import 'package:lucis/widgets/vertical_icon_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const route = 'home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

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
                          onPressed: () async {
                            try {
                              final user = await userViewModel.getUser(
                                  'eric', 'cartman');
                              if (user == null) {
                                return;
                              }
                              if (locationViewModel.location.geoLocation ==
                                  null) {
                                print('starting');
                                await locationViewModel.retryUpdateLocation();
                                print('ended');
                              }
                            } catch (e) {
                              print(e);
                            }

                            if (userViewModel.user?.id != null &&
                                locationViewModel.location.geoLocation !=
                                    null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedScreen(
                                    userID: userViewModel.user!.id,
                                    location: locationViewModel.location,
                                  ),
                                ),
                              );
                            }
                          },
                          label: 'EXPLORE',
                        ),
                        VerticalIconButton(
                          icon: kMapIcon,
                          onPressed: () async {
                            try {
                              if (locationViewModel.location.geoLocation ==
                                  null) {
                                print('starting');
                                await locationViewModel.retryUpdateLocation();
                                print('ended');
                              }
                            } catch (e) {
                              print(e);
                            }
                            if (locationViewModel.location.geoLocation !=
                                null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                    initialLocation: locationViewModel.location,
                                  ),
                                ),
                              );
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
    );
  }
}
