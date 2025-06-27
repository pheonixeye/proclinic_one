import 'package:equatable/equatable.dart';
import 'package:proklinik_one/models/doctor_items/_doctor_item.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/profile_item_page/logic/profile_setup_item_enum.dart';

class DoctorDrugItem extends DoctorItem implements Equatable {
  final double concentration;
  final String unit;
  final String form;
  final List<String> default_doses;

  const DoctorDrugItem({
    required super.id,
    required super.name_en,
    required super.name_ar,
    required this.concentration,
    required this.unit,
    required this.default_doses,
    required this.form,
    super.item = ProfileSetupItem.drugs,
  });

  DoctorDrugItem copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    double? concentration,
    String? unit,
    String? form,
    List<String>? default_doses,
  }) {
    return DoctorDrugItem(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      concentration: concentration ?? this.concentration,
      unit: unit ?? this.unit,
      form: form ?? this.form,
      default_doses: default_doses ?? this.default_doses,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'concentration': concentration,
      'unit': unit,
      'form': form,
      'default_doses': default_doses.map((e) => e.toString()).toList(),
    };
  }

  factory DoctorDrugItem.fromJson(Map<String, dynamic> map) {
    return DoctorDrugItem(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      concentration: map['concentration'] as double,
      unit: map['unit'] as String,
      form: map['form'] as String,
      default_doses: (map['default_doses'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
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
      item,
      default_doses,
    ];
  }
}
