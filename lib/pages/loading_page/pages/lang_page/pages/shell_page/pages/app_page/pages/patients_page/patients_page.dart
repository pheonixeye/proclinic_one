import 'package:flutter/material.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/create_patient_dialog.dart';
import 'package:proklinik_one/providers/px_patients.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxPatients>(
      builder: (context, p, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-new-patient',
            onPressed: () async {
              //todo: Add new patient file dialog
              final _patient = await showDialog<Patient?>(
                context: context,
                builder: (context) {
                  return CreatePatientDialog();
                },
              );
              if (_patient == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await p.createPatientProfile(_patient);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('My Patients'),
                      ),
                      Expanded(
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.small(
                          heroTag: 'patient-search-button',
                          onPressed: () async {},
                          child: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (p.patients == null) {
                      return const CentralLoading();
                    }
                    while (p.patients != null && p.patients!.isEmpty) {
                      return Center(
                        child: const Card.outlined(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No Patients Found.'),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: p.patients?.length,
                      itemBuilder: (context, index) {
                        final item = p.patients![index];
                        return ListTile(
                          leading: FloatingActionButton.small(
                            heroTag: item.id,
                            onPressed: null,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(item.name),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(item.dob),
                                Text(item.phone),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      onPressed: () async {
                        await p.previousPage();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('- ${p.page} -'),
                    ),
                    IconButton.outlined(
                      onPressed: () async {
                        await p.nextPage();
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
