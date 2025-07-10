import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_data.dart';
import 'package:provider/provider.dart';

class SupplyItemTile extends StatefulWidget {
  const SupplyItemTile({
    super.key,
    required this.item,
    required this.index,
  });
  final DoctorSupplyItem item;
  final int index;
  @override
  State<SupplyItemTile> createState() => _SupplyItemTileState();
}

class _SupplyItemTileState extends State<SupplyItemTile> {
  double quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxDoctorProfileItems<DoctorSupplyItem>, PxVisitData,
        PxLocale>(
      builder: (context, p, v, l, _) {
        while (v.result == null || p.data == null) {
          return const LinearProgressIndicator();
        }
        final _visit_data = (v.result as ApiDataResult<VisitData>).data;
        final _item_quantity =
            _visit_data.supplies_data[widget.item.id] as double? ?? 0;
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton.small(
                    heroTag: UniqueKey(),
                    onPressed: null,
                    child: Text('${widget.index + 1}'),
                  ),
                ),
                Expanded(
                  child: Text(
                    l.isEnglish ? widget.item.name_en : widget.item.name_ar,
                  ),
                ),
                Checkbox(
                  value: _visit_data.supplies.contains(widget.item),
                  onChanged: (value) async {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        if (_visit_data.supplies.contains(widget.item) ==
                            true) {
                          await v.removeFromItemList(
                            widget.item.id,
                            ProfileSetupItem.supplies,
                          );
                        } else if (_visit_data.supplies.contains(widget.item) ==
                            false) {
                          await v.addToItemList(
                            widget.item.id,
                            ProfileSetupItem.supplies,
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          subtitle: (_visit_data.supplies.contains(widget.item))
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      spacing: 16,
                      children: [
                        FloatingActionButton.small(
                          heroTag: UniqueKey(),
                          onPressed: () {
                            if (quantity <= 0) {
                              return;
                            }
                            setState(() {
                              quantity =
                                  quantity - widget.item.transfer_quantity;
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                        Text(
                            '($_item_quantity) ==>> ($quantity) ${l.isEnglish ? widget.item.unit_en : widget.item.unit_ar}'),
                        FloatingActionButton.small(
                          heroTag: UniqueKey(),
                          onPressed: () {
                            setState(() {
                              quantity =
                                  quantity + widget.item.transfer_quantity;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                //TODO:
                                if (quantity > _item_quantity) {
                                  await v.updateSupplyItemQuantity(
                                    widget.item,
                                    quantity,
                                    true,
                                  );
                                } else if (quantity < _item_quantity) {
                                  await v.updateSupplyItemQuantity(
                                    widget.item,
                                    quantity,
                                    false,
                                  );
                                }
                              },
                            );
                          },
                          label: Text(context.loc.save),
                          icon: const Icon(Icons.save),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
