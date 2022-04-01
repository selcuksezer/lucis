import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lucis/domain/failure.dart';

abstract class ImageRepository {
  Future<Either<Failure, File>> getImageFromCamera();
  Future<Either<Failure, File>> getImageFromGallery();
}
