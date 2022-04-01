import 'package:lucis/domain/entities/user.dart';
import 'package:lucis/domain/entities/location.dart';

class Session {
  static final Session _session = Session._();
  User? user;
  Location? location;

  factory Session() {
    return _session;
  }

  Session._();

  void updateUser(User currentUser) => user = currentUser;
  void updateLocation(Location? currentLocation) => location = currentLocation;

  void resetSession() {
    user = null;
    location = null;
  }
}
