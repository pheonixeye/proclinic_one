import 'package:proklinik_one/core/api/constants_api.dart';
import 'package:proklinik_one/models/bookkeeping/bookkeeping_item.dart';
import 'package:proklinik_one/models/bookkeeping/bookkeeping_name.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_auth.dart';

class BookkeepingTransformer {
  BookkeepingTransformer({
    required this.item_id,
    required this.collection_id,
  });

  final _appConstants = PxAppConstants(api: const ConstantsApi());
  final String item_id;
  final String collection_id;

  late final _attended_id = _appConstants.attended.id;
  late final _not_attended_id = _appConstants.notAttended.id;
  late final _consultation_id = _appConstants.consultation.id;
  late final _followup_id = _appConstants.followup.id;
  late final _procedure_id = _appConstants.procedure.id;

  BookkeepingItem fromVisitCreate(Visit visit) {
    late double _bk_item_amount;

    if (visit.visit_status.id == _not_attended_id) {
      _bk_item_amount = 0;
    } else {
      if (visit.visit_type.id == _consultation_id) {
        _bk_item_amount = visit.clinic.consultation_fees.toDouble();
      }
      if (visit.visit_type.id == _followup_id) {
        _bk_item_amount = visit.clinic.followup_fees.toDouble();
      }
      if (visit.visit_type.id == _procedure_id) {
        _bk_item_amount = visit.clinic.procedure_fees.toDouble();
      }
    }
    final _item = BookkeepingItem(
      id: '',
      item_name: BookkeepingName.visit_create.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: 'in',
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }

  BookkeepingItem fromVisitUpdate(Visit old_visit, Visit updated_visit) {
    late final BookkeepingName _item_name;
    late final String _type;
    late final double _bk_item_amount;

    if (old_visit.visit_status.id == _attended_id &&
        updated_visit.visit_status.id == _not_attended_id) {
      _item_name = BookkeepingName.visit_attendance_update_not_attended;
      if (old_visit.visit_type.id == _consultation_id) {
        _bk_item_amount = (-old_visit.clinic.consultation_fees).toDouble();
      }
      if (old_visit.visit_type.id == _followup_id) {
        _bk_item_amount = (-old_visit.clinic.followup_fees).toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id) {
        _bk_item_amount = (-old_visit.clinic.procedure_fees).toDouble();
      }
    } else if (old_visit.visit_status.id == _not_attended_id &&
        updated_visit.visit_status.id == _attended_id) {
      _item_name = BookkeepingName.visit_attendance_update_attended;
      if (old_visit.visit_type.id == _consultation_id) {
        _bk_item_amount = (old_visit.clinic.consultation_fees).toDouble();
      }
      if (old_visit.visit_type.id == _followup_id) {
        _bk_item_amount = (old_visit.clinic.followup_fees).toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id) {
        _bk_item_amount = (old_visit.clinic.procedure_fees).toDouble();
      }
    } else if (old_visit.visit_status.id == _not_attended_id &&
        updated_visit.visit_status.id == _not_attended_id) {
      _item_name = BookkeepingName.visit_type_update;
      _bk_item_amount = 0;
    } else {
      //old_visit.visit_status.id == new_visit.visit_status.id
      if (old_visit.visit_type.id == _consultation_id &&
          updated_visit.visit_type.id == _followup_id) {
        //consultation => followup
        _item_name = BookkeepingName.visit_type_update_followup;
        _bk_item_amount = (old_visit.clinic.followup_fees -
                old_visit.clinic.consultation_fees)
            .toDouble();
      }
      if (old_visit.visit_type.id == _consultation_id &&
          updated_visit.visit_type.id == _procedure_id) {
        //consultation => procedure
        _item_name = BookkeepingName.visit_type_update_procedure;
        _bk_item_amount = (old_visit.clinic.procedure_fees -
                old_visit.clinic.consultation_fees)
            .toDouble();
      }
      if (old_visit.visit_type.id == _followup_id &&
          updated_visit.visit_type.id == _consultation_id) {
        //followup => consultation
        _item_name = BookkeepingName.visit_type_update_consultation;
        _bk_item_amount = (old_visit.clinic.consultation_fees -
                old_visit.clinic.followup_fees)
            .toDouble();
      }
      if (old_visit.visit_type.id == _followup_id &&
          updated_visit.visit_type.id == _procedure_id) {
        //followup => procedure
        _item_name = BookkeepingName.visit_type_update_procedure;
        _bk_item_amount =
            (old_visit.clinic.procedure_fees - old_visit.clinic.followup_fees)
                .toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id &&
          updated_visit.visit_type.id == _consultation_id) {
        //procedure => consultation
        _item_name = BookkeepingName.visit_type_update_consultation;
        _bk_item_amount = (old_visit.clinic.consultation_fees -
                old_visit.clinic.procedure_fees)
            .toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id &&
          updated_visit.visit_type.id == _followup_id) {
        //procedure => followup
        _item_name = BookkeepingName.visit_type_update_followup;
        _bk_item_amount =
            (old_visit.clinic.followup_fees - old_visit.clinic.procedure_fees)
                .toDouble();
      }
    }
    if (old_visit.visit_status.id == updated_visit.visit_status.id &&
        old_visit.visit_type.id == updated_visit.visit_type.id) {
      _item_name = BookkeepingName.visit_no_update;
      _bk_item_amount = 0;
    }
    _type = _bk_item_amount > 0
        ? 'in'
        : _bk_item_amount == 0
            ? 'none'
            : 'out';

    final _item = BookkeepingItem(
      id: '',
      item_name: _item_name.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: _type,
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }
}
