// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:chat_app_with_firebase/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  // const AuthForm({super.key});
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  
  var _isLogin = true;
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid =
        _formKey.currentState!.validate(); //trigger the validators in the form

    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!
          .save(); // to get the valus; got to everyt text from frild ajd rigger the insaved
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile!,
        _isLogin,
        context,
      );
      // use those valurs to send our auth request to firebase
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: ((value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: ((value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        }),
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        onSaved: (value) {
                          _userName = value!;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long';
                        }
                        return null;
                      }),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'SignUp'),
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have an account'),
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
