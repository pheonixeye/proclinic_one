import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/clinics_api.dart';
import 'package:proklinik_one/models/clinic.dart';

class PxClinics extends ChangeNotifier {
  final ClinicsApi api;

  PxClinics({required this.api}) {
    _fetchDoctorClinics();
  }

  ApiResult<List<Clinic>>? _result;
  ApiResult<List<Clinic>>? get result => _result;

  Future<void> _fetchDoctorClinics() async {
    _result = await api.fetchDoctorClinics();
    notifyListeners();
  }

  Future<void> retry() async => await _fetchDoctorClinics();

  Future<void> createNewClinic(Clinic clinic) async {
    await api.createNewClinic(clinic);
    await _fetchDoctorClinics();
  }

  Future<void> updateClinicInfo(Clinic clinic) async {
    await api.updateClinicInfo(clinic);
    await _fetchDoctorClinics();
  }

  Future<void> deleteClinic(Clinic clinic) async {
    await api.deleteClinic(clinic);
    await _fetchDoctorClinics();
  }

  Future<void> toggleClinicActivation(Clinic clinic) async {
    await api.toggleClinicActivation(clinic);
    await _fetchDoctorClinics();
  }
}
