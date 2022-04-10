import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/domain/repositories/image_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucis/utils/constants.dart';

class ImageRepositoryImpl implements ImageRepository {
  @override
  Future<Either<Failure, File>> getImageFromCamera() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: kMaxImageImportHeight,
      );
      if (image == null) {
        return const Left(Failure.cameraNoPermissionFailure);
      }
      final File imageFile = File(image.path);
      return Right(imageFile);
    } on PlatformException {
      return const Left(Failure.cameraNoPermissionFailure);
    }
  }

  @override
  Future<Either<Failure, File>> getImageFromGallery() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: kMaxImageImportHeight,
      );
      if (image == null) {
        return const Left(Failure.galleryNoPermissionFailure);
      }
      final File imageFile = File(image.path);
      return Right(imageFile);
    } on PlatformException {
      return const Left(Failure.galleryNoPermissionFailure);
    }
  }
}
