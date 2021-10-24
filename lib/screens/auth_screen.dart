import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  String _username, _password, _email;
//TODO make this late
  File _image;
  final _auth = FirebaseAuth.instance;

  void _getTheFormDataAndSubmit(Map<String, String> _authData, File image,
      AuthMode authMode, BuildContext ctx) async {
    _username = _authData['username'];
    _password = _authData['password'];
    _email = _authData['email'];
    _image = image;
    AuthResult authResult;
    setState(() {
      _isLoading = true;
    });
    try {
      if (authMode == AuthMode.LOGIN) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${authResult.user.uid}.jpg');
        await ref.putFile(_image).onComplete;
        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({'username': _username, 'email': _email, 'imageUrl': url});
      }
    } on PlatformException catch (error) {
      var errMessage = 'An Error Occurred, please check your credentials';
      if (error.message != null) errMessage = error.message;
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(errMessage),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'IMessage',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 30,
                    fontFamily: 'Ephesis',
                  ),
                ),
              ),
              AuthForm(
                getTheAuthData: _getTheFormDataAndSubmit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
