import 'package:flutter/foundation.dart';
import 'package:lucis/domain/failure.dart';

abstract class BaseViewModel with ChangeNotifier {
  void init();

  Status _status = Status.busy;
  Failure? _failure;
  Message _message = Message();

  Status get status => _status;
  Failure? get failure => _failure;
  Message get message => _message;

  void updateStatus(Status status) {
    if (_status != status) {
      _status = status;
      notifyListeners();
    }
  }

  set updateMessage(Message message) => _message = message;

  void onFailure(Failure failure) {
    _failure = failure;
    failureToMessage();
    handleFailure();
    updateStatus(Status.failure);
  }

  Future<void> handleFailure();

  void failureToMessage();

  @override
  @mustCallSuper
  void dispose() => super.dispose();
}

enum Status {
  ready,
  busy,
  failure,
}

class Message {
  String? description;
  String? title;
  String? firstOption;
  String? secondOption;
  bool? showDialog = false;

  Message({
    this.description,
    this.title,
    this.firstOption,
    this.secondOption,
    this.showDialog,
  });
}
