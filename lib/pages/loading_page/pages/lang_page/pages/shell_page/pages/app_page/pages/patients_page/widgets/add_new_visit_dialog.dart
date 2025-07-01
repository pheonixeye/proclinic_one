import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/clinic_schedule_api.dart';
import 'package:proklinik_one/extensions/clinic_schedule_shift_ext.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/app_constants/patient_progress_status.dart';
import 'package:proklinik_one/models/app_constants/visit_status.dart';
import 'package:proklinik_one/models/app_constants/visit_type.dart';
import 'package:proklinik_one/models/clinic.dart';
import 'package:proklinik_one/models/clinic_schedule.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/models/schedule_shift.dart';
import 'package:proklinik_one/models/visits/visit_create_dto.dart';
import 'package:proklinik_one/models/weekdays.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_clinic_schedule.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class AddNewVisitDialog extends StatefulWidget {
  const AddNewVisitDialog({
    super.key,
    required this.patient,
  });
  final Patient patient;
  @override
  State<AddNewVisitDialog> createState() => _AddNewVisitDialogState();
}

class _AddNewVisitDialogState extends State<AddNewVisitDialog> {
  late final _width = MediaQuery.sizeOf(context).width;
  late final _height = MediaQuery.sizeOf(context).height;
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _visitDateController;

  Clinic? _clinic;
  ClinicSchedule? _clinicSchedule;
  ScheduleShift? _scheduleShift;
  DateTime? _visitDate;
  VisitType? _visitType;
  VisitStatus? _visitStatus;
  PatientProgressStatus? _patientProgressStatus;

  @override
  void initState() {
    super.initState();
    _visitDateController = TextEditingController();
  }

  @override
  void dispose() {
    _visitDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxClinics, PxLocale>(
      builder: (context, a, c, l, _) {
        while (a.constants == null || c.result == null) {
          return CentralLoading();
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.addNewVisit,
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${widget.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: context.isMobile ? _width : _width / 2,
            height: context.isMobile ? _height - 150 : _height,
            child: Form(
              key: formKey,
              child: ListView(
                cacheExtent: 3000,
                children: [
                  ListTile(
                    title: Text(context.loc.pickClinic),
                    subtitle: Column(
                      children: [
                        ...(c.result as ApiDataResult<List<Clinic>>)
                            .data
                            .map((e) {
                          return RadioListTile<Clinic>(
                            title: Text(
                              l.isEnglish ? e.name_en : e.name_ar,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: e,
                            groupValue: _clinic,
                            onChanged: (value) {
                              setState(() {
                                _clinic = value;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  if (_clinic != null)
                    ChangeNotifierProvider(
                      key: ValueKey(_clinic),
                      create: (context) => PxClinicSchedule(
                          api: ClinicScheduleApi(
                        doc_id: context.read<PxAuth>().doc_id,
                        clinic_id: _clinic!.id,
                      )),
                      child: Builder(
                        builder: (context) {
                          return Consumer<PxClinicSchedule>(
                            builder: (context, s, _) {
                              while (s.result == null) {
                                return ListTile(
                                  title: Text(context.loc.pickClinicSchedule),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: LinearProgressIndicator(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return ListTile(
                                title: Text(context.loc.pickClinicSchedule),
                                subtitle: Column(
                                  children: [
                                    ...(s.result as ApiDataResult<
                                            List<ClinicSchedule>>)
                                        .data
                                        .map((e) {
                                      return RadioListTile<ClinicSchedule>(
                                        title: Text(
                                          l.isEnglish
                                              ? Weekdays.getWeekday(e.intday).en
                                              : Weekdays.getWeekday(e.intday)
                                                  .ar,
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: e,
                                        groupValue: _clinicSchedule,
                                        onChanged: (value) {
                                          setState(() {
                                            _clinicSchedule = value;
                                            _scheduleShift = null;
                                          });
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ListTile(
                    title: Text(context.loc.pickClinicScheduleShift),
                    subtitle: Column(
                      children: [
                        if (_clinicSchedule != null)
                          ..._clinicSchedule!.shifts.map((e) {
                            return RadioListTile<ScheduleShift>(
                              title: Text(
                                e.formattedFromTo(context),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: e,
                              groupValue: _scheduleShift,
                              onChanged: (value) {
                                setState(() {
                                  _scheduleShift = value;
                                });
                              },
                            );
                          })
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(context.loc.pickVisitDate),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            enabled: false,
                            controller: _visitDateController,
                          ),
                        ),
                        FloatingActionButton.small(
                          heroTag: 'pick-visit-date',
                          onPressed: () async {
                            final _vd = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().copyWith(
                                year: DateTime.now().year + 1,
                              ),
                              selectableDayPredicate: (day) {
                                if (day.weekday == _clinicSchedule!.intday) {
                                  return true;
                                }
                                return false;
                              },
                            );
                            if (_vd == null) {
                              return;
                            }
                            setState(() {
                              _visitDateController.text =
                                  DateFormat('dd / MM / yyyy', l.lang)
                                      .format(_vd);
                              _visitDate = _vd;
                            });
                          },
                          child: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(context.loc.pickVisitType),
                    subtitle: Row(
                      children: [
                        ...a.constants!.visitType.map((e) {
                          return Expanded(
                            child: RadioListTile<VisitType>(
                              title: Text(
                                l.isEnglish ? e.name_en : e.name_ar,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: e,
                              groupValue: _visitType,
                              onChanged: (value) {
                                setState(() {
                                  _visitType = value;
                                });
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(context.loc.pickVisitStatus),
                    subtitle: Row(
                      children: [
                        ...a.constants!.visitStatus.map((e) {
                          return Expanded(
                            child: RadioListTile<VisitStatus>(
                              title: Text(
                                l.isEnglish ? e.name_en : e.name_ar,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: e,
                              groupValue: _visitStatus,
                              onChanged: (value) {
                                setState(() {
                                  _visitStatus = value;
                                });
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(context.loc.pickPatientProgressStatus),
                    subtitle: Row(
                      children: [
                        ...a.constants!.patientProgressStatus.map((e) {
                          return Expanded(
                            child: RadioListTile<PatientProgressStatus>(
                              title: Text(
                                l.isEnglish ? e.name_en : e.name_ar,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: e,
                              groupValue: _patientProgressStatus,
                              onChanged: (value) {
                                setState(() {
                                  _patientProgressStatus = value;
                                });
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final _visitDto = VisitCreateDto(
                    clinic_id: _clinic!.id,
                    patient_id: widget.patient.id,
                    added_by_id: context.read<PxAuth>().doc_id,
                    clinic_schedule_id: _clinicSchedule!.id,
                    clinic_schedule_shift_id: _scheduleShift!.id,
                    visit_date: _visitDate!.toIso8601String(),
                    patient_entry_number: 0, //TODO
                    visit_status_id: _visitStatus!.id,
                    visit_type_id: _visitType!.id,
                    patient_progress_status_id: _patientProgressStatus!.id,
                  );
                  Navigator.pop(context, _visitDto);
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(
                Icons.check,
                color: Colors.green.shade100,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
