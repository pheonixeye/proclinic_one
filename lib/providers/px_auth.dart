import 'package:flutter/material.dart';
import 'package:proklinik_doctor_portal/core/api/auth/auth.dart';
import 'package:proklinik_doctor_portal/models/dto_create_doctor_account.dart';

class PxAuth extends ChangeNotifier {
  final AuthApi api;

  PxAuth({required this.api});

  Future<void> createAccount(DtoCreateDoctorAccount dto) async {
    await api.createAccount(dto);
  }

  Future<void> loginAccount(String email, String password) async {}
}
