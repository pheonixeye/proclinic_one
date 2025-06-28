import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/doctor_subscription_info_api.dart';
import 'package:proklinik_one/models/doctor_subscription.dart';

class PxDocSubscriptionInfo extends ChangeNotifier {
  final DoctorSubscriptionInfoApi api;

  PxDocSubscriptionInfo({required this.api}) {
    _fetchDoctorSubscriptionInfo();
  }

  ApiResult<DoctorSubscription>? _result;
  ApiResult<DoctorSubscription>? get result => _result;

  Future<void> _fetchDoctorSubscriptionInfo() async {
    _result = await api.fetchDoctorSubscriptionInfo();
    notifyListeners();
  }

  Future<void> subscribe(DoctorSubscription info) async {
    await api.subscribe(info);
    await _fetchDoctorSubscriptionInfo();
  }
}
