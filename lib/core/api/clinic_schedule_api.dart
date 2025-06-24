import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/clinic_schedule.dart';
import 'package:proklinik_one/models/schedule_shift.dart';

class ClinicScheduleApi {
  final String doc_id;
  final String clinic_id;

  ClinicScheduleApi({
    required this.doc_id,
    required this.clinic_id,
  });

  late final String collection = '${doc_id}__clinics__schedules';

  Future<ApiResult<List<ClinicSchedule>>> fetchClinicSchedule() async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getList(
                filter: "clinic_id = '$clinic_id'",
              );

      final _schedules = _response.items
          .map((e) => ClinicSchedule.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<ClinicSchedule>>(data: _schedules);
    } catch (e) {
      return ApiErrorResult<List<ClinicSchedule>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteClinicSchedule(ClinicSchedule schedule) async {
    await PocketbaseHelper.pb.collection(collection).delete(schedule.id);
  }

  Future<void> addClinicSchedule(ClinicSchedule schedule) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: schedule.toJson(),
        );
  }

  Future<void> updateClinicSchedule(ClinicSchedule schedule) async {
    await PocketbaseHelper.pb.collection(collection).update(
          schedule.id,
          body: schedule.toJson(),
        );
  }

  //schedule_shifts_api

  Future<void> addScheduleShift(
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _toAddShifts = schedule.shifts..add(shift);
    await PocketbaseHelper.pb.collection(collection).update(
      schedule.id,
      body: {'shifts': _toAddShifts},
    );
  }

  Future<void> deleteScheduleShift(
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _toDeleteShifts = schedule.shifts
      ..removeWhere((e) => shift.id == e.id);
    await PocketbaseHelper.pb.collection(collection).update(
      schedule.id,
      body: {'shifts': _toDeleteShifts},
    );
  }

  Future<void> updateScheduleShift(
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _shiftIndex = schedule.shifts.indexWhere((e) => shift.id == e.id);
    final _toUpdateShifts = schedule.shifts
      ..removeAt(_shiftIndex)
      ..insert(_shiftIndex, shift);
    await PocketbaseHelper.pb.collection(collection).update(
      schedule.id,
      body: {'shifts': _toUpdateShifts},
    );
  }
}
