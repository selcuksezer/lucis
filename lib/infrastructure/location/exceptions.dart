class LocationNotRetrievedException implements Exception {
  final String? msg;

  const LocationNotRetrievedException([this.msg]);

  @override
  String toString() => msg ?? 'locationNotRetrievedException';
}
