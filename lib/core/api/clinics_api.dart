import 'dart:typed_data';

import 'package:proklinik_one/core/api/_api_result.dart';
// import 'package:proklinik_one/core/api/cache/api_caching_service.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/clinic/clinic.dart';
import 'package:http/http.dart' as http;
import 'package:proklinik_one/models/clinic/clinic_schedule.dart';
import 'package:proklinik_one/models/clinic/prescription_details.dart';
import 'package:proklinik_one/models/clinic/schedule_shift.dart';

class ClinicsApi {
  final String doc_id;

  ClinicsApi({required this.doc_id});

  late final String _collection = '${doc_id}__clinics';

  Future<ApiResult<List<Clinic>>> fetchDoctorClinics() async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getList();

      final _clinics =
          _response.items.map((e) => Clinic.fromJson(e.toJson())).toList();

      return ApiDataResult<List<Clinic>>(data: _clinics);
    } catch (e) {
      return ApiErrorResult<List<Clinic>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createNewClinic(Clinic clinic) async {
    await PocketbaseHelper.pb
        .collection(_collection)
        .create(body: clinic.toJson());
  }

  Future<void> updateClinicInfo(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
          clinic.id,
          body: clinic.toJson(),
        );
  }

  Future<void> addPrescriptionImageFileToClinic(
    Clinic clinic, {
    required Uint8List file_bytes,
    required String filename,
  }) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      files: [
        http.MultipartFile.fromBytes(
          'prescription_file',
          file_bytes,
          filename: filename,
        ),
      ],
    );
  }

  Future<void> deletePrescriptionFile(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'prescription_file': '',
      },
    );
  }

  Future<void> deleteClinic(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).delete(
          clinic.id,
        );
  }

  Future<void> toggleClinicActivation(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'is_active': !clinic.is_active,
      },
    );
  }

  Future<void> updatePrescriptionDetails(
    Clinic clinic,
    PrescriptionDetails details,
  ) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'prescription_details': details.toJson(),
      },
    );
  }

  Future<void> addClinicSchedule(Clinic clinic, ClinicSchedule schedule) async {
    final _newSchedule = [...clinic.clinic_schedule, schedule];
    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<void> removeClinicSchedule(
    Clinic clinic,
    ClinicSchedule schedule,
  ) async {
    final _newSchedule = clinic.clinic_schedule
      ..removeWhere((e) => e.id == schedule.id);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<void> updateClinicSchedule(
    Clinic clinic,
    ClinicSchedule schedule,
  ) async {
    final _elementIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_elementIndex] = schedule;

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<void> addScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _newShifts = [...schedule.shifts, shift];

    final _scheduleIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_scheduleIndex] = schedule.copyWith(shifts: _newShifts);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<void> removeScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _newShifts = schedule.shifts..removeWhere((e) => e.id == shift.id);

    final _scheduleIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_scheduleIndex] = schedule.copyWith(shifts: _newShifts);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<void> updateScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _shiftIndex = schedule.shifts.indexWhere((e) => e.id == shift.id);

    final _scheduleIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newShifts = schedule.shifts;

    _newShifts[_shiftIndex] = shift;

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_scheduleIndex] = schedule.copyWith(shifts: _newShifts);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
  }
}
