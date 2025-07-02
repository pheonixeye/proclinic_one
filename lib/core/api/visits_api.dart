import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/app_constants/account_type.dart';
import 'package:proklinik_one/models/app_constants/app_permission.dart';
import 'package:proklinik_one/models/app_constants/patient_progress_status.dart';
import 'package:proklinik_one/models/app_constants/visit_status.dart';
import 'package:proklinik_one/models/app_constants/visit_type.dart';
import 'package:proklinik_one/models/clinic/clinic.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/models/user.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/models/visits/visit_create_dto.dart';

class VisitsApi {
  final String doc_id;

  VisitsApi({required this.doc_id});

  late final String collection = '${doc_id}__visits';

  static final String _expand =
      'patient_id, clinic_id, added_by_id, added_by_id.account_type_id, added_by_id.app_permissions_ids, visit_status_id, visit_type_id, patient_progress_status_id';

  final _now = DateTime.now();

  late final _today = DateTime(_now.year, _now.month, _now.day);
  late final _tomorrow = DateTime(_now.year, _now.month, _now.day + 1);
  late final _todayFormatted = DateFormat('yyyy-MM-dd', 'en').format(_today);

  late final _tomorrowFormatted =
      DateFormat('yyyy-MM-dd', 'en').format(_tomorrow);

  Future<ApiResult<List<Visit>>> fetctVisitsOfToday({
    required int page,
    required int perPage,
  }) async {
    try {
      print(_todayFormatted);
      final _result = await PocketbaseHelper.pb.collection(collection).getList(
            page: page,
            perPage: perPage,
            filter:
                "visit_date >= '$_todayFormatted' && visit_date < '$_tomorrowFormatted'",
            expand: _expand,
            sort: '-created, patient_entry_number',
          );

      // prettyPrint(_result);

      final _visits = _result.items.map((e) {
        final _clinic =
            Clinic.fromJson(e.get<RecordModel>('expand.clinic_id').toJson());
        final _clinic_schedule = _clinic.clinic_schedule
            .firstWhere((x) => x.id == e.getStringValue('clinic_schedule_id'));
        final _schedule_shift = _clinic_schedule.shifts.firstWhere(
            (x) => x.id == e.getStringValue('clinic_schedule_shift_id'));
        return Visit(
          id: e.id,
          patient: Patient.fromJson(
              e.get<RecordModel>('expand.patient_id').toJson()),
          clinic: _clinic,
          added_by: User(
            id: e.get<RecordModel>('expand.added_by_id').toJson()['id'],
            email: e.get<RecordModel>('expand.added_by_id').toJson()['email'],
            account_type: AccountType.fromJson(e
                .get<RecordModel>('expand.added_by_id.expand.account_type_id')
                .toJson()),
            app_permissions: (e.get<List<RecordModel>>(
                    'expand.added_by_id.expand.app_permissions_ids'))
                .map((e) => AppPermission.fromJson(e.toJson()))
                .toList(),
          ),
          clinic_schedule: _clinic_schedule,
          clinic_schedule_shift: _schedule_shift,
          visit_date: DateTime.parse(e.getStringValue('visit_date')),
          patient_entry_number: e.getIntValue('patient_entry_number'),
          visit_status: VisitStatus.fromJson(
              e.get<RecordModel>('expand.visit_status_id').toJson()),
          visit_type: VisitType.fromJson(
              e.get<RecordModel>('expand.visit_type_id').toJson()),
          patient_progress_status: PatientProgressStatus.fromJson(
              e.get<RecordModel>('expand.patient_progress_status_id').toJson()),
          comments: e.getStringValue('comments'),
        );
      }).toList();

      return ApiDataResult<List<Visit>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addNewVisit(VisitCreateDto dto) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: dto.toJson(),
        );
  }

  Future<void> updateVisit(String visit_id, String key, dynamic value) async {
    await PocketbaseHelper.pb.collection(collection).update(
      visit_id,
      body: {
        key: value,
      },
    );
  }
}
