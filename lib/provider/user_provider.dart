import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_consignment/models/user_model.dart';

class UserProvider {
  Stream<UserModel?> get user {
    return FirebaseAuth.instance.authStateChanges().map(
        (User? user) => UserModel(user!.uid, user.displayName!, user.email!));
  }
}
