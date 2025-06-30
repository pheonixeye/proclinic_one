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
    late final List<AccountType> accountTypes;
    late final List<VisitStatus> visitStatus;
    late final List<VisitType> visitType;
    late final List<SubscriptionPlan> subscriptionPlan;

    final _accountTypesRequest =
        PocketbaseHelper.pb.collection(account_types).getList();

    final _visitStatusRequest =
        PocketbaseHelper.pb.collection(visit_status).getList();

    final _visitTypeRequest =
        PocketbaseHelper.pb.collection(visit_type).getList();

    final _subscriptionPlanRequest =
        PocketbaseHelper.pb.collection(subscription_plan).getList();

    final _result = await Future.wait([
      _accountTypesRequest,
      _visitStatusRequest,
      _visitTypeRequest,
      _subscriptionPlanRequest
    ]);

    accountTypes =
        _result[0].items.map((e) => AccountType.fromJson(e.toJson())).toList();

    visitStatus =
        _result[1].items.map((e) => VisitStatus.fromJson(e.toJson())).toList();

    visitType =
        _result[2].items.map((e) => VisitType.fromJson(e.toJson())).toList();

    subscriptionPlan = _result[3]
        .items
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
