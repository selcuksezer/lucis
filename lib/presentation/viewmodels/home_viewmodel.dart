import 'package:lucis/domain/usecases/get_location_usecase.dart';
import 'package:lucis/domain/usecases/get_session_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/failure.dart';

class HomeViewModel extends BaseViewModel {
  final GetSessionUseCase _getSessionUseCase;
  final GetLocationUseCase _getLocationUseCase;
  late Session _session;

  HomeViewModel(
    this._getSessionUseCase,
    this._getLocationUseCase,
  );

  @override
  void init() {
    _fetchSession();
  }

  get userId => _session.user?.id;
  get location => _session.location;

  Future<void> _fetchSession() async {
    updateStatus(Status.busy);
    final sessionOrFailure =
        await _getSessionUseCase.execute(const GetSessionParams());
    sessionOrFailure.fold(
      (failure) => onFailure(failure),
      (session) {
        _session = session;
        _session.location == null
            ? _fetchLocation()
            : updateStatus(Status.ready);
      },
    );
  }

  Future<void> _fetchLocation() async {
    final locationOrFailure =
        await _getLocationUseCase.execute(const GetLocationParams());
    locationOrFailure.fold(
      (failure) => onFailure(failure),
      (location) {
        _session.updateLocation(location);
        updateStatus(Status.ready);
      },
    );
  }

  @override
  Future<void> handleFailure() async {
    switch (failure) {
      case Failure.locationNoPermissionFailure:
        {
          // TODO: listen location permission/service availability
          await _fetchLocation();
        }
        break;
      case Failure.locationNoPermissionForeverFailure:
        {
          // TODO: listen location permission/service availability
          await _fetchLocation();
        }
        break;
      case Failure.locationNoServiceFailure:
        {
          // TODO: listen location permission/service availability
          await _fetchLocation();
        }
        break;
      default:
        break;
    }
  }

  @override
  void failureToMessage() {
    switch (failure) {
      case Failure.locationNoPermissionFailure:
        {
          updateMessage = Message(
              title: 'Location Error',
              description:
                  'Unable to get the location. Please give permission to location access.',
              showDialog: true,
              firstOption: 'OK');
        }
        break;
      case Failure.locationNoPermissionForeverFailure:
        {
          updateMessage = Message(
            title: 'Location Error',
            description:
                'Location permission is disabled forever. Please allow location use from settings.',
            showDialog: true,
            firstOption: 'OK',
          );
        }
        break;
      case Failure.locationNoServiceFailure:
        {
          updateMessage = Message(
            title: 'Location Error',
            description:
                'Unable to get the location. Please enable location services.',
            showDialog: true,
            firstOption: 'OK',
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
}
