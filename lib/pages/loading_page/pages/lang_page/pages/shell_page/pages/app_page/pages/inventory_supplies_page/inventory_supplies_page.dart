import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/extensions/number_translator.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/supplies/supply_movement.dart';
import 'package:proklinik_one/models/supplies/supply_movement_dto.dart';
import 'package:proklinik_one/models/supplies/supply_movement_type.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/inventory_supplies_page/widgets/supply_movement_dialog.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_supply_movements.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class InventorySuppliesPage extends StatefulWidget {
  const InventorySuppliesPage({super.key});

  @override
  State<InventorySuppliesPage> createState() => _InventorySuppliesPageState();
}

class _InventorySuppliesPageState extends State<InventorySuppliesPage> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    final _s = context.read<PxSupplyMovements>();
    final _l = context.read<PxLocale>();
    _fromController = TextEditingController(
        text: DateFormat('yyyy-MM-dd', _l.lang).format(_s.from));
    _toController = TextEditingController(
        text: DateFormat('yyyy-MM-dd', _l.lang).format(_s.to));
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Change to table layout
    return Consumer2<PxSupplyMovements, PxLocale>(
      builder: (context, s, l, _) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.supplyItemsMovement),
                  ),
                  subtitle: const Divider(),
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Text(context.loc.from),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _fromController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton.small(
                          heroTag: UniqueKey(),
                          tooltip: context.loc.pickStartingDate,
                          onPressed: () async {
                            final _from = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now().copyWith(
                                year: DateTime.now().year - 5,
                              ),
                              lastDate: DateTime.now(),
                            );
                            if (_from != null) {
                              _fromController.text =
                                  DateFormat('yyyy-MM-dd', l.lang)
                                      .format(_from);
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await s.changeDate(
                                      from: _from,
                                      to: s.to,
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: const Icon(Icons.calendar_month_rounded),
                        ),
                        Text(context.loc.to),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _toController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton.small(
                          tooltip: context.loc.pickEndingDate,
                          heroTag: UniqueKey(),
                          onPressed: () async {
                            final _to = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now().copyWith(
                                year: DateTime.now().year - 5,
                              ),
                              lastDate: DateTime.now(),
                            );
                            if (_to != null) {
                              _toController.text =
                                  DateFormat('yyyy-MM-dd', l.lang).format(_to);
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await s.changeDate(
                                      from: s.from,
                                      to: _to,
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: const Icon(Icons.calendar_month_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (s.result == null) {
                      return const CentralLoading();
                    }

                    while (s.result is ApiErrorResult) {
                      return CentralError(
                        code: (s.result as ApiErrorResult).errorCode,
                        toExecute: s.retry,
                      );
                    }

                    while (s.result != null &&
                        (s.result is ApiDataResult) &&
                        (s.result as ApiDataResult<List<SupplyMovement>>)
                            .data
                            .isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noSupplyMovementsFound,
                      );
                    }
                    final _items =
                        (s.result as ApiDataResult<List<SupplyMovement>>).data;
                    return ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _item = _items[index];
                        final _supplyItemMovementType =
                            SupplyMovementType.fromString(_item.movement_type);
                        return Card.outlined(
                          elevation: 6,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
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
                                  Text(
                                    l.isEnglish
                                        ? _item.supply_item.name_en
                                        : _item.supply_item.name_ar,
                                  ),
                                  Tooltip(
                                    message: l.isEnglish
                                        ? _supplyItemMovementType.en
                                        : _supplyItemMovementType.ar,
                                    child: Icon(
                                      switch (_supplyItemMovementType) {
                                        SupplyMovementType.OUT_IN =>
                                          Icons.arrow_downward,
                                        SupplyMovementType.IN_OUT =>
                                          Icons.arrow_upward,
                                        SupplyMovementType.IN_IN =>
                                          Icons.compare_arrows_rounded,
                                      },
                                      color: switch (_supplyItemMovementType) {
                                        SupplyMovementType.OUT_IN => Colors.red,
                                        SupplyMovementType.IN_OUT =>
                                          Colors.green,
                                        SupplyMovementType.IN_IN => Colors.blue,
                                      },
                                    ),
                                  ),
                                  Text(
                                    '(${_item.reason})',
                                  ),
                                  Text(
                                    '(${l.isEnglish ? _item.clinic.name_en : _item.clinic.name_ar})',
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 65.0,
                                ),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Tooltip(
                                      message: _item.added_by.email,
                                      child: const Icon(Icons.person),
                                    ),
                                    Column(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${context.loc.movementAmount} : ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '(${_item.movement_amount}) ${context.loc.egp}'
                                                  .toArabicNumber(context),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${context.loc.movementQuantity} : ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '(${_item.movement_quantity}) ${l.isEnglish ? _item.supply_item.unit_en : _item.supply_item.unit_ar}'
                                                  .toArabicNumber(context),
                                            ),
                                          ],
                                        ),
                                      ],
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
          floatingActionButton: FloatingActionButton.small(
            heroTag: UniqueKey(),
            tooltip: context.loc.newSupplyMovement,
            onPressed: () async {
              final _dtos = await showDialog<List<SupplyMovementDto?>?>(
                context: context,
                builder: (context) {
                  return SupplyMovementDialog();
                },
              );
              if (_dtos == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await s.addSupplyMovements(_dtos);
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
