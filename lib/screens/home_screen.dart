import 'package:flutter/material.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/screens/feed_screen.dart';
import 'package:lucis/screens/image_import_screen.dart';
import 'package:lucis/screens/map_screen.dart';
import 'package:lucis/screens/user_screen.dart';
import 'package:lucis/view_models/location_view_model.dart';
import 'package:lucis/view_models/user_view_model.dart';
import 'package:lucis/widgets/vertical_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:lucis/models/location.dart';
import 'package:lucis/models/user.dart';

class HomeScreen extends StatelessWidget {
  static const route = 'home-screen';

  const HomeScreen({Key? key, required this.user, required this.location})
      : super(key: key);

  final User user;
  final Location location;

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
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserScreen(
                                  userID: user.id,
                                ),
                              ),
                            );
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
                          onPressed: () async {
                            // try {
                            //   final user = await userViewModel.getUser('eric');
                            //   if (user == null) {
                            //     return;
                            //   }
                            //   if (locationViewModel.location.geoLocation ==
                            //       null) {
                            //     print('starting');
                            //     await locationViewModel.retryUpdateLocation();
                            //     print('ended');
                            //   }
                            // } catch (e) {
                            //   print(e);
                            // }

                            if (location.geoLocation != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedScreen(
                                    userID: user.id,
                                    location: location,
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
                            // try {
                            //   if (locationViewModel.location.geoLocation ==
                            //       null) {
                            //     print('starting');
                            //     await locationViewModel.retryUpdateLocation();
                            //     print('ended');
                            //   }
                            // } catch (e) {
                            //   print(e);
                            // }
                            if (location.geoLocation != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                    initialLocation: location,
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
