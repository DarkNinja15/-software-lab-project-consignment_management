import 'dart:convert';

// import 'package:flutter_consignment/constants/constants.dart';

class Consignment {
  final String consignmentId;
  final String consignmentName;
  final String userid;
  final DateTime lastUpdated;
  Consignment({
    required this.consignmentId,
    required this.consignmentName,
    required this.userid,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'consignmentId': consignmentId});
    result.addAll({'consignmentName': consignmentName});
    result.addAll({'userid': userid});
    result.addAll({'lastUpdated': lastUpdated.toString()});

    return result;
  }

  factory Consignment.fromMap(Map<String, dynamic> map) {
    return Consignment(
      consignmentId: map['consignmentId'] ?? '',
      consignmentName: map['consignmentName'] ?? '',
      userid: map['userid'] ?? '',
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Consignment.fromJson(String source) =>
      Consignment.fromMap(json.decode(source));
}
