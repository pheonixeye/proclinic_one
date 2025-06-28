import 'package:equatable/equatable.dart';

class DoctorSubscription extends Equatable {
  final String id;
  final String doc_id;
  final String plan_id;
  final String subscription_status;
  final DateTime start_date;
  final DateTime end_date;

  const DoctorSubscription({
    required this.id,
    required this.doc_id,
    required this.plan_id,
    required this.subscription_status,
    required this.start_date,
    required this.end_date,
  });

  DoctorSubscription copyWith({
    String? id,
    String? doc_id,
    String? plan_id,
    String? subscription_status,
    DateTime? start_date,
    DateTime? end_date,
  }) {
    return DoctorSubscription(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      plan_id: plan_id ?? this.plan_id,
      subscription_status: subscription_status ?? this.subscription_status,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'plan_id': plan_id,
      'subscription_status': subscription_status,
      'start_date': start_date.toIso8601String(),
      'end_date': end_date.toIso8601String(),
    };
  }

  factory DoctorSubscription.fromJson(Map<String, dynamic> map) {
    return DoctorSubscription(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      plan_id: map['plan_id'] as String,
      subscription_status: map['subscription_status'] as String,
      start_date: DateTime.parse(map['start_date'] as String),
      end_date: DateTime.parse(map['end_date'] as String),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      plan_id,
      subscription_status,
      start_date,
      end_date,
    ];
  }
}
