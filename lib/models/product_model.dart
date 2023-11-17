import 'dart:convert';

import 'package:flutter_consignment/constants/constants.dart';

class Product {
  final String prodId;
  final String prodName;
  final String photo;
  final String price;
  final String comments;
  final ConsignmentStatus status;
  Product({
    required this.prodId,
    required this.prodName,
    required this.photo,
    required this.price,
    required this.comments,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'prodId': prodId});
    result.addAll({'prodName': prodName});
    result.addAll({'photo': photo});
    result.addAll({'price': price});
    result.addAll({'comments': comments});
    result.addAll({'status': status.toString()});

    return result;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      prodId: map['prodId'] ?? '',
      prodName: map['prodName'] ?? '',
      photo: map['photo'] ?? '',
      price: map['price'] ?? '',
      comments: map['comments'] ?? '',
      status: ConsignmentStatus.values
          .firstWhere((element) => element.toString() == map["status"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
