import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  const ImageInput({Key? key, required this.onSelectImage}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final imagePicker = ImagePicker();
  File? _storedImage;
  Future<void> _takePicture() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera, maxHeight: 600);

    setState(() {
      if (image != null) {
        _storedImage = File(image.path);
      }
    });
    if (_storedImage != null) {
      final appDir = await sys_path.getApplicationDocumentsDirectory();
      final fileName = path.basename(_storedImage!.path);
      _storedImage!.copy('${appDir.path}/$fileName');
      widget.onSelectImage(_storedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: _storedImage != null
                ? Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                  )
                : const Text(
                    'No image to display',
                    textAlign: TextAlign.center,
                  ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera),
            label: Text(
              'Take Photo',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
