import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/bookkeeping/bookkeeping_item.dart';
import 'package:proklinik_one/models/bookkeeping/bookkeeping_item_dto.dart';

class BookkeepingApi {
  final String doc_id;

  BookkeepingApi({required this.doc_id});

  late final String collection = '${doc_id}__bookkeeping';

  Future<void> addBookkeepingItem(BookkeepingItemDto item) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: item.toJson(),
        );
  }

  final _expandList = [
    'added_by_id',
    'updated_by_id',
  ];

  late final _expand = _expandList.join(',');

  Future<ApiResult<List<BookkeepingItem>>> fetchDetailedItems({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final formattedFrom = DateFormat('yyyy-MM-dd', 'en').format(from);
      final formattedTo =
          DateFormat('yyyy-MM-dd', 'en').format(to.copyWith(day: to.day + 1));
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            filter: "created >= '$formattedFrom' && created <= '$formattedTo'",
            sort: '-created',
            expand: _expand,
            batch: 5000,
          );

      final _items =
          _response.map((e) => BookkeepingItem.fromRecordModel(e)).toList();

      return ApiDataResult<List<BookkeepingItem>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BookkeepingItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<BookkeepingItemDto>>> fetchItems({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final formattedFrom = DateFormat('yyyy-MM-dd', 'en').format(from);
      final formattedTo =
          DateFormat('yyyy-MM-dd', 'en').format(to.copyWith(day: to.day + 1));
      final _response =
          await PocketbaseHelper.pb.collection(collection).getFullList(
                filter: 'created >= $formattedFrom && created <= $formattedTo',
                sort: 'created-',
              );

      final _items = _response
          .map((e) => BookkeepingItemDto.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<BookkeepingItemDto>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BookkeepingItemDto>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
