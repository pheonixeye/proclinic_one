import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/visits_api.dart';
import 'package:proklinik_one/functions/first_where_or_null.dart';
import 'package:proklinik_one/models/clinic/schedule_shift.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/models/visits/visit_create_dto.dart';

class PxVisits extends ChangeNotifier {
  final VisitsApi api;

  PxVisits({required this.api}) {
    _fetchVisitsOfToday();
    _subscribe();
  }

  static TabController? _tabController;
  TabController? get tabController => _tabController;

  TabController getTabController({
    required int length,
    required TickerProvider vsync,
  }) {
    if (_tabController == null) {
      _tabController = TabController(
        length: length,
        vsync: vsync,
      );
      return _tabController!;
    }
    return _tabController!;
  }

  ApiResult<List<Visit>>? _visits;
  ApiResult<List<Visit>>? get visits => _visits;

  static int _page = 1;
  int get page => _page;

  static const perPage = 100;

  Future<ApiResult<List<Visit>>> _fetchVisitsOfASpecificDate(
    DateTime visit_date,
  ) async {
    return await api.fetctVisitsOfASpecificDate(
      page: page,
      perPage: perPage,
      visit_date: visit_date,
    );
  }

  Future<void> _fetchVisitsOfToday() async {
    _visits =
        await api.fetctVisitsOfASpecificDate(page: page, perPage: perPage);
    notifyListeners();
  }

  Future<void> retry() async => await _fetchVisitsOfToday();

  Future<void> addNewVisit(VisitCreateDto dto) async {
    await api.addNewVisit(dto);
    await _fetchVisitsOfToday();
  }

  Future<int> nextEntryNumber(DateTime visit_date, String clinic_id) async {
    toggleIsUpdating();
    final _result = (await _fetchVisitsOfASpecificDate(visit_date)
            as ApiDataResult<List<Visit>>)
        .data;
    final _clinicVisits =
        _result.where((e) => e.clinic.id == clinic_id).toList();

    toggleIsUpdating();
    return _clinicVisits.length + 1;
  }

  //TODO:
  Future<int?> remainingVisitsPerClinicShift(
    ScheduleShift shift,
    DateTime visit_date,
  ) async {
    final _visits = await _fetchVisitsOfASpecificDate(visit_date)
        as ApiDataResult<List<Visit>>;
    final _shift_visits =
        _visits.data.where((e) => e.clinic_schedule_shift == shift).toList();
    return _shift_visits.length;
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  void toggleIsUpdating() {
    _isUpdating = !_isUpdating;
    notifyListeners();
  }

  void _subscribe() async {
    await api.todayVisitsSubscription((e) {
      // print(e.action);
      // print(e.record);
      toggleIsUpdating();
      // await _fetchVisitsOfToday();
      if (e.action == 'delete') {
        (_visits as ApiDataResult<List<Visit>>)
            .data
            .removeWhere((x) => e.record?.id == x.id);
        notifyListeners();
        toggleIsUpdating();
        return;
      }
      final _toUpdatedVisit = (_visits as ApiDataResult<List<Visit>>)
          .data
          .firstWhereOrNull((x) => e.record?.id == x.id);
      if (_toUpdatedVisit != null && e.record != null) {
        final _visitIndex = (_visits as ApiDataResult<List<Visit>>)
            .data
            .indexOf(_toUpdatedVisit);
        (_visits as ApiDataResult<List<Visit>>).data[_visitIndex] =
            Visit.fromRecordModel(e.record!);
        notifyListeners();
      }
      toggleIsUpdating();
    });
  }

  Future<void> updateVisit({
    required Visit visit,
    required String key,
    required dynamic value,
  }) async {
    await api.updateVisit(visit.id, key, value);
    await _fetchVisitsOfToday();
  }
}
