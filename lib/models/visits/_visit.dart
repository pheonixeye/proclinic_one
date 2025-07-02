import 'package:equatable/equatable.dart';

import 'package:proklinik_one/models/app_constants/patient_progress_status.dart';
import 'package:proklinik_one/models/app_constants/visit_status.dart';
import 'package:proklinik_one/models/app_constants/visit_type.dart';
import 'package:proklinik_one/models/clinic/clinic.dart';
import 'package:proklinik_one/models/clinic/clinic_schedule.dart';
import 'package:proklinik_one/models/clinic/schedule_shift.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/models/user.dart';

class Visit extends Equatable {
  final String id;
  final Patient patient;
  final Clinic clinic;
  final User added_by;
  final ClinicSchedule clinic_schedule;
  final ScheduleShift clinic_schedule_shift;
  final DateTime visit_date;
  final int patient_entry_number;
  final VisitStatus visit_status;
  final VisitType visit_type;
  final PatientProgressStatus patient_progress_status;
  final String comments;

  const Visit({
    required this.id,
    required this.patient,
    required this.clinic,
    required this.added_by,
    required this.clinic_schedule,
    required this.clinic_schedule_shift,
    required this.visit_date,
    required this.patient_entry_number,
    required this.visit_status,
    required this.visit_type,
    required this.patient_progress_status,
    required this.comments,
  });

  Visit copyWith({
    String? id,
    Patient? patient,
    Clinic? clinic,
    User? added_by,
    ClinicSchedule? clinic_schedule,
    ScheduleShift? clinic_schedule_shift,
    DateTime? visit_date,
    int? patient_entry_number,
    VisitStatus? visit_status,
    VisitType? visit_type,
    PatientProgressStatus? patient_progress_status,
    String? comments,
  }) {
    return Visit(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      clinic: clinic ?? this.clinic,
      added_by: added_by ?? this.added_by,
      clinic_schedule: clinic_schedule ?? this.clinic_schedule,
      clinic_schedule_shift:
          clinic_schedule_shift ?? this.clinic_schedule_shift,
      visit_date: visit_date ?? this.visit_date,
      patient_entry_number: patient_entry_number ?? this.patient_entry_number,
      visit_status: visit_status ?? this.visit_status,
      visit_type: visit_type ?? this.visit_type,
      patient_progress_status:
          patient_progress_status ?? this.patient_progress_status,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'patient': patient.toJson(),
      'clinic': clinic.toJson(),
      'added_by': added_by.toJson(),
      'clinic_schedule': clinic_schedule.toJson(),
      'clinic_schedule_shift_id': clinic_schedule_shift.toJson(),
      'visit_date': visit_date.toIso8601String(),
      'patient_entry_number': patient_entry_number,
      'visit_status': visit_status.toJson(),
      'visit_type': visit_type.toJson(),
      'patient_progress_status': patient_progress_status.toJson(),
      'comments': comments,
    };
  }

  factory Visit.fromJson(Map<String, dynamic> map) {
    return Visit(
      id: map['id'] as String,
      patient: Patient.fromJson(map['patient'] as Map<String, dynamic>),
      clinic: Clinic.fromJson(map['clinic'] as Map<String, dynamic>),
      added_by: User.fromJson(map['added_by'] as Map<String, dynamic>),
      clinic_schedule: ClinicSchedule.fromJson(
          map['clinic_schedule'] as Map<String, dynamic>),
      clinic_schedule_shift: ScheduleShift.fromJson(
          map['clinic_schedule_shift'] as Map<String, dynamic>),
      visit_date: DateTime.parse(map['visit_date'] as String),
      patient_entry_number: map['patient_entry_number'] as int,
      visit_status:
          VisitStatus.fromJson(map['visit_status'] as Map<String, dynamic>),
      visit_type: VisitType.fromJson(map['visit_type'] as Map<String, dynamic>),
      patient_progress_status: PatientProgressStatus.fromJson(
          map['patient_progress_status'] as Map<String, dynamic>),
      comments: map['comments'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      patient,
      clinic,
      added_by,
      clinic_schedule,
      clinic_schedule_shift,
      visit_date,
      patient_entry_number,
      visit_status,
      visit_type,
      patient_progress_status,
      comments,
    ];
  }
}
