import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_doctor_portal/core/api/auth/api_error_handler.dart';
import 'package:proklinik_doctor_portal/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_doctor_portal/functions/dprint.dart';
import 'package:proklinik_doctor_portal/models/dto_create_doctor_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  final SharedPreferencesAsync? asyncPrefs;

  AuthApi({this.asyncPrefs});

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
          .requestVerification(result.getStringValue('email'));
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthApiErrorHandler(e);
    }
  }

  //# normal login flow
  Future<RecordAuth?> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    try {
      final result = await PocketbaseHelper.pb
          .collection('users')
          .authWithPassword(email, password);
      if (rememberMe) {
        await asyncPrefs?.setString('token', result.token);
        PocketbaseHelper.pb.authStore.save(result.token, result.record);
      }
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthApiErrorHandler(e);
    }
  }

  //# remember me login flow
  Future<RecordAuth?> loginWithToken() async {
    try {
      final _token = await asyncPrefs?.getString('token');
      PocketbaseHelper.pb.authStore.save(_token!, null);
      final result =
          await PocketbaseHelper.pb.collection('users').authRefresh();
      PocketbaseHelper.pb.authStore.save(result.token, result.record);
      await asyncPrefs?.setString('token', result.token);
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthApiErrorHandler(e);
    }
  }

  Future<void> requestResetPassword(String email) async {
    try {
      await PocketbaseHelper.pb.collection('users').requestPasswordReset(email);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthApiErrorHandler(e);
    }
  }
}
