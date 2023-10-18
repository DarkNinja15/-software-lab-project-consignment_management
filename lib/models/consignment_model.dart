import 'dart:convert';

class Consignment {
  final String id;
  final String userid;
  final String name;
  final String status;
  final String dateRecieved;

  Consignment(
    this.id,
    this.userid,
    this.name,
    this.status,
    this.dateRecieved,
  );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userid': userid});
    result.addAll({'name': name});
    result.addAll({'status': status});
    result.addAll({'dateRecieved': dateRecieved});

    return result;
  }

  factory Consignment.fromMap(Map<String, dynamic> map) {
    return Consignment(
      map['id'] ?? '',
      map['userid'] ?? '',
      map['name'] ?? '',
      map['status'] ?? '',
      map['dateRecieved'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Consignment.fromJson(String source) =>
      Consignment.fromMap(json.decode(source));
}
