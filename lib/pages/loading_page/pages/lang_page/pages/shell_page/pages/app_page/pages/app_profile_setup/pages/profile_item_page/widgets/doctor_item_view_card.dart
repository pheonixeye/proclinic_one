import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/doctor_item_widgets_ext.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/doctor_items/_doctor_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_drug_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_lab_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_procedure_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_rad_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/dialogs/doctor_item_create_edit_dialog.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class DoctorItemViewCard extends StatelessWidget {
  const DoctorItemViewCard({
    super.key,
    required this.item,
    required this.index,
  });
  final DoctorItem item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctorProfileItems, PxLocale>(
      builder: (context, i, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              backgroundColor: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
                side: BorderSide(),
              ),
              trailing: null,
              showTrailingIcon: false,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FloatingActionButton.small(
                      heroTag: item.id,
                      onPressed: null,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l.isEnglish ? item.name_en : item.name_ar,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: FloatingActionButton.small(
                      heroTag: item.id + item.item.name,
                      onPressed: () async {
                        final _doctorItem =
                            await showDialog<Map<String, dynamic>?>(
                          context: context,
                          builder: (context) {
                            return DoctorItemCreateEditDialog(
                              type: item.item,
                              item: item,
                            );
                          },
                        );
                        if (_doctorItem == null) {
                          return;
                        }

                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await i.updateItem(_doctorItem);
                            },
                          );
                        }
                      },
                      tooltip: context.loc.update,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: FloatingActionButton.small(
                      heroTag: '${item.id}${item.item.name}delete',
                      onPressed: () async {
                        final _doctorItem = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return PromptDialog(
                              message: context.loc.deleteItemPrompt,
                            );
                          },
                        );
                        if (_doctorItem == null || _doctorItem == false) {
                          return;
                        }

                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await i.deleteItem(item);
                            },
                          );
                        }
                      },
                      tooltip: context.loc.delete,
                      backgroundColor: Colors.red.shade300,
                      child: const Icon(Icons.delete_forever),
                    ),
                  ),
                ],
              ),
              children: [
                switch (i.api.item) {
                  ProfileSetupItem.drugs =>
                    (item as DoctorDrugItem).viewWidget(context),
                  ProfileSetupItem.labs =>
                    (item as DoctorLabItem).viewWidget(context),
                  ProfileSetupItem.rads =>
                    (item as DoctorRadItem).viewWidget(context),
                  ProfileSetupItem.procedures =>
                    (item as DoctorProcedureItem).viewWidget(context),
                  ProfileSetupItem.supplies =>
                    (item as DoctorSupplyItem).viewWidget(context),
                }
              ],
            ),
          ),
        );
      },
    );
  }
}
