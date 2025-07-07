import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/bookkeeping/bookkeeping_item.dart';

class BookkeepingApi {
  final String doc_id;

  BookkeepingApi({required this.doc_id});

  late final String collection = '${doc_id}__bookkeeping';

  Future<void> addBookkeepingItem(BookkeepingItem item) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: item.toJson(),
        );
  }

  Future<ApiResult<List<BookkeepingItem>>> fetchItems({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final formattedFrom = DateFormat('yyyy-MM-dd', 'en').format(from);
      final formattedTo = DateFormat('yyyy-MM-dd', 'en').format(to);
      final _response =
          await PocketbaseHelper.pb.collection(collection).getFullList(
                filter: 'created >= $formattedFrom && created < $formattedTo',
                sort: 'created-',
              );

      final _items =
          _response.map((e) => BookkeepingItem.fromJson(e.toJson())).toList();

      return ApiDataResult<List<BookkeepingItem>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BookkeepingItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
