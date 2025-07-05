import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/extensions/visit_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visits.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:provider/provider.dart';

class VisitViewCard extends StatelessWidget {
  const VisitViewCard({
    super.key,
    required this.visit,
    required this.index,
  });
  final Visit visit;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxVisits, PxLocale>(
      builder: (context, a, v, l, _) {
        while (a.constants == null) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Card.outlined(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //entry number column
                  Column(
                    spacing: 12,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.updateVisit(
                                visit: visit,
                                key: 'patient_entry_number',
                                value: visit.patient_entry_number + 1,
                              );
                            },
                          );
                        },
                        child: Icon(Icons.arrow_drop_up),
                      ),
                      FloatingActionButton.small(
                        heroTag:
                            '${visit.id}_${visit.patient_entry_number}_${visit.patient_progress_status}',
                        onPressed: null,
                        child: Text('${visit.patient_entry_number}'),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          if (visit.patient_entry_number <= 1) {
                            return;
                          }
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.updateVisit(
                                visit: visit,
                                key: 'patient_entry_number',
                                value: visit.patient_entry_number - 1,
                              );
                            },
                          );
                        },
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                  //data & action rows
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: const Icon(Icons.person),
                              ),
                              Expanded(
                                child: Text(
                                  visit.patient.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (visit.comments.isNotEmpty)
                                Tooltip(
                                  message: visit.comments,
                                  child: Icon(
                                    Icons.info,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                ),
                              //visit type toggle
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: PopupMenuButton<void>(
                                  offset: Offset(0, 48),
                                  elevation: 6,
                                  shadowColor: Colors.transparent,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(),
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      ...a.visitTypes.map((e) {
                                        final _enabled = e.name_en !=
                                            visit.visit_type.name_en;
                                        return PopupMenuItem(
                                          mouseCursor: _enabled
                                              ? SystemMouseCursors.click
                                              : SystemMouseCursors.forbidden,
                                          enabled: _enabled,
                                          child: Center(
                                            child: Card.outlined(
                                              color: e.getCardColor,
                                              elevation: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  l.isEnglish
                                                      ? e.name_en
                                                      : e.name_ar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await v.updateVisit(
                                                  visit: visit,
                                                  key: 'visit_type_id',
                                                  value: e.id,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }),
                                    ];
                                  },
                                  child: Card.outlined(
                                    color: visit.visit_type.getCardColor,
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        l.isEnglish
                                            ? visit.visit_type.name_en
                                            : visit.visit_type.name_ar,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //visit shift row
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: const Icon(Icons.more_time_rounded),
                              ),
                              Expanded(
                                child: Text(visit.formattedShift(context)),
                              ),
                            ],
                          ),
                          //visit status toggle
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: const Icon(Icons.wash_rounded),
                              ),
                              Expanded(
                                child: Text(context.loc.attendanceStatus),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: PopupMenuButton<void>(
                                  offset: Offset(0, 48),
                                  elevation: 6,
                                  shadowColor: Colors.transparent,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(),
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      ...a.visitStatuses.map((e) {
                                        final _enabled = e.name_en !=
                                            visit.visit_status.name_en;
                                        return PopupMenuItem(
                                          mouseCursor: _enabled
                                              ? SystemMouseCursors.click
                                              : SystemMouseCursors.forbidden,
                                          enabled: _enabled,
                                          child: Center(
                                            child: Card.outlined(
                                              color: e.getCardColor,
                                              elevation: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  l.isEnglish
                                                      ? e.name_en
                                                      : e.name_ar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await v.updateVisit(
                                                  visit: visit,
                                                  key: 'visit_status_id',
                                                  value: e.id,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }),
                                    ];
                                  },
                                  child: Card.outlined(
                                    color: visit.visit_status.getCardColor,
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        l.isEnglish
                                            ? visit.visit_status.name_en
                                            : visit.visit_status.name_ar,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //patient progress status toogle
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: const Icon(Icons.add_task_outlined),
                              ),
                              Expanded(
                                child: Text(context.loc.progressStatus),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: PopupMenuButton<void>(
                                  offset: Offset(0, 48),
                                  elevation: 6,
                                  shadowColor: Colors.transparent,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(),
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      ...a.patientProgressStatuses.map((e) {
                                        final _enabled = e.name_en !=
                                            visit.patient_progress_status
                                                .name_en;
                                        return PopupMenuItem(
                                          mouseCursor: _enabled
                                              ? SystemMouseCursors.click
                                              : SystemMouseCursors.forbidden,
                                          enabled: _enabled,
                                          child: Center(
                                            child: Card.outlined(
                                              color: e.getCardColor,
                                              elevation: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  l.isEnglish
                                                      ? e.name_en
                                                      : e.name_ar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await v.updateVisit(
                                                  visit: visit,
                                                  key:
                                                      'patient_progress_status_id',
                                                  value: e.id,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }),
                                    ];
                                  },
                                  child: Card.outlined(
                                    color: visit
                                        .patient_progress_status.getCardColor,
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        l.isEnglish
                                            ? visit
                                                .patient_progress_status.name_en
                                            : visit.patient_progress_status
                                                .name_ar,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //enter details page
                  Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: visit.id +
                            visit.patient_progress_status.id +
                            visit.patient.id,
                        onPressed: () {
                          GoRouter.of(context).goNamed(
                            AppRouter.visit_data,
                            pathParameters: defaultPathParameters(context)
                              ..addAll({
                                'visit_id': visit.id,
                              }),
                          );
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
