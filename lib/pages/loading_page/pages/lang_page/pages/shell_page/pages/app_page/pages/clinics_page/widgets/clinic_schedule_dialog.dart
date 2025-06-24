import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/clinic.dart';
import 'package:proklinik_one/models/clinic_schedule.dart';
import 'package:proklinik_one/models/schedule_shift.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/select_weekday_dialog.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/visit_count_dialog.dart';
import 'package:proklinik_one/providers/px_clinic_schedule.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class ClinicScheduleDialog extends StatefulWidget {
  const ClinicScheduleDialog({
    super.key,
    required this.clinic,
  });
  final Clinic clinic;

  @override
  State<ClinicScheduleDialog> createState() => _ClinicScheduleDialogState();
}

class _ClinicScheduleDialogState extends State<ClinicScheduleDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(context.loc.clinicSchedule),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      scrollable: false,
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: Consumer2<PxClinicSchedule, PxLocale>(
        builder: (context, cs, l, _) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Scaffold(
              floatingActionButton: FloatingActionButton.small(
                heroTag: 'add-clinic-day-shift',
                tooltip: _controller.index == 0
                    ? context.loc.addClinicDay
                    : context.loc.addDayShift,
                onPressed: _controller.index == 0
                    ? () async {
                        final _intday = await showDialog<int?>(
                          context: context,
                          builder: (context) {
                            return SelectWeekdayDialog();
                          },
                        );
                        if (_intday == null) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              final _schedule = ClinicSchedule.initial(
                                widget.clinic.id,
                                _intday,
                              );
                              await cs.addClinicSchedule(_schedule);
                            },
                          );
                        }
                      }
                    : () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            if (cs.schedule != null) {
                              final _shift = ScheduleShift.initial();
                              await cs.addScheduleShift(cs.schedule!, _shift);
                            }
                          },
                        );
                      },
                child: const Icon(Icons.add),
              ),
              appBar: TabBar(
                onTap: (value) {
                  if (value == 1) {
                    _controller.animateTo(0);
                    return;
                  } else {
                    cs.nullifySchedule();
                    return;
                  }
                },
                controller: _controller,
                tabs: [
                  Tab(
                    child: Text(context.loc.clinicDays),
                  ),
                  Tab(
                    child: Text(
                      cs.schedule == null
                          ? context.loc.dayShifts
                          : '${l.isEnglish ? cs.schedule?.weekday.en : cs.schedule?.weekday.ar}',
                    ),
                  ),
                ],
              ),
              body: TabBarView(
                controller: _controller,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        while (cs.result == null) {
                          return const CentralLoading();
                        }
                        while ((cs.result
                            is ApiErrorResult<List<ClinicSchedule>>)) {
                          return CentralError(
                            code: (cs.result
                                    as ApiErrorResult<List<ClinicSchedule>>)
                                .errorCode,
                            toExecute: cs.retry,
                          );
                        }

                        while (
                            (cs.result as ApiDataResult<List<ClinicSchedule>>)
                                .data
                                .isEmpty) {
                          return CentralNoItems(
                              message: context.loc.noScheduleDaysFound);
                        }

                        final _items =
                            (cs.result as ApiDataResult<List<ClinicSchedule>>)
                                .data;
                        return ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final _schedule = _items[index];
                            return Card.outlined(
                              elevation: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: FloatingActionButton.small(
                                    heroTag: _schedule.id,
                                    onPressed: null,
                                    child: Text('${index + 1}'),
                                  ),
                                  titleAlignment: ListTileTitleAlignment.center,
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l.isEnglish
                                              ? _schedule.weekday.en
                                              : _schedule.weekday.ar,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: FloatingActionButton.small(
                                          heroTag: _schedule.clinic_id +
                                              _schedule.id,
                                          onPressed: () {
                                            //todo: select clinicSchedule => show it's shifts
                                            cs.selectClinicSchedule(_schedule);
                                            _controller.animateTo(1);
                                          },
                                          child:
                                              const Icon(Icons.arrow_forward),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //day shifts
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        while (cs.schedule?.shifts == null) {
                          return const CentralLoading();
                        }
                        while (cs.schedule?.shifts != null &&
                            cs.schedule!.shifts.isEmpty) {
                          return CentralNoItems(
                            message: context.loc.noDayShiftsFound,
                          );
                        }
                        return ListView.builder(
                          itemCount: cs.schedule?.shifts.length,
                          itemBuilder: (context, index) {
                            final _item = cs.schedule!.shifts[index];
                            return Card.outlined(
                              elevation: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: FloatingActionButton.small(
                                    heroTag: 'f$_item',
                                    onPressed: null,
                                    child: Text('${index + 1}'),
                                  ),
                                  titleAlignment: ListTileTitleAlignment.top,
                                  title: Row(
                                    children: [
                                      Expanded(
                                          child:
                                              Text(_item.id.substring(0, 6))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: FloatingActionButton.small(
                                          heroTag: 'del$_item',
                                          backgroundColor: Colors.red.shade300,
                                          onPressed: () async {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await cs.deleteScheduleShift(
                                                  cs.schedule!,
                                                  _item,
                                                );
                                              },
                                            );
                                          },
                                          child:
                                              const Icon(Icons.delete_forever),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 8,
                                      children: [
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Text(context.loc.shiftStartingTime),
                                            Text(' '),
                                            Text(
                                              DateFormat.jm(l.lang).format(
                                                DateTime.now().copyWith(
                                                  hour: _item.start_hour,
                                                  minute: _item.start_min,
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FloatingActionButton.small(
                                                heroTag:
                                                    '${_item.id}starting-time-picker',
                                                child: const Icon(
                                                    Icons.more_time_rounded),
                                                onPressed: () async {
                                                  final _startingTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (_startingTime == null) {
                                                    return;
                                                  }
                                                  if (context.mounted) {
                                                    final _toUpdateItem =
                                                        _item.copyWith(
                                                      start_hour:
                                                          _startingTime.hour,
                                                      start_min:
                                                          _startingTime.minute,
                                                    );
                                                    await shellFunction(
                                                      context,
                                                      toExecute: () async {
                                                        await cs
                                                            .updateScheduleShift(
                                                          cs.schedule!,
                                                          _toUpdateItem,
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Text(context.loc.shiftEndingTime),
                                            Text(' '),
                                            Text(
                                              DateFormat.jm(l.lang).format(
                                                DateTime.now().copyWith(
                                                  hour: _item.end_hour,
                                                  minute: _item.end_min,
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FloatingActionButton.small(
                                                heroTag:
                                                    '${_item.id}end-time-picker',
                                                child: const Icon(
                                                    Icons.timer_off_outlined),
                                                onPressed: () async {
                                                  final _endingTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (_endingTime == null) {
                                                    return;
                                                  }
                                                  if (context.mounted) {
                                                    final _toUpdateItem =
                                                        _item.copyWith(
                                                      end_hour:
                                                          _endingTime.hour,
                                                      end_min:
                                                          _endingTime.minute,
                                                    );
                                                    await shellFunction(
                                                      context,
                                                      toExecute: () async {
                                                        await cs
                                                            .updateScheduleShift(
                                                          cs.schedule!,
                                                          _toUpdateItem,
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Text(context
                                                .loc.allowedNumberOfVisits),
                                            Text(' '),
                                            Text(
                                              ' - ${_item.visit_count} - ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FloatingActionButton.small(
                                                heroTag:
                                                    '${_item.id}visit-count-picker',
                                                child:
                                                    const Icon(Icons.numbers),
                                                onPressed: () async {
                                                  final _visitCount =
                                                      await showDialog<int?>(
                                                    context: context,
                                                    builder: (context) {
                                                      return VisitCountDialog();
                                                    },
                                                  );
                                                  if (_visitCount == null) {
                                                    return;
                                                  }
                                                  if (context.mounted) {
                                                    final _toUpdateShift =
                                                        _item.copyWith(
                                                      visit_count: _visitCount,
                                                    );
                                                    await shellFunction(
                                                      context,
                                                      toExecute: () async {
                                                        await cs
                                                            .updateScheduleShift(
                                                                cs.schedule!,
                                                                _toUpdateShift);
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
