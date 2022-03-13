import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../view_models/user_view_model.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key, required this.userID}) : super(key: key);

  final String userID;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserViewModel _userVM = UserViewModel();

  @override
  void initState() {
    _userVM.updateUI = setState;
    _userVM.getUserAvatarFile(widget.userID);
    _userVM.getUser(widget.userID);
    super.initState();
  }

  @override
  void dispose() {
    _userVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
              _userVM.avatar != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(_userVM.avatar!),
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
                    _userVM.user?.id ?? '',
                    style: const TextStyle(
                        inherit: false,
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1),
                  ),
                  Text(
                    _userVM.user?.name != null ? '@${_userVM.user?.name}' : '',
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
                    _userVM.user?.lucis != null ? '${_userVM.user?.lucis}' : '',
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
              pagingController: _userVM.pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Material(
                          child: Stack(children: [
                            Container(
                              constraints: const BoxConstraints.expand(),
                              color: Colors.black87,
                            ),
                            Center(
                              child: Hero(
                                tag: 'image_$index',
                                child: Image.file(
                                  item as File,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            SafeArea(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'image_$index',
                    child: Image.file(
                      item as File,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                crossAxisCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
