import 'dart:io';

import 'package:chatapp/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.func, this._isLoading);
  var _isLoading;
  final void Function(String email, String username, String password,
      bool isLogin, BuildContext ctx, File image) func;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImage;

  void _pickedImage(File img) {
    _userImage = img;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context)
        .unfocus(); //now once the values in each of the fields are validated we need our keyboard
    //disappear (or slide down/go away). This above statement does this job for us.
    if (_userImage == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.func(_userEmail.trim(), _userName.trim(), _userPassword.trim(),
          isLogin, context, _userImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AuthScreen AppBar'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      enableSuggestions: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        enableSuggestions: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter a username that is atleast 4 characters long.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Name'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return 'Password must be atleast 6 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    if (widget._isLoading) CircularProgressIndicator(),
                    if (!widget._isLoading)
                      RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(isLogin ? 'Login' : 'SignUp'),
                      ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin
                          ? 'Create New Account'
                          : 'I already have an Account'),
                    ),
                  ],
                ),
              ),
              padding: EdgeInsets.all(16),
            ),
          ),
          elevation: 10,
        ),
      ),
    );
  }
}
