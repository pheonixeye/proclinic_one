import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/doctor_subscription_info.dart';

class DoctorSubscriptionInfoApi {
  final String doc_id;

  DoctorSubscriptionInfoApi({required this.doc_id});

  static const String collection = 'doctor_subscription_info';

  Future<ApiResult<DoctorSubscriptionInfo>>
      fetchDoctorSubscriptionInfo() async {
    try {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFirstListItem("doc_id = '$doc_id'");
      final _result = DoctorSubscriptionInfo.fromJson(_response.toJson());

      return ApiDataResult<DoctorSubscriptionInfo>(
        data: _result,
      );
    } catch (e) {
      return ApiErrorResult<DoctorSubscriptionInfo>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> updateDoctorSubscriptionInfo(
    DoctorSubscriptionInfo info,
  ) async {
    //TODO: on payment
    await PocketbaseHelper.pb.collection(collection).update(
          info.id,
          body: info.toJson(),
        );
  }
}
