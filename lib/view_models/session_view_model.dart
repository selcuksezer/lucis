import 'package:lucis/models/location.dart';
import 'package:lucis/models/user.dart';

class SessionViewModel {
  SessionViewModel();

  User? user;
  Location? location;

  Future<void> runSessionTasks(String userID) async {
    user = await User.getExistingUser(userID: userID);
    location = Location.fromLocationService();
    while (location?.geoLocation == null) {
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }
}
