import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';

class VisitDataApi {
  final String doc_id;
  final String visit_id;

  VisitDataApi({
    required this.doc_id,
    required this.visit_id,
  });

  late final String collection = '${doc_id}__visit__data';

  final String _expand =
      'labs_ids, rads_ids, procedures_ids, drugs_ids, supplies_ids, forms_ids';

  Future<ApiResult<VisitData>> fetchVisitData() async {
    try {
      final _result =
          await PocketbaseHelper.pb.collection(collection).getFirstListItem(
                "visit_id = '$visit_id'",
                expand: _expand,
              );

      // prettyPrint(_result.toJson());

      final _visitData = VisitData.fromRecordModel(_result);

      return ApiDataResult<VisitData>(
        data: _visitData,
      );
    } on ClientException catch (e) {
      return ApiErrorResult<VisitData>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<UnsubscribeFunc> subscribe(
    String id,
    void Function(RecordSubscriptionEvent) callback,
  ) async {
    final _sub = await PocketbaseHelper.pb.collection(collection).subscribe(
          id,
          callback,
          filter: "visit_id = '$visit_id'",
          expand: _expand,
        );
    return _sub;
  }

  Future<void> unsubscribe(String visit_data_id) async {
    await PocketbaseHelper.pb.collection(collection).unsubscribe(visit_data_id);
  }

  Future<void> attachForm(String visit_data_id, String form_id) async {
    await PocketbaseHelper.pb.collection(collection).update(
      visit_data_id,
      body: {
        'forms_ids+': form_id,
      },
    );
  }

  Future<void> detachForm(String visit_data_id, String form_id) async {
    try {
      await PocketbaseHelper.pb.collection(collection).update(
        visit_data_id,
        body: {
          'forms_ids-': form_id,
        },
      );
    } catch (e) {
      dprint(e);
    }
  }
}
