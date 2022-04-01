class ServerException implements Exception {
  final String? msg;

  const ServerException([this.msg]);

  @override
  String toString() => msg ?? 'ServerException';
}

class ConnectionException implements Exception {
  final String? msg;

  const ConnectionException([this.msg]);

  @override
  String toString() => msg ?? 'ConnectionException';
}

class CacheException implements Exception {
  final String? msg;

  const CacheException([this.msg]);

  @override
  String toString() => msg ?? 'CacheException';
}

class BadRequestException implements Exception {
  final String? msg;

  const BadRequestException([this.msg]);

  @override
  String toString() => msg ?? 'BadRequestException';
}

class UnknownException implements Exception {
  final String? msg;

  const UnknownException([this.msg]);

  @override
  String toString() => msg ?? 'UnknownException';
}
