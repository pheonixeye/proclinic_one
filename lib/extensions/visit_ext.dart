import 'package:flutter/material.dart';
import 'package:proklinik_one/models/app_constants/patient_progress_status.dart';
import 'package:proklinik_one/models/app_constants/visit_status.dart';
import 'package:proklinik_one/models/app_constants/visit_type.dart';
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

extension WxColorsVisitType on VisitType {
  Color get getCardColor {
    return switch (name_en) {
      'Consultation' => Colors.blue.shade50,
      'Follow Up' => Colors.amber.shade50,
      'Procedure' => Colors.green.shade50,
      _ => Colors.transparent,
    };
  }
}

extension WxColorsVisitStatus on VisitStatus {
  Color get getCardColor {
    return switch (name_en) {
      'Attended' => Colors.blue.shade50,
      'Not Attended' => Colors.red.shade50,
      _ => Colors.transparent,
    };
  }
}

extension WxColorsPatientProgressStatus on PatientProgressStatus {
  Color get getCardColor {
    return switch (name_en) {
      'Has Not Attended Yet' => Colors.purple.shade50,
      'Done Consultation' => Colors.blue.shade50,
      'In Consultation' => Colors.green.shade50,
      'In Waiting' => Colors.amber.shade50,
      _ => Colors.transparent,
    };
  }
}
