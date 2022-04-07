import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucis/domain/entities/feed_stream.dart';
import 'package:lucis/domain/usecases/get_feed_usecase.dart';
import 'package:lucis/domain/usecases/get_session_usecase.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/domain/entities/session.dart';
import 'package:lucis/domain/failure.dart';
import 'package:lucis/constants.dart';
import 'package:lucis/domain/entities/feed.dart';

class FeedViewModel extends BaseViewModel {
  final GetSessionUseCase _getSessionUseCase;
  final GetFeedUseCase _getFeedUseCase;

  late Session _session;
  late FeedStream _feed;
  final _feedList = <Feed>[];
  final PagingController<int, Feed> _pagingController =
      PagingController(firstPageKey: 0);

  FeedViewModel(
    this._getSessionUseCase,
    this._getFeedUseCase,
  );

  get pagingController => _pagingController;

  @override
  void init() {
    _fetchSession();
  }

  Future<void> _fetchSession() async {
    updateStatus(Status.busy);
    final sessionOrFailure =
        await _getSessionUseCase.execute(const GetSessionParams());
    sessionOrFailure.fold(
      (failure) => onFailure(failure),
      (session) {
        _session = session;
        _fetchFeedWithin();
      },
    );
  }

  Future<void> _fetchFeedWithin() async {
    if (_session.location == null) return;
    final feedOrFailure = await _getFeedUseCase.execute(
      GetFeedParams(
        _session.location!.geoFirePoint,
        radius: kDefaultFeedRadius,
      ),
    );
    feedOrFailure.fold(
      (failure) => onFailure(failure),
      (feed) {
        updateStatus(Status.busy);
        _feed = feed;
        _feed.feedStream.listen(_addNewFeedItems);
      },
    );
  }

  void _addNewFeedItems(List<Feed> feedItems) {
    if (feedItems.isEmpty) {
      updateStatus(Status.ready);
      return;
    } else {
      _feedList.addAll(feedItems);
      _pagingController.addPageRequestListener(_fetchFeedPage);
      updateStatus(Status.ready);
    }
  }

  void _fetchFeedPage(int pageKey) {
    if (status == Status.ready) {
      final startIdx = kFeedPageSize * pageKey;
      final nextStartIdx = startIdx + kFeedPageSize;
      final endIdx = _feedList.length > nextStartIdx ? nextStartIdx : null;
      final newItems = startIdx > _feedList.length
          ? <Feed>[]
          : _feedList.sublist(
              startIdx,
              endIdx,
            );
      final nextPageKey = endIdx == null ? null : pageKey + 1;
      _pagingController.appendPage(newItems, nextPageKey);
    }
  }

  @override
  Future<void> handleFailure() async {
    switch (failure) {
      case Failure.connectionFailure:
        {
          _pagingController.error = message.description;
          //TODO: Listen for reconnection
          await _fetchFeedWithin();
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
