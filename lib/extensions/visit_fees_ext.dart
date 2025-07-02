import 'package:flutter/material.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:provider/provider.dart';

extension CalculateFees on Visit {
  num fees_for_bookkeeping(BuildContext context) {
    final _const = context.read<PxAppConstants>();
    late num fees;
    //check visit type
    if (visit_type.id == _const.consultation.id) {
      fees = clinic.consultation_fees;
    } else if (visit_type.id == _const.followup.id) {
      fees = clinic.followup_fees;
    } else {
      fees = clinic.procedure_fees;
    }
    //check visit status
    if (visit_status.id == _const.notAttended.id) {
      fees = 0;
    }

    return fees;
  }
}
