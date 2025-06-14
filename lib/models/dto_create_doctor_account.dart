// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:proklinik_one/models/speciality.dart';

class DtoCreateDoctorAccount extends Equatable {
  final String email;
  final String password;
  final String passwordConfirm;
  final Speciality speciality;
  final bool emailVisibility;

  const DtoCreateDoctorAccount({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.speciality,
    this.emailVisibility = true,
  });

  DtoCreateDoctorAccount copyWith({
    String? email,
    String? password,
    String? passwordConfirm,
    Speciality? speciality,
  }) {
    return DtoCreateDoctorAccount(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      speciality: speciality ?? this.speciality,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'spec_en': speciality.name_en,
      'spec_ar': speciality.name_ar,
      'emailVisibility': emailVisibility,
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        email,
        password,
        passwordConfirm,
        speciality,
        emailVisibility,
      ];
}
