import 'package:proklinik_one/annotations/unused.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
// import 'package:proklinik_one/core/api/cache/api_caching_service.dart';
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
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';

class DoctorProfileItemsApi<T extends DoctorItem> {
  DoctorProfileItemsApi({
    required this.doc_id,
    required this.item,
  });

  final String doc_id;
  final ProfileSetupItem item;

  // static final _cacheService = ApiCachingService<List<DoctorItem>>();

  late final String collection = '${doc_id}__${item.name}';

  // String get key => collection;

  // static const String _fetch = 'fetchDoctorProfileItems';

  Future<ApiResult<List<T>>> fetchDoctorProfileItems() async {
    // if (_cacheService.operationIsCached(key, _fetch)) {
    //   return _cacheService.getDataByKeys(key, _fetch)!;
    // }
    try {
      final _result = await PocketbaseHelper.pb.collection(collection).getList(
            perPage: 500,
            page: 1,
          );

      final _items = _result.items
          .map<T>((e) => switch (item) {
                ProfileSetupItem.drugs =>
                  DoctorDrugItem.fromJson(e.toJson()) as T,
                ProfileSetupItem.labs =>
                  DoctorLabItem.fromJson(e.toJson()) as T,
                ProfileSetupItem.rads =>
                  DoctorRadItem.fromJson(e.toJson()) as T,
                ProfileSetupItem.procedures =>
                  DoctorProcedureItem.fromJson(e.toJson()) as T,
                ProfileSetupItem.supplies =>
                  DoctorSupplyItem.fromJson(e.toJson()) as T,
              })
          .toList();

      // prettyPrint(_items);
      // _cacheService.addToCache(
      //   key,
      //   Cachable(
      //     parametrizedQueryName: _fetch,
      //     data: ApiDataResult<List<DoctorItem>>(data: _items),
      //   ),
      // );

      return ApiDataResult<List<T>>(data: _items);
    } catch (e) {
      return ApiErrorResult<List<T>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createItem(Map<String, dynamic> item) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: item,
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetch,
    // );
  }

  Future<void> updateItem(Map<String, dynamic> item) async {
    await PocketbaseHelper.pb.collection(collection).update(
          item['id'],
          body: item,
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetch,
    // );
  }

  Future<void> deleteItem(DoctorItem item) async {
    await PocketbaseHelper.pb.collection(collection).delete(
          item.id,
        );
    // _cacheService.invalidateCache(
    //   key,
    //   _fetch,
    // );
  }

  @Unused()
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
