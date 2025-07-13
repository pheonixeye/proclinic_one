import 'dart:async';

import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/visits/_visit.dart';

class TodayPatientProgressApi {
  final String doc_id;
  final String clinic_id;
  late final DateTime _date;

  final _expandList = [
    'patient_id',
    'clinic_id',
    'added_by_id',
    'added_by_id.account_type_id',
    'added_by_id.app_permissions_ids',
    'visit_status_id',
    'visit_type_id',
    'patient_progress_status_id',
  ];

  late final String _expand = _expandList.join(',');

  late final _date_of_visit = DateTime(_date.year, _date.month, _date.day);
  late final _date_after_visit =
      DateTime(_date.year, _date.month, _date.day + 1);

  late final _dateOfVisitFormatted =
      DateFormat('yyyy-MM-dd', 'en').format(_date_of_visit);
  late final _dateAfterVisitFormatted =
      DateFormat('yyyy-MM-dd', 'en').format(_date_after_visit);

  TodayPatientProgressApi({
    required this.doc_id,
    required this.clinic_id,
    DateTime? date,
  }) {
    _date = date ?? DateTime.now();
  }

  late final collection = '${doc_id}__visits';

  final _sub = StreamController<RecordSubscriptionEvent>.broadcast();
  late final _Stream = _sub.stream;
  late final _sink = _sub.sink;

  Future<Stream<RecordSubscriptionEvent>>
      listenToVisitsCollectionStream() async {
    await PocketbaseHelper.pb.collection(collection).subscribe(
      '*',
      (event) {
        _sink.add(event);
      },
      expand: _expand,
      filter:
          "visit_date >= '$_dateOfVisitFormatted' && visit_date <= '$_dateAfterVisitFormatted'",
    );
    return _Stream;
  }

  Future<List<Visit>> fetchTodayVisits() async {
    final _response =
        await PocketbaseHelper.pb.collection(collection).getFullList(
              expand: _expand,
              filter:
                  "visit_date >= '$_dateOfVisitFormatted' && visit_date <= '$_dateAfterVisitFormatted'",
              sort: '-patient_entry_number',
            );

    return _response.map((e) => Visit.fromRecordModel(e)).toList();
  }
}
