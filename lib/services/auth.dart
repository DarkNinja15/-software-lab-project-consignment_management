import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_consignment/models/user_model.dart';
import 'package:flutter_consignment/services/databse.dart';
// import 'package:flutter_consignment/services/local%20storage/user_preferences.dart';

class AuthMethods {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserModel?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (context.mounted) {
        // Dialogs.materialDialog(
        //   msg: 'Login Success',
        //   title: "Success",
        //   color: Colors.white,
        //   context: context,
        //   dialogShape: Dialogs.dialogShape,
        //   dialogWidth: MediaQuery.of(context).size.width * 0.2,
        // );
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Success')));
      }

      return Database().getUser(user.user!.uid);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  Future<UserModel?> register(
      String name, String email, String password, BuildContext context) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      bool isSuccess = await Database().saveUser(email, name, user.user!.uid);
      if (context.mounted && isSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Success')));
      }

      return UserModel(user.user!.uid, name, email);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }
}
