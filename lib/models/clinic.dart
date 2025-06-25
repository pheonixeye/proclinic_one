import 'package:equatable/equatable.dart';

class Clinic extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final String phone_number;
  final int consultation_fees;
  final int followup_fees;
  final int followup_duration;
  final bool is_main;
  final bool is_active;
  //TODO: final String prescription_file

  const Clinic({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.phone_number,
    required this.consultation_fees,
    required this.followup_fees,
    required this.followup_duration,
    required this.is_main,
    required this.is_active,
  });

  Clinic copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    String? phone_number,
    int? consultation_fees,
    int? followup_fees,
    int? followup_duration,
    bool? is_main,
    bool? is_active,
  }) {
    return Clinic(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      phone_number: phone_number ?? this.phone_number,
      consultation_fees: consultation_fees ?? this.consultation_fees,
      followup_fees: followup_fees ?? this.followup_fees,
      followup_duration: followup_duration ?? this.followup_duration,
      is_main: is_main ?? this.is_main,
      is_active: is_active ?? this.is_active,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'phone_number': phone_number,
      'consultation_fees': consultation_fees,
      'followup_fees': followup_fees,
      'followup_duration': followup_duration,
      'is_main': is_main,
      'is_active': is_active,
    };
  }

  factory Clinic.fromJson(Map<String, dynamic> map) {
    return Clinic(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      phone_number: map['phone_number'] as String,
      consultation_fees: map['consultation_fees'] as int,
      followup_fees: map['followup_fees'] as int,
      followup_duration: map['followup_duration'] as int,
      is_main: map['is_main'] as bool,
      is_active: map['is_active'] as bool,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name_en,
      name_ar,
      phone_number,
      consultation_fees,
      followup_fees,
      followup_duration,
      is_main,
      is_active,
    ];
  }
}
