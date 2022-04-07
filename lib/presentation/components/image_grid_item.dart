import 'package:flutter/material.dart';

class ImageGridItem extends StatelessWidget {
  final String imageUrl;
  final int index;

  const ImageGridItem({
    required this.imageUrl,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
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
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
