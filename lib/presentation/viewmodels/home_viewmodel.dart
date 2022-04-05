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

  Future<void> _fetchSession() async {
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
      case Failure.locationNotRetrieved:
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
  String failureToMessage();
}
