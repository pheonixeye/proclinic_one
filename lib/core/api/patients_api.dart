import 'package:pocketbase/pocketbase.dart';
// import 'package:proklinik_one/core/api/cache/api_caching_service.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/patient.dart';

class PatientsApi {
  PatientsApi({required this.doc_id});

  final String doc_id;

  late final String _collection = '${doc_id}__patients';

  // String get key => _collection;

  // static final _cacheService = ApiCachingService<List<Patient>>();

  // final String _fetchPatients = 'fetchPatients';

  Future<ApiResult> fetchPatients({
    required int page,
    required int perPage,
  }) async {
    // if (_cacheService.operationIsCached(key, _fetchPatients)) {
    //   return _cacheService.getDataByKeys(key, _fetchPatients)!;
    // }
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getList(
                page: page,
                perPage: perPage,
                sort: '-created',
              );

      final patients =
          _response.items.map((e) => Patient.fromJson(e.toJson())).toList();

      // _cacheService.addToCache(
      //   key,
      //   Cachable(
      //     parametrizedQueryName: _fetchPatients,
      //     data: ApiDataResult<List<Patient>>(data: patients),
      //   ),
      // );

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createPatientProfile(Patient patient) async {
    await PocketbaseHelper.pb.collection(_collection).create(
          body: patient.toJson(),
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchPatients,
    // );
  }

  // String _searchPatientByPhone(String query) => '_searchPatientByPhone$query';

  Future<ApiResult> searchPatientByPhone({
    required String query,
  }) async {
    // if (_cacheService.operationIsCached(key, _searchPatientByPhone(query))) {
    //   return _cacheService.getDataByKeys(key, _searchPatientByPhone(query))!;
    // }
    try {
      final _response = await PocketbaseHelper.pb
          .collection(_collection)
          .getList(filter: 'phone = $query');

      final patients =
          _response.items.map((e) => Patient.fromJson(e.toJson())).toList();

      // _cacheService.addToCache(
      //   key,
      //   Cachable(
      //     parametrizedQueryName: _searchPatientByPhone(query),
      //     data: ApiDataResult<List<Patient>>(data: patients),
      //   ),
      // );

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  // String _searchPatientByName(String query) => '_searchPatientByName$query';

  Future<ApiResult> searchPatientByName({
    required String query,
    required int page,
    required int perPage,
  }) async {
    // final _parametrizedQuery =
    //     _searchPatientByName('${query}_${page}_$perPage');
    try {
      // if (_cacheService.operationIsCached(key, _parametrizedQuery)) {
      //   return _cacheService.getDataByKeys(key, _parametrizedQuery)!;
      // }
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getList(
                filter: "name ?~ '$query'",
                sort: '-created',
                page: page,
                perPage: perPage,
              );
      final patients =
          _response.items.map((e) => Patient.fromJson(e.toJson())).toList();

      // _cacheService.addToCache(
      //   key,
      //   Cachable(
      //     parametrizedQueryName: _parametrizedQuery,
      //     data: ApiDataResult<List<Patient>>(data: patients),
      //   ),
      // );

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> editPatientBaseData(Patient patient) async {
    await PocketbaseHelper.pb.collection(_collection).update(
          patient.id,
          body: patient.toJson(),
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchPatients,
    // );
  }
}
