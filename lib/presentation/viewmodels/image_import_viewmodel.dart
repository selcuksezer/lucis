import 'dart:io';
import 'package:lucis/domain/usecases/get_camera_image_usecase.dart';
import 'package:lucis/domain/usecases/get_gallery_image_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/failure.dart';

class ImageImportViewModel extends BaseViewModel {
  final GetCameraImageUseCase _getCameraImageUseCase;
  final GetGalleryImageUseCase _getGalleryImageUseCase;

  ImageImportViewModel(
    this._getCameraImageUseCase,
    this._getGalleryImageUseCase,
  );

  @override
  void init() {
    updateStatus(Status.ready);
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
      default:
        break;
    }
  }

  @override
  void failureToMessage() {
    switch (failure) {
      case Failure.cameraNoPermissionFailure:
        {
          updateMessage = Message(
              title: 'Camera Error',
              description:
                  'Cannot access to the camera. Please give access permission.',
              showDialog: true,
              firstOption: 'OK');
        }
        break;
      case Failure.galleryNoPermissionFailure:
        {
          updateMessage = Message(
            title: 'Gallery Error',
            description:
                'Cannot access to the gallery. Please give access permission.',
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
