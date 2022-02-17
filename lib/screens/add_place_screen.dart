import 'package:flutter/material.dart';
import 'package:lucis/widgets/image_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const route = '/add-place';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 10),
                  ImageInput(),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // padding: MediaQuery.of(context).viewPadding,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).viewPadding.bottom),
                alignment: Alignment.center,
                elevation: 0.0),
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: const Text(
              'Add Place',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
