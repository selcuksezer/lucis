import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageImportScreen extends StatelessWidget {
  static const route = 'image-import';

  const ImageImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print('camera tapped');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: width / 3.0,
                    color: Colors.black54,
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
              onTap: () {
                print('gallery tapped');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: width / 3.0,
                    color: Colors.black54,
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
