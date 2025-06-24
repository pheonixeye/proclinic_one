import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/account_type.dart';
import 'package:proklinik_one/models/app_constants.dart';
import 'package:proklinik_one/models/visit_status.dart';

class ConstantsApi {
  const ConstantsApi();

  static const String account_types = 'account_types';
  static const String visit_status = 'visit_status';

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

    return AppConstants(
      accountTypes: accountTypes,
      visitStatus: visitStatus,
    );
  }
}
