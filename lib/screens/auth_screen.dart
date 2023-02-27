// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:chat_app_with_firebase/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        //islogin=false i.e new user which has n account curently
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

//before storing user data we store the image so that we can use also store the image path  in  user data
        //create a refernce to path in the  bucket.
        final ref = FirebaseStorage.instance.ref().child('user_image').child(
            '${authResult.user!.uid}.jpg'); //... perform image upload here

        //the put file method returns uploadTask.The whencompleted takes a callback in which we can fethc the imageurl
        UploadTask uploadTask = ref.putFile(image);
        uploadTask.whenComplete(() async {
          final url = await ref.getDownloadURL();
          //to store some extra data during signup like usrname,etc
          //store the data in cloudFireStore immediatley after signup.
          //.collection()->creates a collection if not exists
          //.doc()->create a document with  an id
          //.set()->a Map to set the fields inside user documents
          await FirebaseFirestore
              .instance //adding a new user; when we signup a new user
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
            'image_url': url,
          });
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occured, please check your credentials';

      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
