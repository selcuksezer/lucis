import 'package:flutter/material.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'dart:io';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/image_upload_viewmodel.dart';
import 'package:lucis/widgets/show_dialog.dart';
import 'package:lucis/domain/failure.dart';

class ImageUploadScreen extends StatefulWidget {
  final File image;

  const ImageUploadScreen({
    Key? key,
    required this.image,
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
                  await viewModel.uploadImage(widget.image);
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
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
                iconSize: 30.0,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));
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
              widget.image,
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
              viewModel.failure == Failure.connectionFailure
                  ? const ShowDialog(
                      title: 'Failed to Upload',
                      description: 'Check your network connection.')
                  : const ShowDialog(
                      title: 'Failed to Upload',
                      description: 'Check your network connection.'),
          ],
        ),
      ),
    );
  }
}
