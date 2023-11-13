import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_consignment/models/user_model.dart';

class Database {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<UserModel?> getUser(String userid) async {
    try {
      DocumentSnapshot snap = await db.collection('users').doc(userid).get();
      return UserModel.fromSnap(snap);
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveUser(String email, String name, String userid) async {
    UserModel user = UserModel(userid, name, email);
    try {
      await db.collection('users').doc(userid).set(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
