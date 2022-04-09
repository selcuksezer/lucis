import 'package:flutter/material.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'dart:io';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/image_upload_viewmodel.dart';
import 'package:lucis/presentation/components/show_dialog.dart';
import 'package:lucis/presentation/routes.dart';

class ImageUploadScreen extends StatefulWidget {
  final ImageUploadArgs args;

  const ImageUploadScreen(
    this.args, {
    Key? key,
  }) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<ImageUploadViewModel>(
      builder: (context, viewModel, child) => Scaffold(
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
                  if (widget.args.isAvatar == null) {
                    await viewModel.uploadImage(widget.args.image);
                  } else {
                    await viewModel.uploadAvatar(widget.args.image);
                  }
                  if (viewModel.status == Status.ready) {
                    Navigator.pop(context);
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
                  if (viewModel.status == Status.ready) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
                iconSize: 30.0,
              ),
              IconButton(
                onPressed: () {
                  if (viewModel.status == Status.ready) {
                    if (widget.args.isAvatar == null) {
                      Navigator.of(context).popUntil((route) =>
                          (route.settings.name == Routes.homeScreen)
                              ? true
                              : false);
                    } else {
                      Navigator.of(context).popUntil((route) =>
                          (route.settings.name == Routes.userScreen)
                              ? true
                              : false);
                    }
                  }
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
              widget.args.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            if (viewModel.status == Status.busy)
              const Center(
                child: CircularProgressIndicator(
                  value: null,
                  color: Colors.orange,
                ),
              ),
            if (viewModel.status == Status.failure)
              ShowDialog(
                  title: viewModel.message.title!,
                  description: viewModel.message.description!)
          ],
        ),
      ),
    );
  }
}

class ImageUploadArgs {
  final File image;
  final bool? isAvatar;

  ImageUploadArgs(
    this.image,
    this.isAvatar,
  );
}
