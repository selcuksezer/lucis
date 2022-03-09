import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucis/models/feed.dart';
import 'package:lucis/view_models/feed_view_model.dart';
import 'package:lucis/models/location.dart';
import 'package:lucis/widgets/feed_list_item.dart';

class FeedScreen extends StatefulWidget {
  static const route = 'feed-screen';

  const FeedScreen({
    Key? key,
    required this.userID,
    required this.location,
  }) : super(key: key);

  final String userID;
  final Location location;

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  _FeedScreenState() {}

  final PagingController<int, FeedItem> _pagingController =
      PagingController(firstPageKey: 0);

  late FeedViewModel feedViewModel;

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await feedViewModel.fetchFeedPage(pageKey);
      final isLastPage = newItems.length < FeedViewModel.size;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    feedViewModel = FeedViewModel(
      userID: widget.userID,
      location: widget.location,
    );
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(alignment: Alignment.topLeft, children: [
        PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) =>
                    FeedListItem(item: item))),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 30.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30.0,
              color: Colors.grey,
            ),
          ),
        ),
      ]),
    );
  }
}
