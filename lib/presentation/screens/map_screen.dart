import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/map_viewmodel.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucis/presentation/components/feed_list_item.dart';
import 'package:lucis/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<MapViewModel>(builder: (context, viewModel, child) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (viewModel.isTapped) {
          showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) =>
                      FeedListItem(item: viewModel.tappedMarkerFeed))
              .then((value) => viewModel.isTapped = false);
        }
      });
      return Scaffold(
        body: Stack(children: [
          if (viewModel.isInitialized())
            GoogleMap(
              onMapCreated: viewModel.onMapCreated,
              onCameraIdle: viewModel.onCameraIdle,
              onCameraMove: viewModel.onCameraMove,
              markers: viewModel.getMarkers(),
              mapType: MapType.satellite,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: viewModel.initialLocation,
                zoom: kMapDefaultZoom,
              ),
            ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ToggleSwitch(
                minWidth: 40.0,
                minHeight: 30.0,
                initialLabelIndex: viewModel.isAvatar ? 0 : 1,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                iconSize: 30.0,
                icons: const [
                  FontAwesomeIcons.users,
                  FontAwesomeIcons.solidImages
                ],
                activeBgColors: const [
                  [Colors.deepOrange],
                  [Colors.deepOrange]
                ],
                onToggle: (index) => viewModel.toggleMarkerType(index),
              ),
            ),
          ),
          SafeArea(
              child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )),
        ]),
      );
    });
  }
}
