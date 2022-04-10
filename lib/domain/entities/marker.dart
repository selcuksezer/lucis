import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/utils/extensions/image_extension.dart';
import 'package:lucis/utils/constants.dart';

class ImageMarker {
  static const int size = kDefaultMarkerSize;
  final Feed feed;
  final MarkerId markerId;
  final LatLng position;
  final Image image;
  Image? avatar;

  final void Function(String markerId) onMarkerTap;

  ImageMarker({
    required this.feed,
    required this.markerId,
    required this.position,
    required this.image,
    required this.onMarkerTap,
    this.avatar,
  });

  Marker get photoMarker {
    return Marker(
      markerId: markerId,
      position: position,
      consumeTapEvents: true,
      onTap: () {
        onMarkerTap(markerId.value);
      },
      icon: image.toBitmapDescriptor(),
    );
  }

  Marker get avatarMarker {
    return Marker(
      markerId: markerId,
      position: position,
      consumeTapEvents: true,
      onTap: () {
        onMarkerTap(markerId.value);
      },
      icon: avatar == null
          ? BitmapDescriptor.defaultMarker
          : avatar!.toBitmapDescriptor(),
    );
  }

  Marker photoMarkerResized(int newSize) {
    return Marker(
      markerId: markerId,
      position: position,
      consumeTapEvents: true,
      onTap: () {
        onMarkerTap(markerId.value);
      },
      icon: image.toBitmapDescriptorResized(newSize),
    );
  }

  Marker avatarMarkerResized(int newSize) {
    return Marker(
      markerId: markerId,
      position: position,
      consumeTapEvents: true,
      onTap: () {
        onMarkerTap(markerId.value);
      },
      icon: avatar == null
          ? BitmapDescriptor.defaultMarker
          : avatar!.toBitmapDescriptorResized(newSize),
    );
  }
}
