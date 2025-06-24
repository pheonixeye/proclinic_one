import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/core/api/forms_api.dart';
import 'package:proklinik_one/core/api/patient_forms_api.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/create_edit_patient_dialog.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_forms_dialog.dart';
import 'package:proklinik_one/providers/px_forms.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_patient_forms.dart';
import 'package:proklinik_one/providers/px_patients.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class PatientInfoCard extends StatefulWidget {
  const PatientInfoCard({
    super.key,
    required this.patient,
    required this.index,
  });
  final Patient patient;
  final int index;

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PxPatients>(
          builder: (context, p, _) {
            return ListTile(
              leading: FloatingActionButton.small(
                heroTag: widget.patient.id,
                onPressed: null,
                child: Text('${widget.index + 1}'),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Text(widget.patient.name)),
                  FloatingActionButton.small(
                    tooltip: context.loc.editPatientData,
                    heroTag: '${widget.patient.id}+${widget.index}',
                    onPressed: () async {
                      //todo: edit patient name/phone/dob

                      final _patient = await showDialog<Patient?>(
                        context: context,
                        builder: (context) {
                          return CreateEditPatientDialog(
                            patient: widget.patient,
                          );
                        },
                      );
                      if (_patient == null) {
                        return;
                      }
                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.editPatientBaseData(_patient);
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              titleAlignment: ListTileTitleAlignment.top,
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            DateFormat(
                              'dd / MM / yyyy',
                              context.read<PxLocale>().lang,
                            ).format(
                              DateTime.parse(widget.patient.dob),
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: widget.patient.phone,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  web.window.open(
                                    'tel://+2${widget.patient.phone}',
                                    '_blank',
                                  );
                                },
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<void>(
                      tooltip: context.loc.patientActions,
                      icon: const Icon(Icons.add_reaction),
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        elevation: WidgetStatePropertyAll(6),
                        shadowColor: WidgetStatePropertyAll(Colors.grey),
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.orange.shade300),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      iconColor: Colors.white,
                      elevation: 8,
                      offset: const Offset(0, 32),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.electric_bolt),
                                Text(context.loc.quickVisit),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                Text(context.loc.addNewVisit),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.watch_later),
                                Text(context.loc.scheduleAppointment),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.attach_file),
                                Text(context.loc.patientForms),
                              ],
                            ),
                            onTap: () async {
                              final _doc_id = p.api.doc_id;
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (context) => PxForms(
                                          api: FormsApi(
                                            doc_id: _doc_id,
                                          ),
                                        ),
                                      ),
                                      ChangeNotifierProvider(
                                        create: (context) => PxPatientForms(
                                          api: PatientFormsApi(
                                            doc_id: _doc_id,
                                            patient_id: widget.patient.id,
                                          ),
                                        ),
                                      ),
                                    ],
                                    child: PatientFormsDialog(),
                                  );
                                },
                              );
                            },
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
