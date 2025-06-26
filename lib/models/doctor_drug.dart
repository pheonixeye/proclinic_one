import 'package:equatable/equatable.dart';

class DoctorDrug extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final double concentration;
  final String unit;
  final String form;

  const DoctorDrug({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.concentration,
    required this.unit,
    required this.form,
  });

  DoctorDrug copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    double? concentration,
    String? unit,
    String? form,
  }) {
    return DoctorDrug(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      concentration: concentration ?? this.concentration,
      unit: unit ?? this.unit,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'concentration': concentration,
      'unit': unit,
      'form': form,
    };
  }

  factory DoctorDrug.fromJson(Map<String, dynamic> map) {
    return DoctorDrug(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      concentration: map['concentration'] as double,
      unit: map['unit'] as String,
      form: map['form'] as String,
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
      concentration,
      unit,
      form,
    ];
  }
}
