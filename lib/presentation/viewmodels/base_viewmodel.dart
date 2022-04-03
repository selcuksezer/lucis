import 'package:flutter/foundation.dart';
import 'package:lucis/domain/failure.dart';

abstract class BaseViewModel with ChangeNotifier {
  void init();

  Status _status = Status.busy;
  Failure? _failure;
  Status get status => _status;
  Failure? get failure => _failure;

  void updateStatus(Status status) {
    if (_status != status) {
      _status = status;
      notifyListeners();
    }
  }

  void onFailure(Failure failure) {
    handleFailure(failure);
    failure = failure;
    updateStatus(Status.failure);
  }

  Future<void> handleFailure(Failure failure);

  @override
  @mustCallSuper
  void dispose() => super.dispose();
}

enum Status {
  ready,
  busy,
  failure,
}
