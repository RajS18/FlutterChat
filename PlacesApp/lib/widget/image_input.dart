import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);// use the onSelectImage function to run.
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imgPickerInstance = ImagePicker();//instantiate ImagePicker
    final imageFile = await imgPickerInstance.getImage(source: ImageSource.camera,maxWidth: 600);//use getImage method defining the source of image as gallery or camera.
    //Now this will return "imageFile" of type PickedImage but we need a type of File. So we need to cast it explicitly.
    if (imageFile == null) {
      return;
    }//if image is not taken.
    setState(() {
      _storedImage = File(imageFile.toString());//update the UI to display the image in preview section/box
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();// async method
//Path to a directory where the application may place data that is user-generated, or that cannot otherwise be recreated by your application.    
    final fileName = path.basename(imageFile.path);//imageFile.path returns the path of temporary stored camera captured image file
//and path.basename(path) helps in getting the name of the file that is by default assigned by the camera to it.
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');//copy the image to native OS storge for given path.
    widget.onSelectImage(savedImage);// now the function whose reference is passed from screen to here is needed to becalled with proper arguments being passed. 
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
