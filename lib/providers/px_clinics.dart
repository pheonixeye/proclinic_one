import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/clinics_api.dart';
import 'package:proklinik_one/models/clinic.dart';
import 'package:proklinik_one/models/prescription_details.dart';

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

  Clinic? _clinic;
  Clinic? get clinic => _clinic;

  void selectClinic(Clinic? value) {
    _clinic = value;
    notifyListeners();
  }

  Future<void> updatePrescriptionFile({
    required Uint8List file_bytes,
    required String filename,
  }) async {
    if (_clinic == null) {
      return;
    }
    await api.addPrescriptionImageFileToClinic(
      _clinic!,
      file_bytes: file_bytes,
      filename: filename,
    );
    await _fetchDoctorClinics();
    selectClinic((_result as ApiDataResult<List<Clinic>>)
        .data
        .firstWhere((e) => e.id == _clinic?.id));
  }

  Future<void> deletePrescriptionFile() async {
    if (_clinic == null) {
      return;
    }
    await api.deletePrescriptionFile(
      _clinic!,
    );
    await _fetchDoctorClinics();
    selectClinic((_result as ApiDataResult<List<Clinic>>)
        .data
        .firstWhere((e) => e.id == _clinic?.id));
  }

  Future<void> updatePrescriptionDetails(PrescriptionDetails details) async {
    if (_clinic == null) {
      return;
    }
    await api.updatePrescriptionDetails(_clinic!, details);
    await _fetchDoctorClinics();
    selectClinic((_result as ApiDataResult<List<Clinic>>)
        .data
        .firstWhere((e) => e.id == _clinic?.id));
  }
}
