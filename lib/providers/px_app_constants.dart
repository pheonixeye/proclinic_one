import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/constants_api.dart';
import 'package:proklinik_one/models/account_type.dart';
import 'package:proklinik_one/models/app_constants.dart';
import 'package:proklinik_one/models/visit_status.dart';
import 'package:proklinik_one/models/visit_type.dart';

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
      _constants!.accountTypes.firstWhere((acc) => acc.name_en == 'Doctor');

  AccountType get assistantAccountType =>
      _constants!.accountTypes.firstWhere((acc) => acc.name_en == 'Assistant');

  VisitStatus get attended =>
      _constants!.visitStatus.firstWhere((vs) => vs.name_en == 'Attended');

  VisitStatus get notAttended =>
      _constants!.visitStatus.firstWhere((vs) => vs.name_en == 'Not Attended');

  VisitType get consultation =>
      _constants!.visitType.firstWhere((vt) => vt.name_en == 'Consultation');

  VisitType get followup =>
      _constants!.visitType.firstWhere((vt) => vt.name_en == 'Follow Up');

  VisitType get procedure =>
      _constants!.visitType.firstWhere((vt) => vt.name_en == 'Procedure');
}
