import 'package:lucis/models/user.dart';

class UserViewModel {
  User? user;

  Future<void> fetchUserData(String id, String name) async {
    user = await User.getUser(userID: id, userName: name);
  }

  Future<User?> getUser(String id, String name) async {
    if (user == null) {
      await fetchUserData(id, name);
    }
    return user;
  }
}
