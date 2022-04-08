import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/feed_viewmodel.dart';
import 'package:lucis/presentation/components/feed_list_item.dart';

import '../viewmodels/base_viewmodel.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<FeedViewModel>(
      builder: (context, viewModel, child) => Material(
        child: Stack(alignment: Alignment.topLeft, children: [
          PagedListView(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) =>
                      FeedListItem(item: item))),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 30.0,
            ),
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
      ),
    );
  }
}
