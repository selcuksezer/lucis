import 'dart:math';
import 'package:lucis/domain/entities/location.dart';
import 'package:lucis/utils/calculate_distance.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/marker.dart';
import 'package:lucis/domain/usecases/get_markers_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/utils/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucis/domain/usecases/get_session_usecase.dart';
import 'package:lucis/domain/usecases/new_favorite_usecase.dart';
import 'package:lucis/domain/usecases/new_pin_usecase.dart';

class MapViewModel extends BaseViewModel {
  final GetMarkerUseCase _getMarkerUseCase;
  final GetSessionUseCase _getSessionUseCase;
  final NewFavoriteUseCase _newFavoriteUseCase;
  final NewPinUseCase _newPinUseCase;

  final _markers = <ImageMarker>{};
  late final GoogleMapController _mapController;
  bool isAvatar = true;
  Location? _initialLocation;
  Location? _lastQueriedLocation;
  int _markerSize = ImageMarker.size;
  bool isTapped = false;
  CameraPosition? _lastCameraPosition;
  Feed? tappedMarkerFeed;

  MapViewModel(
    this._getMarkerUseCase,
    this._getSessionUseCase,
    this._newFavoriteUseCase,
    this._newPinUseCase,
  );

  @override
  void init() {
    _fetchSession();
  }

  set initialLocation(Location location) {
    _initialLocation = location;
  }

  get isReady => status == Status.ready;

  Set<Marker> getMarkers() {
    final markerSet = _markers.map((imageMarker) {
      return isAvatar
          ? imageMarker.avatarMarkerResized(_markerSize)
          : imageMarker.photoMarkerResized(_markerSize);
    }).toSet();
    return markerSet;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onCameraMove(CameraPosition cameraPosition) {
    _lastCameraPosition = cameraPosition;
  }

  void onCameraIdle() {
    if (_lastQueriedLocation == null || _lastCameraPosition == null) {
      return;
    }
    _markerSize = _getMarkerSize();
    notifyListeners();
    final dist = calculateDistance(
      _lastQueriedLocation!.geoFirePoint.latitude,
      _lastQueriedLocation!.geoFirePoint.longitude,
      _lastCameraPosition!.target.latitude,
      _lastCameraPosition!.target.longitude,
    );
    if (dist > kMapUpdateRange) {
      _lastQueriedLocation = Location(GeoFirePoint(
        _lastCameraPosition!.target.latitude,
        _lastCameraPosition!.target.longitude,
      ));
      _fetchMarkers(_lastQueriedLocation!.geoFirePoint);
    }
  }

  void onPinTap(String id) {
    if (tappedMarkerFeed == null) {
      return;
    }
    if (tappedMarkerFeed!.isPin) {
      tappedMarkerFeed!.isPin = false;
      _newPinUseCase.execute(NewPinParams(
        tappedMarkerFeed!.userId,
        tappedMarkerFeed!.imageId,
        tappedMarkerFeed!.location,
        -1,
      ));
    } else {
      tappedMarkerFeed!.isPin = true;
      _newPinUseCase.execute(NewPinParams(
        tappedMarkerFeed!.userId,
        tappedMarkerFeed!.imageId,
        tappedMarkerFeed!.location,
        1,
      ));
    }
    notifyListeners();
  }

  void onFavoriteTap(String id) {
    if (tappedMarkerFeed == null) {
      return;
    }
    if (tappedMarkerFeed!.isFavorite) {
      tappedMarkerFeed!.isFavorite = false;
      _newFavoriteUseCase.execute(NewFavoriteParams(
        tappedMarkerFeed!.userId,
        tappedMarkerFeed!.imageId,
        -1,
      ));
    } else {
      tappedMarkerFeed!.isFavorite = true;
      _newFavoriteUseCase.execute(NewFavoriteParams(
        tappedMarkerFeed!.userId,
        tappedMarkerFeed!.imageId,
        1,
      ));
    }
    notifyListeners();
  }

  int _getMarkerSize() {
    if (_lastCameraPosition == null) {
      return ImageMarker.size;
    } else {
      final zoomDiff =
          (_lastCameraPosition!.zoom.clamp(13.5, 16.5) - kMapDefaultZoom);

      return (ImageMarker.size * pow(2, zoomDiff)).round();
    }
  }

  void toggleMarkerType(int? index) {
    isAvatar = index == 0 ? true : false;
    notifyListeners();
  }

  Future<void> _fetchSession() async {
    final sessionOrFailure =
        await _getSessionUseCase.execute(const GetSessionParams());
    sessionOrFailure.fold(
      (failure) => onFailure(failure),
      (session) {
        _lastQueriedLocation = session.location;
        _fetchMarkers(_initialLocation!.geoFirePoint);
      },
    );
  }

  Future<void> _fetchMarkers(GeoFirePoint center) async {
    updateStatus(Status.busy);
    final markerStreamOrFailure =
        await _getMarkerUseCase.execute(GetMarkerParams(
      center,
      kMapUpdateRange,
      _onMarkerTap,
    ));
    markerStreamOrFailure.fold(
      (failure) => onFailure(failure),
      (markerStream) => markerStream.listen(_addMarkers),
    );
  }

  void _addMarkers(List<ImageMarker> imageMarkers) {
    _markers.addAll(imageMarkers);
    updateStatus(Status.ready);
  }

  void _onMarkerTap(String id) {
    tappedMarkerFeed =
        _markers.firstWhere((marker) => marker.markerId.value == id).feed;
    isTapped = true;
    notifyListeners();
  }

  @override
  Future<void> handleFailure() async {
    switch (failure) {
      case Failure.connectionFailure:
        {
          //TODO: Listen for reconnection
          if (_initialLocation != null) {
            await _fetchMarkers(_initialLocation!.geoFirePoint);
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  void failureToMessage() {
    switch (failure) {
      case Failure.connectionFailure:
        {
          updateMessage = Message(
            title: 'Network Connection Error',
            description: 'Could not connect to the internet.',
            showDialog: false,
          );
        }
        break;
      default:
        {
          updateMessage = Message(
              title: 'Error',
              description: 'Something went wrong!',
              showDialog: true,
              firstOption: 'OK');
        }
        break;
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
