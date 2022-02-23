import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lucis/helpers/static_map_helper.dart';
import 'package:lucis/models/place.dart';
import 'package:lucis/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    Key? key,
    required this.onSelectLocation,
  }) : super(key: key);

  final Function(double latitude, double longitude) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double latitude, double longitude) {
    final staticMapURL = StaticMapHelper.getStaticMapURL(
      latitude: latitude,
      longitude: longitude,
    );
    setState(() {
      _previewImageUrl = staticMapURL;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final location = await Location().getLocation();
      if (location.latitude != null && location.longitude != null) {
        _showPreview(location.latitude!, location.longitude!);
        widget.onSelectLocation(
          location.latitude!,
          location.longitude!,
        );
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final location = await Location().getLocation();

    if (location.latitude != null && location.longitude != null) {
      final placeLocation = PlaceLocation(
        latitude: location.latitude!,
        longitude: location.longitude!,
      );
      final LatLng selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(
            initialLocation: placeLocation,
            isSelecting: true,
          ),
        ),
      );
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);
      widget.onSelectLocation(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          width: double.infinity,
          child: _previewImageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
