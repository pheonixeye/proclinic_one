import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/specialities_api.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/speciality.dart';

class PxSpec extends ChangeNotifier {
  PxSpec._() {
    _init();
  }

  factory PxSpec.instance() {
    return PxSpec._instance;
  }

  static final PxSpec _instance = PxSpec._();

  Future<void> _init() async {
    _specialities = await SpecialitiesApi.fetchSpecialities();
    notifyListeners();
    dprint('PxSpec._init()');
  }

  List<Speciality>? _specialities;
  List<Speciality>? get specialities => _specialities;

  Speciality? _speciality;
  Speciality? get speciality => _speciality;

  void selectSpeciality(Speciality value) {
    _speciality = value;
    notifyListeners();
  }
}
