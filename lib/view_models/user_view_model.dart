import 'dart:async';

import 'package:lucis/helpers/firebase_storage_helper.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucis/models/user.dart';
import 'package:lucis/models/image.dart';
import 'dart:io';

class UserViewModel {
  UserViewModel() {
    pagingController.addPageRequestListener(_fetchNextPage);
  }

  static const pageSize = 3;

  User? user;
  List<File> images = [];
  File? avatar;
  final PagingController<int, File> pagingController =
      PagingController(firstPageKey: 0);
  String? pageToken;
  Function(Function())? updateUI;
  bool? userDataFetchDone;

  Future<void> fetchUserData(String id) async {
    user = await User.getExistingUser(userID: id);
  }

  Future<User?> getUser(String id) async {
    if (user == null) {
      await fetchUserData(id);
    }
    userDataFetchDone = true;
    return user;
  }

  Future<void> _fetchNextPage(int pageKey) async {
    if (user == null) {
      while (userDataFetchDone != true) {
        await Future.delayed(Duration(milliseconds: 20));
      }
    }
    if (user == null) {
      return;
    }
    try {
      print('trying to fetch images...');
      final filesPage = await FirebaseStorageHelper.downloadImageFilesPaginated(
          userID: user!.id, limit: pageSize, pageToken: pageToken);
      pageToken = filesPage.keys.first;
      final newItems = filesPage.values.first;

      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error);
      pagingController.error = error;
    }
  }

  void dispose() {
    pagingController.dispose();
  }

  Future<File?> getUserAvatarFile(String id) async {
    avatar = await FirebaseStorageHelper.downloadAvatar(userID: id);
    updateUI!(() {});
    return avatar;
  }
}
