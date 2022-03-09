import 'package:flutter/material.dart';
import 'package:lucis/screens/image_upload_screen.dart';
import 'package:lucis/view_models/image_view_model.dart';
import 'package:lucis/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ImageImportScreen extends StatelessWidget {
  static const route = 'image-import';

  const ImageImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageViewModel = Provider.of<ImageViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                try {
                  final user =
                      await userViewModel.getUser('lukas', 'bogdanoff');
                  if (user == null) {
                    return;
                  }
                  final image = await imageViewModel.takePicture(user.id);
                  if (image != null) {
                    Navigator.of(context).pushNamed(ImageUploadScreen.route,
                        arguments: image.image);
                  }
                } catch (e) {
                  print(e);
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
                try {
                  final user =
                      await userViewModel.getUser('lukas', 'bogdanoff');

                  if (user == null) {
                    return;
                  }

                  final image =
                      await imageViewModel.pickImageFromGallery(user.id);
                  if (image != null) {
                    Navigator.of(context).pushNamed(ImageUploadScreen.route,
                        arguments: image.image);
                  }
                } catch (e, tr) {
                  print(e);
                  print(tr);
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
    );
  }
}
