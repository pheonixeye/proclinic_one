import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/app_constants/account_type.dart';
import 'package:proklinik_one/models/app_constants/_app_constants.dart';
import 'package:proklinik_one/models/app_constants/subscription_plan.dart';
import 'package:proklinik_one/models/app_constants/visit_status.dart';
import 'package:proklinik_one/models/app_constants/visit_type.dart';

class ConstantsApi {
  const ConstantsApi();

  static const String account_types = 'account_types';
  static const String visit_status = 'visit_status';
  static const String visit_type = 'visit_type';
  static const String subscription_plan = 'subscription_plans';

  Future<AppConstants> fetchConstants() async {
    final _accountTypesRequest =
        await PocketbaseHelper.pb.collection(account_types).getFullList();

    final accountTypes = _accountTypesRequest
        .map((e) => AccountType.fromJson(e.toJson()))
        .toList();

    final _visitStatusRequest =
        await PocketbaseHelper.pb.collection(visit_status).getFullList();

    final visitStatus = _visitStatusRequest
        .map((e) => VisitStatus.fromJson(e.toJson()))
        .toList();

    final _visitTypeRequest =
        await PocketbaseHelper.pb.collection(visit_type).getFullList();

    final visitType =
        _visitTypeRequest.map((e) => VisitType.fromJson(e.toJson())).toList();

    final _subscriptionPlanRequest =
        await PocketbaseHelper.pb.collection(subscription_plan).getFullList();

    final subscriptionPlan = _subscriptionPlanRequest
        .map((e) => SubscriptionPlan.fromJson(e.toJson()))
        .toList();

    return AppConstants(
      accountTypes: accountTypes,
      visitStatus: visitStatus,
      visitType: visitType,
      subscriptionPlan: subscriptionPlan,
    );
  }
}
