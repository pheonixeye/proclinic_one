import 'package:proklinik_one/core/api/_api_result.dart';

class VisitDataApi {
  final String doc_id;
  final String visit_id;

  VisitDataApi({
    required this.doc_id,
    required this.visit_id,
  });

  Future<ApiResult> fetchVisitData() async {
    return ApiDataResult(
      data: [],
    );
  }
}
