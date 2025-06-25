import 'package:equatable/equatable.dart';

enum SubscriptionType {
  trial,
  monthly,
  yearly;

  factory SubscriptionType.fromString(String value) {
    return switch (value) {
      'trial' => trial,
      'monthly' => monthly,
      'yearly' => yearly,
      _ => throw UnimplementedError(),
    };
  }
}

enum SubscriptionStatus {
  active,
  inactive;

  factory SubscriptionStatus.fromString(String value) {
    return switch (value) {
      'active' => active,
      'inactive' => inactive,
      _ => throw UnimplementedError(),
    };
  }
}

class DoctorSubscriptionInfo extends Equatable {
  final String id;
  final String doc_id;
  final SubscriptionType subscription_type;
  final SubscriptionStatus subscription_status;
  final DateTime last_payment_date;
  final DateTime next_payment_date;
  final DateTime trial_period_end_date;
  final int subscription_fees;
  final int discount_percentage;

  const DoctorSubscriptionInfo({
    required this.id,
    required this.doc_id,
    required this.subscription_type,
    required this.subscription_status,
    required this.last_payment_date,
    required this.next_payment_date,
    required this.trial_period_end_date,
    required this.subscription_fees,
    required this.discount_percentage,
  });

  DoctorSubscriptionInfo copyWith({
    String? id,
    String? doc_id,
    SubscriptionType? subscription_type,
    SubscriptionStatus? subscription_status,
    DateTime? last_payment_date,
    DateTime? next_payment_date,
    DateTime? trial_period_end_date,
    int? subscription_fees,
    int? discount_percentage,
  }) {
    return DoctorSubscriptionInfo(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      subscription_type: subscription_type ?? this.subscription_type,
      subscription_status: subscription_status ?? this.subscription_status,
      last_payment_date: last_payment_date ?? this.last_payment_date,
      next_payment_date: next_payment_date ?? this.next_payment_date,
      trial_period_end_date:
          trial_period_end_date ?? this.trial_period_end_date,
      subscription_fees: subscription_fees ?? this.subscription_fees,
      discount_percentage: discount_percentage ?? this.discount_percentage,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'subscription_type': subscription_type.name.toString(),
      'subscription_status': subscription_status.name.toString(),
      'last_payment_date': last_payment_date.toIso8601String(),
      'next_payment_date': next_payment_date.toIso8601String(),
      'trial_period_end_date': trial_period_end_date.toIso8601String(),
      'subscription_fees': subscription_fees,
      'discount_percentage': discount_percentage,
    };
  }

  factory DoctorSubscriptionInfo.fromJson(Map<String, dynamic> map) {
    return DoctorSubscriptionInfo(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      subscription_type:
          SubscriptionType.fromString(map['subscription_type'].toString()),
      subscription_status:
          SubscriptionStatus.fromString(map['subscription_status'].toString()),
      last_payment_date: DateTime.parse(map['last_payment_date'].toString()),
      next_payment_date: DateTime.parse(map['next_payment_date'].toString()),
      trial_period_end_date:
          DateTime.parse(map['trial_period_end_date'].toString()),
      subscription_fees: map['subscription_fees'] as int,
      discount_percentage: map['discount_percentage'] as int,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      subscription_type,
      subscription_status,
      last_payment_date,
      next_payment_date,
      trial_period_end_date,
      subscription_fees,
      discount_percentage,
    ];
  }
}
