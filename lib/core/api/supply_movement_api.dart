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

  static const String _expand =
      'clinic_id, added_by_id, supply_item_id, related_visit_id, updated_by_id';

  Future<ApiResult<SupplyMovement>> addSupplyMovement(
    SupplyMovementDto dto,
  ) async {
    try {
      final _response = await PocketbaseHelper.pb.collection(collection).create(
            body: dto.toJson(),
            expand: _expand,
          );

      final _movement = SupplyMovement.fromRecordModel(_response);

      return ApiDataResult<SupplyMovement>(data: _movement);
    } on ClientException catch (e) {
      return ApiErrorResult<SupplyMovement>(
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
      final _response =
          await PocketbaseHelper.pb.collection(collection).getFullList(
                expand: _expand,
                filter:
                    "visit_date >= '$_fromFormatted' && visit_date < '$_toFormatted'",
                sort: 'created-',
              );

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
