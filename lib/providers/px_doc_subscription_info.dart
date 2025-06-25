import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/doctor_subscription_info_api.dart';
import 'package:proklinik_one/models/doctor_subscription_info.dart';

class PxDocSubscriptionInfo extends ChangeNotifier {
  final DoctorSubscriptionInfoApi api;

  PxDocSubscriptionInfo({required this.api}) {
    _fetchDoctorSubscriptionInfo();
  }

  ApiResult<DoctorSubscriptionInfo>? _result;
  ApiResult<DoctorSubscriptionInfo>? get result => _result;

  Future<void> _fetchDoctorSubscriptionInfo() async {
    _result = await api.fetchDoctorSubscriptionInfo();
    notifyListeners();
  }

  Future<void> updateDoctorSubscriptionInfo(DoctorSubscriptionInfo info) async {
    await api.updateDoctorSubscriptionInfo(info);
    await _fetchDoctorSubscriptionInfo();
  }
}
