import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/patients_api.dart';
import 'package:proklinik_one/models/patient.dart';

class PxPatients extends ChangeNotifier {
  final PatientsApi api;

  PxPatients({required this.api}) {
    fetchPatients();
  }

  List<Patient>? _patients;
  List<Patient>? get patients => _patients;

  int _page = 1;
  int get page => _page;

  final int perPage = 10;

  Future<void> fetchPatients() async {
    _patients = await api.fetchPatients(page: page, perPage: perPage);
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (_patients != null && _patients!.length < 10) {
      return;
    }
    _page++;
    notifyListeners();
    await fetchPatients();
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }
    _page--;
    notifyListeners();
    await fetchPatients();
  }

  Future<void> createPatientProfile(Patient patient) async {
    await api.createPatientProfile(patient);
    await fetchPatients();
  }
}
