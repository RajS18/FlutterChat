import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.pickImageFn);
  final Function(File img) pickImageFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();

    final pickedImager = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    final pickedImageFile = File(pickedImager.path);
    //actually give us a much smaller image which is way faster to upload and weigh smaller to store.
    setState(() {
      pickedImage = pickedImageFile;
    });
    widget.pickImageFn(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: pickedImage != null ? FileImage(pickedImage) : null,
        ),
        TextButton(
          onPressed: _pickImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.image,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'Add Image',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}
