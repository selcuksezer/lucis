import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucis/models/location.dart';
import 'package:lucis/view_models/map_view_model.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.initialLocation,
  }) : super(key: key);

  final Location initialLocation;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapViewModel _mapVM;
  @override
  void initState() {
    print('initState called');
    _mapVM = MapViewModel(setState, location: widget.initialLocation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mapVM.context = context;
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _mapVM.onMapCreated,
          onCameraIdle: _mapVM.onCameraIdle,
          onCameraMove: _mapVM.onCameraMove,
          markers: _mapVM.getMarkers(),
          mapType: MapType.satellite,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocation.geoLocation!.latitude,
                widget.initialLocation.geoLocation!.longitude),
            zoom: 16,
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ToggleSwitch(
              minWidth: 40.0,
              minHeight: 30.0,
              initialLabelIndex: _mapVM.getMarkerTypeIndex(),
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
              onToggle: (index) async {
                _mapVM.toggleMarkerType();
              },
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
  }
}
