import 'dart:io';
import 'package:lucis/domain/usecases/get_camera_image_usecase.dart';
import 'package:lucis/domain/usecases/get_gallery_image_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/usecases/get_session_usecase.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/failure.dart';

class ImageImportViewModel extends BaseViewModel {
  final GetCameraImageUseCase _getCameraImageUseCase;
  final GetGalleryImageUseCase _getGalleryImageUseCase;
  final GetSessionUseCase _getSessionUseCase;
  late Session _session;

  ImageImportViewModel(
    this._getSessionUseCase,
    this._getCameraImageUseCase,
    this._getGalleryImageUseCase,
  );

  @override
  void init() {
    updateStatus(Status.ready);
  }

  Future<void> _fetchSession() async {
    final sessionOrFailure =
        await _getSessionUseCase.execute(const GetSessionParams());
    sessionOrFailure.fold(
      (failure) => onFailure(failure),
      (session) {
        _session = session;
        _session.location == null
            ? updateStatus(Status.failure)
            : updateStatus(Status.ready);
      },
    );
  }

  Future<File?> takePhoto() async {
    File? imageFile;
    final imageOrFailure =
        await _getCameraImageUseCase.execute(const GetCameraImageParams());
    imageOrFailure.fold(
      (failure) => onFailure(failure),
      (image) => imageFile = image,
    );
    return imageFile;
  }

  Future<File?> pickGalleryImage() async {
    File? imageFile;
    final imageOrFailure =
        await _getGalleryImageUseCase.execute(const GetGalleryImageParams());
    imageOrFailure.fold(
      (failure) => onFailure(failure),
      (image) => imageFile = image,
    );
    return imageFile;
  }

  @override
  Future<void> handleFailure() async {
    switch (failure) {
      case Failure.cameraNoPermissionFailure:
        {
          // TODO: prompt user to give camera access
          updateStatus(Status.ready);
        }
        break;
      case Failure.galleryNoPermissionFailure:
        {
          // TODO: prompt user to give camera access
          updateStatus(Status.ready);
        }
        break;
      default:
        break;
    }
  }
}
