import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/today_patient_progress_api.dart';
import 'package:proklinik_one/models/visits/_visit.dart';

class PxTodayPatientProgress extends ChangeNotifier {
  final TodayPatientProgressApi api;

  PxTodayPatientProgress({required this.api}) {
    subscribe();
  }

  final List<Visit> _visits = [];
  List<Visit> get visits => _visits;

  Stream<RecordSubscriptionEvent>? _stream;

  Future<void> subscribe() async {
    _stream = await api.listenToVisitsCollectionStream();
    if (_stream != null) {
      _stream?.asBroadcastStream().listen((event) {
        switch (event.action) {
          case 'create':
            final _data = event.record;
            if (_data != null) {
              _visits.add(Visit.fromRecordModel(_data));
              _visits.sort((a, b) =>
                  a.patient_entry_number > b.patient_entry_number ? 1 : 0);
              notifyListeners();
            }
            break;
          case 'update':
            final _data = event.record;
            if (_data != null) {
              final _visit = Visit.fromRecordModel(_data);
              final _index = _visits.indexWhere((e) => e.id == _visit.id);
              _visits[_index] = _visit;
              _visits.sort((a, b) =>
                  a.patient_entry_number > b.patient_entry_number ? 1 : 0);
              notifyListeners();
            }
            break;
          case 'delete':
            final _data = event.record;
            if (_data != null) {
              final _visit = Visit.fromRecordModel(_data);
              final _index = _visits.indexWhere((e) => e.id == _visit.id);
              _visits.removeAt(_index);
              _visits.sort((a, b) =>
                  a.patient_entry_number > b.patient_entry_number ? 1 : 0);
              notifyListeners();
            }
        }
      });
    }
  }
}
