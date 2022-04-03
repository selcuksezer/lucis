import 'package:flutter/material.dart';
import 'package:lucis/presentation/screens/base_screen.dart';
import 'package:lucis/presentation/viewmodels/image_import_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';

class ImageImportScreen extends StatelessWidget {
  static const route = 'image-import';

  const ImageImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BaseScreen<ImageImportViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (viewModel.status == Status.ready) {
                    final image = await viewModel.takePhoto();
                    if (image != null) {
                      Navigator.pushNamed(
                        context,
                        '/image-import',
                        arguments: image,
                      );
                    }
                  } else if (viewModel.status == Status.failure) {
                    //TODO: ask for camera permission
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: width / 3.0,
                      color: Colors.orange,
                    ),
                    const Text(
                      'Using Camera',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 2.0,
                indent: 15.0,
                endIndent: 15.0,
                width: width / 6.0,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (viewModel.status == Status.ready) {
                    final image = await viewModel.pickGalleryImage();
                    if (image != null) {
                      Navigator.pushNamed(
                        context,
                        '/image-import',
                        arguments: image,
                      );
                    }
                  } else if (viewModel.status == Status.failure) {
                    //TODO: ask for gallery permission
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: width / 3.0,
                      color: Colors.orange,
                    ),
                    const Text(
                      'From Gallery',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
