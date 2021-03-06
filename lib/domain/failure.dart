enum Failure {
  // general
  badRequestFailure,
  serverFailure,
  connectionFailure,
  cacheFailure,
  // location
  locationNoPermissionFailure,
  locationNoPermissionForeverFailure,
  locationNoServiceFailure,
  locationNotRetrieved,
  // image
  galleryNoPermissionFailure,
  cameraNoPermissionFailure,
  unknownFailure,
  // authentication
  passwordIncorrectFailure,
  userNotFoundFailure,
  userAlreadyExistsFailure,
  userDisabledFailure,
  mailNotFoundFailure,
  mailAlreadyExistsFailure,
  mailInvalidFailure,
  weakPasswordFailure,
  // session
  sessionNotInitializedFailure,
}
