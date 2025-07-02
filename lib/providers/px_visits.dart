import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/visits_api.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/models/visits/visit_create_dto.dart';

class PxVisits extends ChangeNotifier {
  final VisitsApi api;

  PxVisits({required this.api}) {
    _fetchVisits();
  }

  ApiResult<List<Visit>>? _visits;
  ApiResult<List<Visit>>? get visits => _visits;

  static int _page = 1;
  int get page => _page;

  static const perPage = 10;

  Future<void> _fetchVisits() async {
    _visits = await api.fetctVisitsOfToday(page: page, perPage: perPage);
    notifyListeners();
  }

  Future<void> retry() async => await _fetchVisits();

  Future<void> addNewVisit(VisitCreateDto dto) async {
    await api.addNewVisit(dto);
    await _fetchVisits();
  }
}
