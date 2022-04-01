import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension MarkerUtils on Image {
  static Future<Image?> imageFromNetwork(String url) async {
    final data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    final image = decodeImage(
      data.buffer.asUint8List(),
    );
    return image;
  }

  static Future<Image?> imageFromAsset(String path) async {
    final data = await rootBundle.load(path);
    final image = decodeImage(
      data.buffer.asUint8List(),
    );
    return image;
  }

  BitmapDescriptor toBitmapDescriptor() {
    final byteImage = Uint8List.fromList(encodePng(this));
    return BitmapDescriptor.fromBytes(byteImage);
  }

  Image circularCropResize({required int radius}) {
    final circularImage = copyCropCircle(
        copyResize(
          this,
          width: 2 * radius,
          height: 2 * radius,
        ),
        radius: radius);
    return circularImage;
  }

  BitmapDescriptor toBitmapDescriptorResized(
    int size,
  ) {
    final resizedImage = copyResize(
      this,
      width: size,
      height: size,
    );

    return resizedImage.toBitmapDescriptor();
  }
}
