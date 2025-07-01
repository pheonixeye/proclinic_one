import 'package:proklinik_one/core/api/_api_result.dart';
// import 'package:proklinik_one/core/api/cache/api_caching_service.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/clinic/clinic_schedule.dart';
import 'package:proklinik_one/models/clinic/schedule_shift.dart';

class ClinicScheduleApi {
  final String doc_id;
  final String clinic_id;

  ClinicScheduleApi({
    required this.doc_id,
    required this.clinic_id,
  });

  late final String collection = '${doc_id}__clinics__schedules';

  // String get key => collection;

  // static final _cacheService = ApiCachingService<List<ClinicSchedule>>();

  // late final String _fetchClinicSchedule =
  //     'fetchClinicSchedule_${doc_id}_$clinic_id';

  Future<ApiResult<List<ClinicSchedule>>> fetchClinicSchedule() async {
    // if (_cacheService.operationIsCached(key, _fetchClinicSchedule)) {
    //   return _cacheService.getDataByKeys(key, _fetchClinicSchedule)!;
    // }
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getList(
                filter: "clinic_id = '$clinic_id'",
              );

      final _schedules = _response.items
          .map((e) => ClinicSchedule.fromJson(e.toJson()))
          .toList();
      // _cacheService.addToCache(
      //   key,
      //   Cachable(
      //     parametrizedQueryName: _fetchClinicSchedule,
      //     data: ApiDataResult<List<ClinicSchedule>>(data: _schedules),
      //   ),
      // );
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
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchClinicSchedule,
    // );
  }

  Future<void> addClinicSchedule(ClinicSchedule schedule) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: schedule.toJson(),
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchClinicSchedule,
    // );
  }

  Future<void> updateClinicSchedule(ClinicSchedule schedule) async {
    await PocketbaseHelper.pb.collection(collection).update(
          schedule.id,
          body: schedule.toJson(),
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchClinicSchedule,
    // );
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
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchClinicSchedule,
    // );
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
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchClinicSchedule,
    // );
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
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchClinicSchedule,
    // );
  }
}
