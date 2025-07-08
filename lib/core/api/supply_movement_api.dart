import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/supplies/supply_movement.dart';
import 'package:proklinik_one/models/supplies/supply_movement_dto.dart';

class SupplyMovementApi {
  final String doc_id;

  SupplyMovementApi({required this.doc_id});

  late final String collection = '${doc_id}__supply__movements';

  final _expandList = [
    'clinic_id',
    'added_by_id',
    'added_by_id.app_permissions_ids',
    'added_by_id.account_type_id',
    'supply_item_id',
    'related_visit_id',
    'updated_by_id',
    'updated_by_id.app_permissions_ids',
    'updated_by_id.account_type_id',
  ];

  late final String _expand = _expandList.join(',');

  Future<ApiResult<List<SupplyMovement>>> addSupplyMovements(
    List<SupplyMovementDto?> dtos,
  ) async {
    try {
      final List<RecordModel> _responseModels = [];

      for (final dto in dtos) {
        if (dto != null) {
          final _response =
              await PocketbaseHelper.pb.collection(collection).create(
                    body: dto.toJson(),
                    expand: _expand,
                  );
          _responseModels.add(_response);
        }
      }

      final _movements = _responseModels
          .map((e) => SupplyMovement.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<SupplyMovement>>(data: _movements);
    } on ClientException catch (e) {
      return ApiErrorResult<List<SupplyMovement>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<SupplyMovement>>> fetchSupplyMovements({
    required DateTime from,
    required DateTime to,
  }) async {
    final _fromFormatted = DateFormat('yyyy-MM-dd', 'en').format(from);
    final _toFormatted = DateFormat('yyyy-MM-dd', 'en').format(to);

    try {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            expand: _expand,
            filter: "created >= '$_fromFormatted' && created < '$_toFormatted'",
            sort: '-created',
          );

      // prettyPrint(_response);

      final _movements =
          _response.map((e) => SupplyMovement.fromRecordModel(e)).toList();

      return ApiDataResult<List<SupplyMovement>>(data: _movements);
    } on ClientException catch (e) {
      return ApiErrorResult<List<SupplyMovement>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
