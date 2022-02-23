import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucis/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.initialLocation,
    this.isSelecting = false,
  }) : super(key: key);

  final PlaceLocation initialLocation;
  final bool isSelecting;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: _pickedLocation != null
                  ? () {
                      Navigator.of(context).pop(_pickedLocation);
                    }
                  : null,
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: _pickedLocation != null
            ? {
                Marker(
                  markerId: const MarkerId('pickedLoc'),
                  position: _pickedLocation!,
                ),
              }
            : {},
      ),
    );
  }
}
