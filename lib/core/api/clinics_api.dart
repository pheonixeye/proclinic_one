import 'dart:typed_data';

import 'package:proklinik_one/core/api/_api_result.dart';
// import 'package:proklinik_one/core/api/cache/api_caching_service.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/clinic.dart';
import 'package:http/http.dart' as http;
import 'package:proklinik_one/models/prescription_details.dart';

class ClinicsApi {
  final String doc_id;

  ClinicsApi({required this.doc_id});

  late final String _collection = '${doc_id}__clinics';

  // String get key => _collection;

  // static final _cacheService = ApiCachingService<List<Clinic>>();

  // final String _fetchDoctorClinics = 'fetchDoctorClinics';

  Future<ApiResult<List<Clinic>>> fetchDoctorClinics() async {
    // if (_cacheService.operationIsCached(key, _fetchDoctorClinics)) {
    //   return _cacheService.getDataByKeys(key, _fetchDoctorClinics)!;
    // }
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getList();

      final _clinics =
          _response.items.map((e) => Clinic.fromJson(e.toJson())).toList();

      // _cacheService.addToCache(
      //   key,
      //   Cachable(
      //     parametrizedQueryName: _fetchDoctorClinics,
      //     data: ApiDataResult<List<Clinic>>(data: _clinics),
      //   ),
      // );

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
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchDoctorClinics,
    // );
  }

  Future<void> updateClinicInfo(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
          clinic.id,
          body: clinic.toJson(),
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchDoctorClinics,
    // );
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
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchDoctorClinics,
    // );
  }

  Future<void> deletePrescriptionFile(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'prescription_file': '',
      },
    );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchDoctorClinics,
    // );
  }

  Future<void> deleteClinic(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).delete(
          clinic.id,
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchDoctorClinics,
    // );
  }

  Future<void> toggleClinicActivation(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'is_active': !clinic.is_active,
      },
    );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchDoctorClinics,
    // );
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
    // _cacheService.invalidateCache(
    //   key,
    //   _fetchDoctorClinics,
    // );
  }
}
