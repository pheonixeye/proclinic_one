import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/auth/api_auth.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/dto_create_doctor_account.dart';

class PxAuth extends ChangeNotifier {
  final AuthApi api;

  PxAuth({
    required this.api,
  });

  RecordAuth? _auth;
  RecordAuth? get authModel => _auth;

  Future<void> createAccount(DtoCreateDoctorAccount dto) async {
    await api.createAccount(dto);
  }

  Future<void> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    try {
      final result =
          await api.loginWithEmailAndPassword(email, password, rememberMe);
      _auth = result;
      notifyListeners();
    } catch (e) {
      _auth = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loginWithToken() async {
    try {
      final result = await api.loginWithToken();
      _auth = result;
      notifyListeners();
      dprint('token from api: ${result?.token.substring(0, 5)}');
    } catch (e) {
      _auth = null;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await api.logout();
      _auth = null;
    } catch (e) {
      dprint(e.toString());
    }
  }
}
