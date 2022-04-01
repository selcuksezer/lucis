import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/repositories/image_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetCameraImageUseCase implements BaseUseCase<File, Params> {
  final ImageRepository _imageRepository;

  GetCameraImageUseCase(this._imageRepository);

  @override
  Future<Either<Failure, File>> execute(Params params) async {
    return await _imageRepository.getImageFromGallery();
  }
}

class Params extends Equatable {
  const Params();

  @override
  List<Object> get props => [];
}
