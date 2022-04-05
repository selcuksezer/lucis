import 'package:lucis/domain/usecases/login_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/failure.dart';

class LoginViewModel extends BaseViewModel {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  @override
  void init() {
    updateStatus(Status.ready);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    updateStatus(Status.busy);
    final sessionOrFailure = await _loginUseCase.execute(LoginParams(
      email: email,
      password: password,
    ));
    sessionOrFailure.fold(
      (failure) => onFailure(failure),
      (session) => updateStatus(Status.ready),
    );
  }

  bool isEmailError() {
    return status == Status.failure && failure == Failure.mailInvalidFailure
        ? true
        : false;
  }

  bool isPasswordError() {
    return status == Status.failure &&
            failure == Failure.passwordIncorrectFailure
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
      case Failure.userNotFoundFailure:
        {
          updateMessage = Message(
            title: 'Login Error',
            description: 'User not found',
            showDialog: true,
            firstOption: 'OK',
          );
        }
        break;
      case Failure.passwordIncorrectFailure:
        {
          updateMessage = Message(
            description: 'wrong password',
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
      case Failure.userDisabledFailure:
        {
          updateMessage = Message(
            title: 'Login Error',
            description: 'user is disabled',
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
