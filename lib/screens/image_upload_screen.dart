import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:lucis/screens/home_screen.dart';
import '../view_models/image_view_model.dart';
import 'package:lucis/view_models/user_view_model.dart';
import 'package:lucis/view_models/location_view_model.dart';
import 'package:lucis/widgets/show_dialog.dart';

class ImageUploadScreen extends StatefulWidget {
  static const route = 'image-preview';

  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  bool isLoading = false;
  bool isSuccess = false;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    final imageViewModel = Provider.of<ImageViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context);
    final locationViewModel = Provider.of<LocationViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black87,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        elevation: 1.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                isSuccess = await imageViewModel.uploadImage(
                    userViewModel.user!, locationViewModel.location);

                setState(() {
                  isDone = true;
                  isLoading = false;
                });
                if (isSuccess) {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(HomeScreen.route));
                }
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              iconSize: 30.0,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.replay,
                color: Colors.white,
              ),
              iconSize: 30.0,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(HomeScreen.route));
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              iconSize: 30.0,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            imageViewModel.image!.image!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                value: null,
                color: Colors.orange,
              ),
            ),
          if (isDone && !isSuccess)
            const ShowDialog(
                title: 'Upload Failed!',
                description:
                    'Check your connection and location service availability.'),
          if (isDone && isSuccess)
            const Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.black54,
                size: 40.0,
              ),
            ),
        ],
      ),
    );
  }
}
