import 'dart:io';

import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String username, String password,
      bool isLogin, BuildContext ctx, File image) async {
    AuthResult
        authResult; //AuthResult is a class: Result object obtained from operations that can affect the
    //authentication state. Contains a method that returns the currently signed-in user after the operation has
    //completed.
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
//Before we actually store the data in the FireStore DB we want to store PickedImage into the Cloud Store Provided by the
//firebase via package firebaseStorage:
//.ref() points to the root directory in the cloud storage bucket
        final ref = FirebaseStorage.instance
            .ref()
            .child(
                'user_image') //creayes (if not present) new sub directory to root
            .child(authResult.user.uid +
                '.jpg'); // creates reference to mentioned file in cloud storage.
        await ref.putFile(image).onComplete;
        //puts image to the above reference stored in variable ref.
//NOTE-> this .putFile(), this returns a storage upload task. This is not the same as a future but it has the same
//idea basically. so we need to make sure it returns a Future and for that we call its member function .oncomplete.
//And hence we can make use of await now. There are several methods as well to see status of the File upload....
//like isPaused, isInProgress, isSuccessFul.
        final url  = await ref.getDownloadURL();
        //Now indorder to get the uploaded image without actually searching all over through the root directory,
        //above methods returns a future or gives you a future that will actually retrieve a long lived
//URL which is usable by anyone who has that URL to view that image and that's great because
//that means that in the future we don't have to use the firebase storage package to scan through all
//our files and find a file for a specific user to use his/her image.

        //Now we want additional information to be stored in FireStore DB. Hence:
        //here if 'user' collection is not found the new collection at root level is made and through document() function
        //new document is inserted with argument as the document:ID. Normally add() is used when we want FireStore to add
        //a document ID automatically. But here want uid generated on Signing up as our records/documents ID. setData()
        //is used to add value that is passed in this setData() function....we need to pass map as Key-value pair i needed.

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (err) {
      var message1 = 'An error occured. Please check your credentials!';
      if (err.message != null) {
        message1 = err.message;
      }
      //Now when ever there is an error on Signin...Loading spinner must not be displayed as an error is there.
      setState(() {
        _isLoading = false;
      });
      // ScaffoldMessenger.of(ctx).showSnackBar(
      //   SnackBar(
      //     content: Text(''),
      //     backgroundColor: Theme.of(context).errorColor,
      //   ),
      // );
      //NOTE HERE above, the context passed to of method of() of the ScaffoldMessenger will take the context of the
//AuthScreen widget, wihich is wrong. We want the context that actually has access to the surrounding scaffold which
//in turn is the context where the snack bar should be mounted on, and because Authscreen context does not have access
//to this scaffold because this scaffold here is rendered by the AuthSCREEN and now the context of the AuthScreen is
//one level above that. So we need the context of the AuthForm hence we need to pass it from th AuthForm widget
//here in Authsubmitform function.
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(''),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //_isLoading is passed as an argument to AuthForm because we need it there to be displayed.
    return AuthForm(_submitAuthForm, _isLoading);
  }
}
