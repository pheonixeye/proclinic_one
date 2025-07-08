import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/supplies/clinic_inventory_item.dart';

class ClinicInventoryApi {
  final String clinic_id;
  final String doc_id;

  ClinicInventoryApi({required this.clinic_id, required this.doc_id});

  late final String collection = '${doc_id}__clinic__supplies';

  final String _expand = 'supply_id';

  Future<ApiResult<List<ClinicInventoryItem>>>
      fetchClinicInventoryItems() async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getFullList(
                filter: "clinic_id = '$clinic_id'",
                expand: _expand,
              );

      final _items = _response
          .map(
            (e) => ClinicInventoryItem(
              id: e.id,
              clinic_id: e.getStringValue('clinic_id'),
              supply_item: DoctorSupplyItem.fromJson(
                  e.get<RecordModel>('expand.supply_id').toJson()),
              available_quantity: e.getDoubleValue('available_quantity'),
            ),
          )
          .toList();

      return ApiDataResult<List<ClinicInventoryItem>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<ClinicInventoryItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addNewInventoryItems(List<ClinicInventoryItem> items) async {
    for (final item in items) {
      try {
        await PocketbaseHelper.pb.collection(collection).create(
              body: item.toJson(),
            );
      } catch (e) {
        await PocketbaseHelper.pb.collection(collection).update(
              item.id,
              body: item.toJson(),
            );
      }
    }
  }
}
