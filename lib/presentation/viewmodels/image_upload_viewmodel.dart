import 'dart:io';
import 'package:lucis/domain/usecases/upload_avatar_usecase.dart';
import 'package:lucis/domain/usecases/upload_feed_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/usecases/get_session_usecase.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/failure.dart';

class ImageUploadViewModel extends BaseViewModel {
  final UploadFeedUseCase _uploadFeedUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final GetSessionUseCase _getSessionUseCase;

  late Session _session;

  ImageUploadViewModel(
    this._uploadFeedUseCase,
    this._uploadAvatarUseCase,
    this._getSessionUseCase,
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
        updateStatus(Status.ready);
      },
    );
  }

  Future<void> uploadImage(File image) async {
    updateStatus(Status.busy);
    final successOrFailure = await _uploadFeedUseCase.execute(UploadFeedParams(
      image,
      _session,
    ));
    successOrFailure.fold(
      (failure) => onFailure(failure),
      (success) => updateStatus(Status.ready),
    );
  }

  Future<void> uploadAvatar(File avatar) async {
    updateStatus(Status.busy);
    final successOrFailure =
        await _uploadAvatarUseCase.execute(UploadAvatarParams(
      _session.user!.id,
      avatar,
    ));
    successOrFailure.fold(
      (failure) => onFailure(failure),
      (_) => updateStatus(Status.ready),
    );
  }

  @override
  Future<void> handleFailure() async {
    switch (failure) {
      case Failure.connectionFailure:
        {
          // TODO: listen and wait until connection is back on
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
