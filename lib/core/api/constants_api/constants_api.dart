import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/account_type.dart';
import 'package:proklinik_one/models/app_constants.dart';

class ConstantsApi {
  const ConstantsApi();

  static const String account_types = 'account_types';

  Future<AppConstants> fetchConstants() async {
    final _accountTypesRequest =
        await PocketbaseHelper.pb.collection(account_types).getFullList();

    final accountTypes = _accountTypesRequest
        .map((e) => AccountType.fromJson(e.toJson()))
        .toList();

    return AppConstants(
      accountTypes: accountTypes,
    );
  }
}
