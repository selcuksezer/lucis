import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucis/domain/usecases/get_user_page_usecase.dart';
import 'package:lucis/domain/usecases/get_user_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/domain/entities/user.dart';

class UserViewModel extends BaseViewModel {
  final GetUserPageUseCase _getUserPageUseCase;
  final GetUserUseCase _getUserUseCase;

  User? _user;
  String? _id;
  String? pageToken;
  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0);

  UserViewModel(
    this._getUserPageUseCase,
    this._getUserUseCase,
  );

  get pagingController => _pagingController;
  get avatar => _user?.avatarUrl;
  get lucis => _user?.lucis;
  get name => _user?.name;
  get id => _id;

  @override
  void init() {}

  Future<void> fetchUserProfile(String id) async {
    _id = id;
    updateStatus(Status.busy);
    final userOrFailure = await _getUserUseCase.execute(GetUserParams(id));
    userOrFailure.fold(
      (failure) => onFailure(failure),
      (user) {
        _user = user;
        updateStatus(Status.ready);
        _pagingController.addPageRequestListener(_fetchUserPage);
        _pagingController.notifyListeners();
      },
    );
  }

  Future<void> _fetchUserPage(int pageKey) async {
    print('user fetch page called');
    final feedOrFailure = await _getUserPageUseCase.execute(GetUserPageParams(
      _id!,
      kUserPageSize,
      pageToken,
    ));
    feedOrFailure.fold(
      (failure) => onFailure(failure),
      (userPage) {
        print('user fetch page success');

        pageToken = userPage.keys.first;
        final newItems = userPage.values.first;
        final nextPageKey = newItems.isEmpty ? null : pageKey + 1;
        _pagingController.appendPage(
          newItems,
          nextPageKey,
        );
      },
    );
  }

  @override
  Future<void> handleFailure() async {
    switch (failure) {
      case Failure.connectionFailure:
        {
          _pagingController.error = message.description;
          //TODO: Listen for reconnection
          if (_id == null) return;
          await fetchUserProfile(_id!);
          if (status == Status.ready) {
            _pagingController.retryLastFailedRequest();
          }
        }
        break;
      default:
        {
          _pagingController.error = message.description;
        }
        break;
    }
  }

  @override
  void failureToMessage() {
    switch (failure) {
      case Failure.connectionFailure:
        {
          updateMessage = Message(
            title: 'Network Connection Error',
            description: 'Could not connect to the internet.',
            showDialog: false,
          );
        }
        break;
      default:
        {
          updateMessage = Message(
              title: 'Error',
              description: 'Something went wrong!',
              showDialog: true,
              firstOption: 'OK');
        }
        break;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
