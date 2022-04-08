import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/user_viewmodel.dart';
import 'package:lucis/presentation/components/image_grid_item.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<UserViewModel>(builder: (context, viewModel, child) {
      if (viewModel.id == null) {
        viewModel.fetchUserProfile(widget.userId);
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 25.0,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                viewModel.avatar != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(viewModel.avatar!),
                        minRadius: 40.0,
                      )
                    : const Icon(
                        Icons.person_pin,
                        color: Colors.black87,
                        size: 80.0,
                      ),
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userId,
                      style: const TextStyle(
                          inherit: false,
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1),
                    ),
                    Text(
                      viewModel.name != null ? '@${viewModel.name}' : '',
                      style: const TextStyle(
                          inherit: false,
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1),
                    )
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    const Text(
                      'lucis',
                      style: TextStyle(
                          inherit: false,
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1),
                    ),
                    Text(
                      viewModel.lucis != null ? '${viewModel.lucis}' : '',
                      style: const TextStyle(
                          inherit: false,
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            const SizedBox(
              height: 100.0,
            ),
            Expanded(
              child: PagedGridView(
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) => ImageGridItem(
                    imageUrl: item as String,
                    index: index,
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
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
