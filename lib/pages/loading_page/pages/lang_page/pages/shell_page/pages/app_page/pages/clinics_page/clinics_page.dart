import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/clinic.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/create_edit_clinic_dialog.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:proklinik_one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class ClinicsPage extends StatelessWidget {
  const ClinicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxClinics, PxLocale>(
      builder: (context, c, l, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'create-clinic-btn',
            tooltip: context.loc.addNewClinic,
            onPressed: () async {
              final _clinic = await showDialog<Clinic?>(
                context: context,
                builder: (context) {
                  return const CreateEditClinicDialog();
                },
              );
              if (_clinic == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await c.createNewClinic(_clinic);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.myClinics),
                    ),
                    subtitle: const Divider(),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      while (c.result == null) {
                        return const CentralLoading();
                      }

                      while (c.result is ApiErrorResult) {
                        return CentralError(
                          code: (c.result as ApiErrorResult).errorCode,
                          toExecute: c.retry,
                        );
                      }

                      while (c.result != null &&
                          (c.result is ApiDataResult) &&
                          (c.result as ApiDataResult<List<Clinic>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message: context.loc.noClinicsFound,
                        );
                      }
                      final _items =
                          (c.result as ApiDataResult<List<Clinic>>).data;
                      return ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final _clinic = _items[index];
                          return Card.outlined(
                            elevation: _clinic.is_main ? 0 : 6,
                            color: _clinic.is_main
                                ? Colors.lightBlue.shade200
                                : null,
                            shape: _clinic.is_main
                                ? RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusGeometry.circular(12),
                                    side: BorderSide(),
                                  )
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                leading: FloatingActionButton.small(
                                  heroTag: '${_clinic.id}$index',
                                  onPressed: null,
                                  child: Text('${index + 1}'),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l.isEnglish
                                            ? _clinic.name_en
                                            : _clinic.name_ar,
                                        style: _clinic.is_active
                                            ? null
                                            : TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                      ),
                                    ),
                                    FloatingActionButton.small(
                                      heroTag: _clinic.id,
                                      tooltip: context.loc.editClinic,
                                      onPressed: () async {
                                        final _toUpdate =
                                            await showDialog<Clinic?>(
                                          context: context,
                                          builder: (context) {
                                            return CreateEditClinicDialog(
                                              clinic: _clinic,
                                            );
                                          },
                                        );

                                        if (_toUpdate == null) {
                                          return;
                                        }
                                        if (context.mounted) {
                                          await shellFunction(
                                            context,
                                            toExecute: () async {
                                              await c
                                                  .updateClinicInfo(_toUpdate);
                                            },
                                          );
                                        }
                                      },
                                      child: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 8,
                                        children: [
                                          Text(
                                              "${context.loc.phone} : ${_clinic.phone_number}"),
                                          Text(
                                              "${context.loc.consultationFees} : ${_clinic.consultation_fees}"),
                                          Text(
                                              "${context.loc.followupFees} : ${_clinic.followup_fees}"),
                                          Text(
                                              "${context.loc.followupDuration} : ${_clinic.followup_duration}"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<void>(
                                      tooltip: context.loc.settings,
                                      icon: const Icon(Icons.settings),
                                      shadowColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(8),
                                      ),
                                      style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        elevation: WidgetStatePropertyAll(6),
                                        shadowColor:
                                            WidgetStatePropertyAll(Colors.grey),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.orange.shade300),
                                        foregroundColor: WidgetStatePropertyAll(
                                            Colors.white),
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
                                                Text(
                                                  context
                                                      .loc.toogleClinicActivity,
                                                ),
                                              ],
                                            ),
                                            onTap: () async {
                                              await shellFunction(
                                                context,
                                                toExecute: () async {
                                                  await c
                                                      .toggleClinicActivation(
                                                          _clinic);
                                                },
                                              );
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.calendar_month),
                                                Text(
                                                  context.loc.clinicSchedule,
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.watch_later),
                                                Text(
                                                  context.loc.deleteClinic,
                                                ),
                                              ],
                                            ),
                                            onTap: () async {
                                              final _toDelete =
                                                  await showDialog<bool?>(
                                                context: context,
                                                builder: (context) {
                                                  return PromptDialog(
                                                      message: context.loc
                                                          .deleteClinicPrompt);
                                                },
                                              );
                                              if (_toDelete == null ||
                                                  !_toDelete) {
                                                return;
                                              }

                                              if (context.mounted) {
                                                await shellFunction(
                                                  context,
                                                  toExecute: () async {
                                                    await c
                                                        .deleteClinic(_clinic);
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ];
                                      },
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
              ],
            ),
          ),
        );
      },
    );
  }
}
