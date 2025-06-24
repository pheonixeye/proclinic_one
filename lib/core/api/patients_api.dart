import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/patient.dart';

class PatientsApi {
  PatientsApi({required this.doc_id}) {
    _checkIfCollectionExists();
  }

  final String doc_id;

  late final String collection = '${doc_id}__patients';

  Future<void> _checkIfCollectionExists() async {
    //TODO:
  }

  Future<ApiResult> fetchPatients({
    required int page,
    required int perPage,
  }) async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getList(
                page: page,
                perPage: perPage,
                sort: '-created',
              );

      final patients =
          _response.items.map((e) => Patient.fromJson(e.toJson())).toList();

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createPatientProfile(Patient patient) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: patient.toJson(),
        );
  }

  Future<ApiResult> searchPatientByPhone({
    required String query,
  }) async {
    try {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getList(filter: 'phone = $query');

      final patients =
          _response.items.map((e) => Patient.fromJson(e.toJson())).toList();

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult> searchPatientByName({
    required String query,
    required int page,
    required int perPage,
  }) async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getList(
                filter: "name ?~ '$query'",
                sort: '-created',
                page: page,
                perPage: perPage,
              );
      final patients =
          _response.items.map((e) => Patient.fromJson(e.toJson())).toList();

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> editPatientBaseData(Patient patient) async {
    await PocketbaseHelper.pb.collection(collection).update(
          patient.id,
          body: patient.toJson(),
        );
  }
}
