import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/domain/entities/session.dart';

class UploadAvatarUseCase implements BaseUseCase<String, UploadAvatarParams> {
  final UserRepository _userRepository;
  final Session _session;

  UploadAvatarUseCase(
    this._userRepository,
    this._session,
  );

  @override
  Future<Either<Failure, String>> execute(UploadAvatarParams params) async {
    final urlOrFailure = await _userRepository.updateUserAvatar(
      params.id,
      params.avatar,
    );
    urlOrFailure.fold(
        (failure) => Left(failure), (url) => _session.user!.avatarUrl = url);
    return urlOrFailure;
  }
}

class UploadAvatarParams extends Equatable {
  final String id;
  final File avatar;

  const UploadAvatarParams(
    this.id,
    this.avatar,
  );

  @override
  List<Object> get props => [
        id,
        avatar,
      ];
}
