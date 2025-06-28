import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/auth/auth_exception.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/dto_create_doctor_account.dart';
import 'package:proklinik_one/utils/shared_prefs.dart';

class AuthApi {
  const AuthApi();

  Future<RecordModel?> createAccount(DtoCreateDoctorAccount dto) async {
    try {
      final result = await PocketbaseHelper.pb.collection('users').create(
            body: dto.toJson(),
          );

      await PocketbaseHelper.pb.collection('doctors').create(
        body: {
          'id': result.id,
          'speciality_id': dto.speciality.id,
          'name_en': dto.name_en,
          'name_ar': dto.name_ar,
          'phone': dto.phone,
        },
      );

      await PocketbaseHelper.pb
          .collection('users')
          .requestVerification(result.getStringValue('email'));
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
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

      /// runtimeType check is for avoiding type error when the request does
      /// not return a token i.e. failed request, ==>> (dont save)
      if (rememberMe && result.token.runtimeType == String) {
        await asyncPrefs.setString('token', result.token);
        PocketbaseHelper.pb.authStore.save(result.token, result.record);
      }
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  //# remember me login flow
  Future<RecordAuth?> loginWithToken() async {
    try {
      final _token = await asyncPrefs.getString('token');
      if (_token != null) {
        PocketbaseHelper.pb.authStore.save(_token, null);
      }
      final result =
          await PocketbaseHelper.pb.collection('users').authRefresh();
      PocketbaseHelper.pb.authStore.save(result.token, result.record);
      await asyncPrefs.setString('token', result.token);
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  Future<void> requestResetPassword(String email) async {
    try {
      await PocketbaseHelper.pb.collection('users').requestPasswordReset(email);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  Future<void> logout() async {
    final _token = await asyncPrefs.getString('token');
    PocketbaseHelper.pb.authStore.save(_token!, null);
    await asyncPrefs.remove('token');
  }
}
