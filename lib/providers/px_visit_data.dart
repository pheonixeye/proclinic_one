import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/visit_data_api.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';

class PxVisitData extends ChangeNotifier {
  final VisitDataApi api;

  PxVisitData({required this.api}) {
    _fetchVisitData();
  }

  ApiResult<VisitData>? _result;
  ApiResult<VisitData>? get result => _result;

  Future<void> retry() async => await _fetchVisitData();

  Future<void> _fetchVisitData() async {
    _result = await api.fetchVisitData();
    _subscribe();
    notifyListeners();
  }

  Future<void> _subscribe() async {
    if (_result != null) {
      print('_result != null');
      await api.subscribe(
        (_result as ApiDataResult<VisitData>).data.id,
        (e) async {
          if (e.action == 'delete') {
            await _fetchVisitData();
          } else {
            if (e.record != null) {
              print('e.record != null');
              _result = ApiDataResult<VisitData>(
                data: VisitData.fromRecordModel(e.record!),
              );
              notifyListeners();
            }
          }
        },
      );
      print(
          'PxVisitData()._subscribe(${(_result as ApiDataResult<VisitData>).data.id})');
    }
  }

  Future<void> attachForm(String form_id) async {
    await api.attachForm(
      (_result as ApiDataResult<VisitData>).data.id,
      form_id,
    );
    // await _fetchVisitData();
  }

  Future<void> detachForm(String form_id) async {
    await api.detachForm(
      (_result as ApiDataResult<VisitData>).data.id,
      form_id,
    );
    // await _fetchVisitData();
  }

  @override
  void dispose() {
    api.unsubscribe((_result as ApiDataResult<VisitData>).data.id);
    super.dispose();
  }
}
