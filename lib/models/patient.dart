import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String dob;

  const Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.dob,
  });

  Patient copyWith({
    String? id,
    String? name,
    String? phone,
    String? dob,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'dob': dob,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      dob: map['dob'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, phone, dob];
}
