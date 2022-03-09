import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const route = 'user';

  const UserScreen({Key? key, required this.userID}) : super(key: key);

  final String userID;

  @override
  Widget build(BuildContext context) {
    // final userVM = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [],
      ),
    );
  }
}
