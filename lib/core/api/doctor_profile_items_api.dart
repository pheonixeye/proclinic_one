import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/functions/contains_arabic.dart';
// import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/doctor_items/doctor_drug_item.dart';
import 'package:proklinik_one/models/doctor_items/_doctor_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_lab_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_procedure_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_rad_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/profile_item_page/logic/profile_setup_item_enum.dart';

class DoctorProfileItemsApi {
  DoctorProfileItemsApi({
    required this.doc_id,
    required this.item,
  });

  final String doc_id;
  final ProfileSetupItem item;

  late final String collection = '${doc_id}__${item.name}';

  Future<ApiResult<List<DoctorItem>>> fetchDoctorProfileItems() async {
    try {
      final _result = await PocketbaseHelper.pb.collection(collection).getList(
            perPage: 500,
            page: 1,
          );

      final _items = _result.items
          .map<DoctorItem>((e) => switch (item) {
                ProfileSetupItem.drugs => DoctorDrugItem.fromJson(e.toJson()),
                ProfileSetupItem.labs => DoctorLabItem.fromJson(e.toJson()),
                ProfileSetupItem.rads => DoctorRadItem.fromJson(e.toJson()),
                ProfileSetupItem.procedures =>
                  DoctorProcedureItem.fromJson(e.toJson()),
                ProfileSetupItem.supplies =>
                  DoctorSupplyItem.fromJson(e.toJson()),
              })
          .toList();

      // prettyPrint(_items);

      return ApiDataResult<List<DoctorItem>>(data: _items);
    } catch (e) {
      return ApiErrorResult<List<DoctorItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createItem(DoctorItem item) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: item.toJson(),
        );
  }

  Future<void> updateItem(DoctorItem item) async {
    await PocketbaseHelper.pb.collection(collection).update(
          item.id,
          body: item.toJson(),
        );
  }

  Future<void> deleteItem(DoctorItem item) async {
    await PocketbaseHelper.pb.collection(collection).delete(
          item.id,
        );
  }

  Future<ApiResult<List<DoctorItem>>> searchForItems(
    String item_name,
  ) async {
    String filterField = containsArabic(item_name) ? 'name_ar' : 'name_en';
    try {
      final _result = await PocketbaseHelper.pb.collection(collection).getList(
            perPage: 500,
            page: 1,
            filter: "$filterField = '$item_name'",
          );

      final _items = _result.items
          .map<DoctorItem>((e) => switch (item) {
                ProfileSetupItem.drugs => DoctorDrugItem.fromJson(e.toJson()),
                ProfileSetupItem.labs => DoctorLabItem.fromJson(e.toJson()),
                ProfileSetupItem.rads => DoctorRadItem.fromJson(e.toJson()),
                ProfileSetupItem.procedures =>
                  DoctorProcedureItem.fromJson(e.toJson()),
                ProfileSetupItem.supplies =>
                  DoctorSupplyItem.fromJson(e.toJson()),
              })
          .toList();

      return ApiDataResult<List<DoctorItem>>(data: _items);
    } catch (e) {
      return ApiErrorResult<List<DoctorItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
