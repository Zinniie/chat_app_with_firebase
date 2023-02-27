import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // const UserImagePicker({super.key});
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  // File? _pickedImage;

  // void _pickImage() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImageFile =
  //       await imagePicker.pickImage(source: ImageSource.camera);

  //   setState(() {
  //     if (pickedImageFile != null) {
  //       _pickedImage = File(pickedImageFile.path);
  //     }
  //   });
  //   widget.imagePickFn(pickedImageFile as File);
  // }

  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    final imageTemp = File(pickedImageFile!.path);

    setState(() {
      if (pickedImageFile != null) {
        // _pickedImage = File(pickedImageFile.path);

        this._pickedImage = imageTemp;
      }
    });

    // widget.imagePickFn(pickedImageFile as File);

    widget.imagePickFn(imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
