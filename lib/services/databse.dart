import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_consignment/constants/constants.dart';
import 'package:flutter_consignment/models/consignment_model.dart';
import 'package:flutter_consignment/models/product_model.dart';
import 'package:flutter_consignment/models/user_model.dart';
import 'package:provider/provider.dart';

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

  // Future<List<Product>> getProduct() async {
  //   QuerySnapshot snap = await db.collection('products').get();
  //   return snap.docs
  //       .map((DocumentSnapshot e) => Product(
  //             prodId: (e.data()! as Map<String, dynamic>)['prodId'],
  //             prodName: (e.data()! as Map<String, dynamic>)['prodName'],
  //             photo: (e.data()! as Map<String, dynamic>)['photo'],
  //             price: (e.data()! as Map<String, dynamic>)['price'],
  //             comments: (e.data()! as Map<String, dynamic>)['comments'],
  //             status: getStatus[(e.data()! as Map<String, dynamic>)['status']]!,
  //           ))
  //       .toList();
  // }

  Future<bool> createConsignment(
      String consignmentId, String name, BuildContext context) async {
    try {
      List<Product> prods = Provider.of<List<Product>>(context, listen: false);
      Product? prod;
      for (int i = 0; i < prods.length; i++) {
        if (prods[i].prodId == consignmentId) {
          prod = prods[i];
        }
      }
      if (prod == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No Product found for this proudct id')));
        }

        return false;
      }
      Consignment consignment = Consignment(
        consignmentId: consignmentId,
        consignmentName: name,
        userid: FirebaseAuth.instance.currentUser!.uid,
        lastUpdated: DateTime.now(),
      );
      await db
          .collection('consignments')
          .doc(consignmentId)
          .set(consignment.toMap());
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  Future<bool> deleteConsignment(String uid) async {
    try {
      await db.collection('consignments').doc(uid).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> createProduct(Product prod) async {
    try {
      await db.collection('products').doc(prod.prodId).set(prod.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct(
      String status, String comment, String prodId) async {
    try {
      await db.collection('products').doc(prodId).update({
        'status': status,
        'comments': comment,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Stream<List<Consignment>> get getConsignmnets {
    return db
        .collection('consignments')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map(
              (DocumentSnapshot documentSnapshot) => Consignment(
                consignmentId: (documentSnapshot.data()!
                    as Map<String, dynamic>)['consignmentId'],
                consignmentName: (documentSnapshot.data()!
                    as Map<String, dynamic>)['consignmentName'],
                userid: (documentSnapshot.data()!
                    as Map<String, dynamic>)['userid'],
                lastUpdated: DateTime.parse(
                  (documentSnapshot.data()!
                      as Map<String, dynamic>)['lastUpdated'],
                ),
              ),
            )
            .toList());
  }

  Stream<List<Product>> get getProducts {
    return db
        .collection('products')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map(
              (DocumentSnapshot documentSnapshot) => Product(
                prodId:
                    (documentSnapshot.data() as Map<String, dynamic>)['prodId'],
                prodName: (documentSnapshot.data()
                    as Map<String, dynamic>)['prodName'],
                photo:
                    (documentSnapshot.data() as Map<String, dynamic>)['photo'],
                price:
                    (documentSnapshot.data() as Map<String, dynamic>)['price'],
                comments: (documentSnapshot.data()
                    as Map<String, dynamic>)['comments'],
                status: getStatus[(documentSnapshot.data()
                        as Map<String, dynamic>)['status']] ??
                    ConsignmentStatus.PENDING,
              ),
            )
            .toList());
  }
}
