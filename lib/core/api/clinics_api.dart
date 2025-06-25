import 'dart:typed_data';

import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/clinic.dart';
import 'package:http/http.dart' as http;
import 'package:proklinik_one/models/prescription_details.dart';

class ClinicsApi {
  final String doc_id;

  ClinicsApi({required this.doc_id});

  late final String collection = '${doc_id}__clinics';

  Future<ApiResult<List<Clinic>>> fetchDoctorClinics() async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getList();

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
        .collection(collection)
        .create(body: clinic.toJson());
  }

  Future<void> updateClinicInfo(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(collection).update(
          clinic.id,
          body: clinic.toJson(),
        );
  }

  Future<void> addPrescriptionImageFileToClinic(
    Clinic clinic, {
    required Uint8List file_bytes,
    required String filename,
  }) async {
    await PocketbaseHelper.pb.collection(collection).update(
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
    await PocketbaseHelper.pb.collection(collection).update(
      clinic.id,
      body: {
        'prescription_file': '',
      },
    );
  }

  Future<void> deleteClinic(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(collection).delete(
          clinic.id,
        );
  }

  Future<void> toggleClinicActivation(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(collection).update(
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
    await PocketbaseHelper.pb.collection(collection).update(
      clinic.id,
      body: {
        'prescription_details': details.toJson(),
      },
    );
  }
}
