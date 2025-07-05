import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/doctor_profile_items_api.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/doctor_items/doctor_drug_item.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/drugs_page/add_drugs_to_visit_dialog.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_data.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitDrugsPage extends StatelessWidget {
  const VisitDrugsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (v.result == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: v.retry,
                );
              }
              while (
                  (v.result as ApiDataResult<VisitData>).data.drugs.isEmpty) {
                return Column(
                  children: [
                    VisitDetailsPageInfoHeader(
                      patient:
                          (v.result as ApiDataResult<VisitData>).data.patient,
                      title: context.loc.visitDrugs,
                      iconData: FontAwesomeIcons.prescription,
                    ),
                    Expanded(
                      child: Center(
                        child: CentralNoItems(
                          message: context.loc.noItemsFound,
                        ),
                      ),
                    ),
                  ],
                );
              }
              final _items = (v.result as ApiDataResult<VisitData>).data.drugs;
              return Column(
                children: [
                  VisitDetailsPageInfoHeader(
                    patient:
                        (v.result as ApiDataResult<VisitData>).data.patient,
                    title: context.loc.visitDrugs,
                    iconData: FontAwesomeIcons.prescription,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _item = _items[index];
                        return Card.outlined(
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: FloatingActionButton.small(
                                      heroTag: UniqueKey(),
                                      onPressed: null,
                                      child: Text('${index + 1}'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      l.isEnglish
                                          ? _item.prescriptionNameEn
                                          : _item.prescriptionNameAr,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: FloatingActionButton.small(
                                      tooltip: context.loc.delete,
                                      heroTag: 'delete_drug_${_item.id}',
                                      backgroundColor: Colors.red.shade200,
                                      onPressed: () async {
                                        await shellFunction(
                                          context,
                                          toExecute: () async {
                                            await v.removeDrugsFromVisit(
                                              [_item.id],
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.delete_forever),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton.small(
            tooltip: '${context.loc.add} ${context.loc.visitDrugs}',
            heroTag: 'add-drugs-to-visit-btn',
            onPressed: () async {
              final _mappedIds = (v.result as ApiDataResult<VisitData>)
                  .data
                  .drugs
                  .map((e) => e.id)
                  .toList();
              final _newDrugItems = await showDialog<List<String>?>(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider.value(
                    key: ValueKey(ProfileSetupItem.drugs),
                    value: PxDoctorProfileItems<DoctorDrugItem>(
                      api: DoctorProfileItemsApi<DoctorDrugItem>(
                        doc_id: context.read<PxAuth>().doc_id,
                        item: ProfileSetupItem.drugs,
                      ),
                    ),
                    child: AddDrugsToVisitDialog(
                      drugs_ids: _mappedIds,
                    ),
                  );
                },
              );
              if (_newDrugItems == null || _newDrugItems.isEmpty) {
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await v.updateDrugsListInVisit(_newDrugItems);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
