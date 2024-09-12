import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proklinik_doctor_portal/assets/assets.dart';
import 'package:proklinik_doctor_portal/functions/dprint.dart';
import 'package:proklinik_doctor_portal/models/speciality.dart';

class PxSpec extends ChangeNotifier {
  PxSpec._() {
    _init();
  }

  factory PxSpec.instance() {
    return PxSpec._instance;
  }

  static final PxSpec _instance = PxSpec._();

  Future<void> _init() async {
    final specData = rootBundle.loadString(AppAssets.specialities);

    final List<String> collectedData = await Future.wait([
      specData,
    ]);

    final String specs = collectedData[0];

    final List<dynamic> specStructure = json.decode(specs);

    _specialities = specStructure.map((e) => Speciality.fromJson(e)).toList();
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
