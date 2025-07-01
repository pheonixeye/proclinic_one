import 'package:equatable/equatable.dart';

class AppPermission extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;

  const AppPermission({
    required this.id,
    required this.name_en,
    required this.name_ar,
  });

  AppPermission copyWith({
    String? id,
    String? name_en,
    String? name_ar,
  }) {
    return AppPermission(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
    };
  }

  factory AppPermission.fromJson(Map<String, dynamic> map) {
    return AppPermission(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name_en, name_ar];
}
