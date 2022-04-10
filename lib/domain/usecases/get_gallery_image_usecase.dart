import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/repositories/image_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';

class GetGalleryImageUseCase
    implements BaseUseCase<File, GetGalleryImageParams> {
  final ImageRepository _imageRepository;

  GetGalleryImageUseCase(this._imageRepository);

  @override
  Future<Either<Failure, File>> execute(GetGalleryImageParams params) async {
    return await _imageRepository.getImageFromGallery();
  }
}

class GetGalleryImageParams extends Equatable {
  const GetGalleryImageParams();

  @override
  List<Object> get props => [];
}
