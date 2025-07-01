import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/clinic_schedule_api.dart';
import 'package:proklinik_one/models/clinic/clinic_schedule.dart';
import 'package:proklinik_one/models/clinic/schedule_shift.dart';

class PxClinicSchedule extends ChangeNotifier {
  final ClinicScheduleApi api;

  PxClinicSchedule({required this.api}) {
    _fetchClinicSchedule();
  }

  ApiResult<List<ClinicSchedule>>? _result;
  ApiResult<List<ClinicSchedule>>? get result => _result;

  Future<void> _fetchClinicSchedule() async {
    _result = await api.fetchClinicSchedule();
    notifyListeners();
  }

  Future<void> retry() async => await _fetchClinicSchedule();

  Future<void> addClinicSchedule(ClinicSchedule schedule) async {
    await api.addClinicSchedule(schedule);
    await _fetchClinicSchedule();
  }

  Future<void> deleteClinicSchedule(ClinicSchedule schedule) async {
    await api.deleteClinicSchedule(schedule);
    await _fetchClinicSchedule();
  }

  Future<void> updateClinicSchedule(ClinicSchedule schedule) async {
    await api.updateClinicSchedule(schedule);
    await _fetchClinicSchedule();
  }

  Future<void> addScheduleShift(
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    await api.addScheduleShift(schedule, shift);
    await _fetchClinicSchedule();
  }

  Future<void> deleteScheduleShift(
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    await api.deleteScheduleShift(schedule, shift);
    await _fetchClinicSchedule();
  }

  Future<void> updateScheduleShift(
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    await api.updateScheduleShift(schedule, shift);
    await _fetchClinicSchedule();
  }

  ClinicSchedule? _schedule;
  ClinicSchedule? get schedule => _schedule;

  void selectClinicSchedule(ClinicSchedule sch) {
    _schedule = sch;
    notifyListeners();
  }

  void nullifySchedule() {
    _schedule = null;
    notifyListeners();
  }
}
