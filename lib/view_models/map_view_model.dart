import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image/image.dart' as im;
import 'package:lucis/models/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucis/helpers/firebase_storage_helper.dart';
import 'package:lucis/widgets/avatar_marker.dart';

enum MarkerType {
  avatar,
  photo,
}

class MapViewModel {
  static const updateRange = 5.0; // km
  static const initialMarkerSize = 50.0;
  static const initialZoom = 16.0;

  MapViewModel(this._updateUI, {required this.location});

  Location location;
  final Function(Function()) _updateUI;
  late BuildContext context;
  late Stream<List<DocumentSnapshot>> stream;
  Map<MarkerId, Marker> imageMarkers = {};
  Map<MarkerId, Marker> avatarMarkers = {};
  Map<MarkerId, String> imageURLCache = {};
  Map<MarkerId, File?> avatarFileCache = {};
  MarkerType markerDisplayType = MarkerType.avatar;
  bool streamOn = false;
  late CameraPosition _lastCameraPosition;
  List<Marker> imageMarkerData = [];
  double markerSize = 30.0;
  double delZoomTemp = 0;

  void onMapCreated(GoogleMapController controller) {
    if (!streamOn) {
      streamOn = true;
      queryDataNearby();
      return;
    }
  }

  void onCameraMove(CameraPosition cameraPosition) {
    _lastCameraPosition = cameraPosition;
  }

  void onCameraIdle() {
    adjustMarkerSize(_lastCameraPosition.zoom);
    final dist = calculateDistance(
      location.geoLocation!.latitude,
      location.geoLocation!.longitude,
      _lastCameraPosition.target.latitude,
      _lastCameraPosition.target.longitude,
    );
    if (dist > updateRange) {
      location = Location.fromLatLng(_lastCameraPosition.target);
      queryDataNearby();
    }
  }

  void adjustMarkerSize(double newZoom) {
    final delZoom = (newZoom.clamp(13.5, 16.5) - initialZoom);
    if (delZoomTemp == delZoom) {
      return;
    }
    delZoomTemp = delZoom;
    markerSize = initialMarkerSize * pow(2, delZoom);
    _updateUI(() {
      updateMarkers();
    });
  }

  Future<void> queryDataNearby() async {
    final firestoreRef = FirebaseFirestore.instance.collection('feed');
    final geoRef = Geoflutterfire().collection(collectionRef: firestoreRef);
    if (location.geoLocation != null) {
      stream = geoRef.within(
          center: location.geoLocation!,
          radius: updateRange,
          field: 'position');
    } else {
      return;
    }
    stream.asyncMap((event) => _toMarker(event)).listen((event) {
      _updateUI(() {});
    });
  }

  void updateMarkers() {
    // imageMarkers.forEach((markerID, imageMarker) {
    //   imageMarker.child =
    //       AvatarMarker(radius: markerSize, url: imageURLCache[markerID]!);
    //
    //   if (avatarFileCache[markerID] != null) {
    //     avatarMarkers[markerID]!.child = CircleAvatar(
    //       backgroundImage: FileImage(avatarFileCache[markerID]!),
    //       maxRadius: markerSize,
    //     );
    //   } else {
    //     avatarMarkers[markerID]!.child = Icon(
    //       FontAwesomeIcons.solidUser,
    //       color: Colors.deepOrange,
    //       size: markerSize,
    //     );
    //   }
    // });
  }

  Set<Marker> getMarkers() {
    if (imageMarkers.isEmpty || avatarMarkers.isEmpty) {
      print('marker list empty');
      return {};
    } else {
      print(markerDisplayType);
      return markerDisplayType == MarkerType.photo
          ? imageMarkers.values.toSet()
          : avatarMarkers.values.toSet();
    }
  }

  int getMarkerTypeIndex() {
    return markerDisplayType == MarkerType.avatar ? 0 : 1;
  }

  void onMarkerTap(MarkerId markerID) {
    print('$markerID tapped');
    final imageFile = imageURLCache[markerID];
    if (imageFile != null) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Image.network(
              imageFile,
              width: double.infinity,
            );
          });
    }
  }

  Future<void> toggleMarkerType() async {
    markerDisplayType = markerDisplayType == MarkerType.avatar
        ? MarkerType.photo
        : MarkerType.avatar;
    _updateUI(() {});
  }

  Future<void> _toMarker(List<DocumentSnapshot<Object?>> docList) async {
    for (var doc in docList) {
      final imageURL = await FirebaseStorageHelper.downloadImageURL(
        userID: doc['userID'],
        imageID: doc['imageID'],
      );
      if (imageURL == null) {
        continue;
      }
      final avatarFile = await FirebaseStorageHelper.downloadAvatar(
        userID: doc['userID'],
      );

      final markerID = MarkerId('${doc['imageID']}');
      const url =
          'https://firebasestorage.googleapis.com/v0/b/lucis-flutter-f8748.appspot.com/o/lukas%2Flukas-1646774917476?alt=media&token=08c3977d-864b-4ee5-9280-37c7caab79c2';
      final data = await NetworkAssetBundle(Uri.parse(url)).load(url);
      final image = im.decodeImage(data.buffer.asUint8List());
      final circleImage = im.copyCropCircle(
          im.copyResize(image!, width: 200, height: 200),
          radius: 100);
      final encod = im.encodePng(circleImage);
      ////////////////
      final imageCustomMarker = Marker(
          consumeTapEvents: true,
          onTap: () {
            onMarkerTap(markerID);
          },
          markerId: markerID,
          position: LatLng(doc['position']['geopoint'].latitude,
              doc['position']['geopoint'].longitude),
          icon: BitmapDescriptor.fromBytes(Uint8List.fromList(encod)));

      imageMarkerData.add(imageCustomMarker);

      final avatarCustomMarker = Marker(
        consumeTapEvents: true,
        onTap: () {
          onMarkerTap(markerID);
        },
        markerId: markerID,
        position: LatLng(doc['position']['geopoint'].latitude,
            doc['position']['geopoint'].longitude),
      );

      imageMarkers.addAll({markerID: imageCustomMarker});
      avatarMarkers.addAll({markerID: avatarCustomMarker});
      imageURLCache.addAll({markerID: imageURL});
      avatarFileCache.addAll({markerID: avatarFile});
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
