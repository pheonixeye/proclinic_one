// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class VisitData extends Equatable {
  final String id;
  const VisitData({
    required this.id,
  });

  VisitData copyWith({
    String? id,
  }) {
    return VisitData(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }

  factory VisitData.fromMap(Map<String, dynamic> map) {
    return VisitData(
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitData.fromJson(String source) =>
      VisitData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id];
}
