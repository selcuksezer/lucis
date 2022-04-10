import 'package:lucis/domain/usecases/register_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/failure.dart';

class RegistrationViewModel extends BaseViewModel {
  final RegisterUseCase _registerUseCase;

  RegistrationViewModel(this._registerUseCase);

  @override
  void init() {
    updateStatus(Status.ready);
  }

  Future<void> register({
    required String userId,
    required String userName,
    required String email,
    required String password,
  }) async {
    updateStatus(Status.busy);
    final sessionOrFailure = await _registerUseCase.execute(RegisterParams(
      userId: userId,
      userName: userName,
      email: email,
      password: password,
    ));
    sessionOrFailure.fold(
      (failure) => onFailure(failure),
      (session) => updateStatus(Status.ready),
    );
  }

  bool isEmailError() {
    return status == Status.failure &&
            (failure == Failure.mailInvalidFailure ||
                failure == Failure.mailAlreadyExistsFailure)
        ? true
        : false;
  }

  bool isPasswordError() {
    return status == Status.failure && failure == Failure.weakPasswordFailure
        ? true
        : false;
  }

  bool isUserError() {
    return status == Status.failure &&
            failure == Failure.userAlreadyExistsFailure
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
      case Failure.connectionFailure:
        {
          updateMessage = Message(
              title: 'Network Connection Error',
              description: 'Could not connect to the internet.',
              showDialog: true,
              firstOption: 'OK');
        }
        break;
      case Failure.userAlreadyExistsFailure:
        {
          updateMessage = Message(
            description: 'user exists',
            showDialog: false,
          );
        }
        break;
      case Failure.mailAlreadyExistsFailure:
        {
          updateMessage = Message(
            description: 'email exists',
            showDialog: false,
          );
        }
        break;
      case Failure.mailInvalidFailure:
        {
          updateMessage = Message(
            description: 'invalid email',
            showDialog: false,
          );
        }
        break;
      case Failure.weakPasswordFailure:
        {
          updateMessage = Message(
            description: 'weak password',
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
}
