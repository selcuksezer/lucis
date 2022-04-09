import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/feed_viewmodel.dart';
import 'package:lucis/presentation/components/feed_list_item.dart';

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
                itemBuilder: (context, item, index) => FeedListItem(
                  item: item,
                  onPinTap: viewModel.onPinTap,
                  onFavoriteTap: viewModel.onFavoriteTap,
                ),
                firstPageProgressIndicatorBuilder: (context) {
                  return const SpinKitCubeGrid(
                    color: Colors.black54,
                    size: 30.0,
                  );
                },
                newPageProgressIndicatorBuilder: (context) {
                  return const SpinKitCubeGrid(
                    color: Colors.black54,
                    size: 30.0,
                  );
                },
              )),
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
