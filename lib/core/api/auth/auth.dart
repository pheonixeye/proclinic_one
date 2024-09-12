import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_doctor_portal/core/api/auth/api_error_handler.dart';
import 'package:proklinik_doctor_portal/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_doctor_portal/models/dto_create_doctor_account.dart';

class AuthApi {
  Future<RecordModel?> createAccount(DtoCreateDoctorAccount dto) async {
    try {
      final result = await PocketbaseHelper.pb.collection('users').create(
            body: dto.toJson(),
          );
      await PocketbaseHelper.pb.collection('doctors').create(
        body: {
          'doc_id': result.id,
        },
      );
      await PocketbaseHelper.pb
          .collection('users')
          .requestVerification(result.id);
      return result;
    } on ClientException catch (e) {
      throw AuthApiErrorHandler(e);
    }
  }
}
