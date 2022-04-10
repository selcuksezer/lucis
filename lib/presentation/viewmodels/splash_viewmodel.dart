import 'package:lucis/domain/usecases/get_location_usecase.dart';
import 'package:lucis/domain/usecases/get_session_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/failure.dart';

class SplashViewModel extends BaseViewModel {
  final GetSessionUseCase _getSessionUseCase;
  final GetLocationUseCase _getLocationUseCase;
  late Session _session;

  SplashViewModel(
    this._getSessionUseCase,
    this._getLocationUseCase,
  );

  @override
  void init() {
    initSession();
  }

  Future<void> initSession() async {
    final sessionOrFailure =
        await _getSessionUseCase.execute(const GetSessionParams());
    sessionOrFailure.fold(
      (failure) => onFailure(failure),
      (session) async {
        _session = session;
        _session.location == null
            ? await _fetchLocation()
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

  bool isSessionError() {
    return status == Status.failure &&
            failure == Failure.sessionNotInitializedFailure
        ? true
        : false;
  }

  @override
  Future<void> handleFailure() async {
    switch (failure) {
      default:
        break;
    }
  }

  @override
  void failureToMessage() {
    switch (failure) {
      case Failure.sessionNotInitializedFailure:
        {
          updateMessage = Message(
              title: 'Session Error',
              description: 'Could not initialize the session.',
              showDialog: true,
              firstOption: 'OK');
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
