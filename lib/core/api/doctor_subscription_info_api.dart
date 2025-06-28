import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/doctor_subscription.dart';

class DoctorSubscriptionInfoApi {
  final String doc_id;

  DoctorSubscriptionInfoApi({required this.doc_id});

  static const String collection = 'doctor_subscriptions';

  Future<ApiResult<DoctorSubscription>> fetchDoctorSubscriptionInfo() async {
    try {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFirstListItem("doc_id = '$doc_id'");
      final _result = DoctorSubscription.fromJson(_response.toJson());

      return ApiDataResult<DoctorSubscription>(
        data: _result,
      );
    } catch (e) {
      return ApiErrorResult<DoctorSubscription>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> subscribe(
    DoctorSubscription doctorSubscription,
  ) async {
    //TODO: on payment
    await PocketbaseHelper.pb.collection(collection).create(
          body: doctorSubscription.toJson(),
        );
  }
}
