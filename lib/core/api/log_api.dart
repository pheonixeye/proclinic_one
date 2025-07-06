import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/log_entry.dart';

class LogApi {
  const LogApi();

  static const String collection = 'log';

  static Future<void> log({
    required String item_id,
    required String collection_id,
    required String message,
  }) async {
    final log = LogEntry(
      id: '',
      item_id: item_id,
      collection_id: collection_id,
      message: message,
    );
    await PocketbaseHelper.pb.collection(collection).create(body: log.toJson());
  }
}
