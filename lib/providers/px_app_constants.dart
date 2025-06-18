import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/constants_api/constants_api.dart';
import 'package:proklinik_one/models/account_type.dart';
import 'package:proklinik_one/models/app_constants.dart';

class PxAppConstants extends ChangeNotifier {
  final ConstantsApi api;

  PxAppConstants({required this.api}) {
    _init();
  }

  AppConstants? _constants;
  AppConstants? get constants => _constants;

  Future<void> _init() async {
    if (_constants != null) {
      return;
    }
    _constants = await api.fetchConstants();
    notifyListeners();
  }

  AccountType get doctorAccountType =>
      _constants!.accountTypes.firstWhere((acc) => acc.name_en == 'doctor');
}
