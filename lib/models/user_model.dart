import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userid;
  final String name;
  final String email;

  UserModel(
    this.userid,
    this.name,
    this.email,
  );

  UserModel copyWith({
    String? userid,
    String? name,
    String? email,
  }) {
    return UserModel(
      userid ?? this.userid,
      name ?? this.name,
      email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userid': userid});
    result.addAll({'name': name});
    result.addAll({'email': email});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['userid'] ?? '',
      map['name'] ?? '',
      map['email'] ?? '',
    );
  }

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = snapshot.data()! as Map<String, dynamic>;
    return UserModel(
      snap["userid"] ?? "",
      snap["name"] ?? "",
      snap["email"] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(userid: $userid, name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.userid == userid &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode => userid.hashCode ^ name.hashCode ^ email.hashCode;
}
