import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/extensions/visit_ext.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_locale.dart';
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
    return Consumer2<PxAppConstants, PxLocale>(
      builder: (context, a, l, _) {
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
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FloatingActionButton.small(
                          heroTag: visit.id,
                          onPressed: null,
                          child: Text('${visit.patient_entry_number}'),
                        ),
                      ),
                      Expanded(
                        child: Text(visit.patient.name),
                      ),
                      //visit type toggle
                      PopupMenuButton<void>(
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
                              final _enabled =
                                  e.name_en != visit.visit_type.name_en;
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        l.isEnglish ? e.name_en : e.name_ar,
                                      ),
                                    ),
                                  ),
                                ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FloatingActionButton.small(
                          heroTag: visit.id + visit.patient_progress_status.id,
                          onPressed: () {},
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      //visit status toggle
                      Text(context.loc.attendanceStatus),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                final _enabled =
                                    e.name_en != visit.visit_status.name_en;
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          l.isEnglish ? e.name_en : e.name_ar,
                                        ),
                                      ),
                                    ),
                                  ),
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
                      //patient progress status toogle
                      Text(context.loc.progressStatus),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    visit.patient_progress_status.name_en;
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          l.isEnglish ? e.name_en : e.name_ar,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ];
                          },
                          child: Card.outlined(
                            color: visit.patient_progress_status.getCardColor,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                l.isEnglish
                                    ? visit.patient_progress_status.name_en
                                    : visit.patient_progress_status.name_ar,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
