import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/clinic_schedule_shift_ext.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/extensions/number_translator.dart';
import 'package:proklinik_one/models/app_constants/patient_progress_status.dart';
import 'package:proklinik_one/models/app_constants/visit_status.dart';
import 'package:proklinik_one/models/app_constants/visit_type.dart';
import 'package:proklinik_one/models/clinic/clinic.dart';
import 'package:proklinik_one/models/clinic/clinic_schedule.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/models/clinic/schedule_shift.dart';
import 'package:proklinik_one/models/visits/visit_create_dto.dart';
import 'package:proklinik_one/models/weekdays.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visits.dart';
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
  late final TextEditingController _commentsController;

  Clinic? _clinic;
  ClinicSchedule? _clinicSchedule;
  ScheduleShift? _scheduleShift;
  DateTime? _visitDate;
  late VisitType? _visitType = context.read<PxAppConstants>().consultation;
  late VisitStatus? _visitStatus = context.read<PxAppConstants>().notAttended;
  late PatientProgressStatus? _patientProgressStatus =
      context.read<PxAppConstants>().has_not_attended_yet;

  @override
  void initState() {
    super.initState();
    _visitDateController = TextEditingController();
    _commentsController = TextEditingController();
  }

  @override
  void dispose() {
    _visitDateController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  final _selectedShape = RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(12), side: BorderSide());
  final _unselectedShape =
      RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12));

  final _selectedColor = Colors.amber.shade50;
  final _unSelectedColor = Colors.white;

  RoundedRectangleBorder _tileBorder(bool isSelected) {
    return isSelected ? _selectedShape : _unselectedShape;
  }

  Widget _validationErrorWidget<T>(FormFieldState<T> field) {
    if (!field.validate()) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 8.0,
          ),
          child: Text(
            field.errorText ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxAppConstants, PxClinics, PxVisits, PxLocale>(
      builder: (context, a, c, v, l, _) {
        while (a.constants == null || c.result == null || v.visits == null) {
          return CentralLoading();
        }
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.addNewVisit,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${widget.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
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
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.pickClinic),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormField<Clinic>(
                        builder: (field) {
                          return Column(
                            spacing: 8,
                            children: [
                              ...(c.result as ApiDataResult<List<Clinic>>)
                                  .data
                                  .map((e) {
                                bool _isSelected = e == _clinic;
                                return RadioListTile<Clinic>(
                                  shape: _tileBorder(_isSelected),
                                  selected: _isSelected,
                                  tileColor: _unSelectedColor,
                                  selectedTileColor: _selectedColor,
                                  title: Text(
                                    l.isEnglish ? e.name_en : e.name_ar,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: e,
                                  groupValue: _clinic,
                                  onChanged: (value) {
                                    setState(() {
                                      _clinic = value;
                                      _clinicSchedule = null;
                                      _scheduleShift = null;
                                    });
                                  },
                                );
                              }),
                              _validationErrorWidget<Clinic>(field),
                            ],
                          );
                        },
                        validator: (value) {
                          if (_clinic == null) {
                            return context.loc.pickClinic;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  if (_clinic != null)
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.pickClinicSchedule),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormField<ClinicSchedule>(
                          validator: (value) {
                            if (_clinicSchedule == null) {
                              return context.loc.pickClinicSchedule;
                            }
                            return null;
                          },
                          builder: (field) {
                            return Column(
                              spacing: 8,
                              children: [
                                ..._clinic!.clinic_schedule.map((e) {
                                  bool _isSelected = e == _clinicSchedule;
                                  return RadioListTile<ClinicSchedule>(
                                    shape: _tileBorder(_isSelected),
                                    selected: _isSelected,
                                    tileColor: _unSelectedColor,
                                    selectedTileColor: _selectedColor,
                                    title: Text(
                                      l.isEnglish
                                          ? Weekdays.getWeekday(e.intday).en
                                          : Weekdays.getWeekday(e.intday).ar,
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: e,
                                    groupValue: _clinicSchedule,
                                    onChanged: (value) async {
                                      setState(() {
                                        _clinicSchedule = value;
                                        _scheduleShift = null;
                                      });

                                      await v
                                          .calculateRemainingVisitsPerClinicShift(
                                              _scheduleShift, _visitDate);
                                    },
                                  );
                                }),
                                _validationErrorWidget(field),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.pickClinicScheduleShift),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormField<ScheduleShift>(
                        validator: (value) {
                          if (_scheduleShift == null) {
                            return context.loc.pickClinicScheduleShift;
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            spacing: 8,
                            children: [
                              if (_clinicSchedule != null)
                                ..._clinicSchedule!.shifts.map((e) {
                                  bool _isSelected = e == _scheduleShift;
                                  return RadioListTile<ScheduleShift>(
                                    shape: _tileBorder(_isSelected),
                                    selected: _isSelected,
                                    tileColor: _unSelectedColor,
                                    selectedTileColor: _selectedColor,
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.formattedFromTo(context),
                                          ),
                                        ),
                                        if (_visitDate != null &&
                                            v.remainingVisitsPerClinicShiftVar !=
                                                null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Tooltip(
                                              message:
                                                  context.loc.dayVisitCount,
                                              child: v.isUpdating
                                                  ? CupertinoActivityIndicator()
                                                  : Text(
                                                      '${v.remainingVisitsPerClinicShiftVar} / ${e.visit_count}'
                                                          .toArabicNumber(
                                                              context),
                                                    ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: e,
                                    groupValue: _scheduleShift,
                                    onChanged: (value) async {
                                      setState(() {
                                        _scheduleShift = value;
                                      });
                                      await v
                                          .calculateRemainingVisitsPerClinicShift(
                                              _scheduleShift, _visitDate);
                                    },
                                  );
                                }),
                              _validationErrorWidget(field),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.pickVisitDate),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 8,
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
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return context.loc.pickVisitDate;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FloatingActionButton.small(
                              heroTag: 'pick-visit-date',
                              onPressed: () async {
                                final _vd = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().copyWith(
                                    year: DateTime.now().year + 1,
                                  ),
                                  selectableDayPredicate: (day) {
                                    if (day.weekday ==
                                        _clinicSchedule!.intday) {
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

                                await v.calculateRemainingVisitsPerClinicShift(
                                    _scheduleShift, _visitDate);
                              },
                              child: const Icon(Icons.calendar_month),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.pickVisitType),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormField<VisitType>(
                        validator: (value) {
                          if (_visitType == null) {
                            return context.loc.pickVisitType;
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            spacing: 8,
                            children: [
                              ...a.constants!.visitType.map((e) {
                                bool _isSelected = e == _visitType;
                                return RadioListTile<VisitType>(
                                  shape: _tileBorder(_isSelected),
                                  selected: _isSelected,
                                  tileColor: _unSelectedColor,
                                  selectedTileColor: _selectedColor,
                                  title: Text(
                                    l.isEnglish ? e.name_en : e.name_ar,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: e,
                                  groupValue: _visitType,
                                  onChanged: (value) {
                                    setState(() {
                                      _visitType = value;
                                    });
                                  },
                                );
                              }),
                              _validationErrorWidget(field),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.pickVisitStatus),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormField(
                        validator: (value) {
                          if (_visitStatus == null) {
                            return context.loc.pickVisitStatus;
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            spacing: 8,
                            children: [
                              ...a.constants!.visitStatus.map((e) {
                                bool _isSelected = e == _visitStatus;
                                return RadioListTile<VisitStatus>(
                                  shape: _tileBorder(_isSelected),
                                  selected: _isSelected,
                                  tileColor: _unSelectedColor,
                                  selectedTileColor: _selectedColor,
                                  title: Text(
                                    l.isEnglish ? e.name_en : e.name_ar,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: e,
                                  groupValue: _visitStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      _visitStatus = value;
                                    });
                                  },
                                );
                              }),
                              _validationErrorWidget(field),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.pickPatientProgressStatus),
                    ),
                    subtitle: FormField<PatientProgressStatus>(
                      builder: (field) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 8,
                            children: [
                              ...a.constants!.patientProgressStatus.map((e) {
                                bool _isSelected = e == _patientProgressStatus;
                                return RadioListTile<PatientProgressStatus>(
                                  shape: _tileBorder(_isSelected),
                                  selected: _isSelected,
                                  tileColor: _unSelectedColor,
                                  selectedTileColor: _selectedColor,
                                  title: Text(
                                    l.isEnglish ? e.name_en : e.name_ar,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: e,
                                  groupValue: _patientProgressStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      _patientProgressStatus = value;
                                    });
                                  },
                                );
                              })
                            ],
                          ),
                        );
                      },
                      validator: (value) {
                        if (_patientProgressStatus == null) {
                          return context.loc.pickPatientProgressStatus;
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.comments),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              controller: _commentsController,
                            ),
                          ),
                        ],
                      ),
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
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  final _nextEntryNumber =
                      await v.nextEntryNumber(_visitDate!, _clinic!.id);
                  setState(() {
                    _isLoading = false;
                  });
                  if (context.mounted) {
                    final _visitDto = VisitCreateDto(
                      clinic_id: _clinic!.id,
                      patient_id: widget.patient.id,
                      added_by_id: context.read<PxAuth>().doc_id,
                      clinic_schedule_id: _clinicSchedule!.id,
                      clinic_schedule_shift_id: _scheduleShift!.id,
                      visit_date: _visitDate!.toIso8601String(),
                      patient_entry_number: _nextEntryNumber,
                      visit_status_id: _visitStatus!.id,
                      visit_type_id: _visitType!.id,
                      patient_progress_status_id: _patientProgressStatus!.id,
                      comments: _commentsController.text,
                    );
                    Navigator.pop(context, _visitDto);
                  }
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(
                Icons.check,
                color: Colors.green.shade100,
              ),
            ),
            if (_isLoading)
              CircularProgressIndicator(
                backgroundColor: Colors.amber.shade200,
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
