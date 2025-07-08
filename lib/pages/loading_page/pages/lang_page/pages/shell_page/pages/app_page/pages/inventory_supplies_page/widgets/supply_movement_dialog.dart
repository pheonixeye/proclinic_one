import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/clinic/clinic.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/supplies/supply_movement.dart';
import 'package:proklinik_one/models/supplies/supply_movement_dto.dart';
import 'package:proklinik_one/models/supplies/supply_movement_type.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class SupplyMovementDialog extends StatefulWidget {
  const SupplyMovementDialog({
    super.key,
    this.supplyMovement,
  });
  final SupplyMovement? supplyMovement;

  @override
  State<SupplyMovementDialog> createState() => _SupplyMovementDialogState();
}

class _SupplyMovementDialogState extends State<SupplyMovementDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _movement_amount_controller;
  DoctorSupplyItem? _supplyItem;
  Clinic? _clinic;
  String? _reason;
  double? _movement_amount;
  double? _movement_quantity;
  String? _movement_type;

  @override
  void initState() {
    super.initState();
    _supplyItem = widget.supplyMovement?.supply_item;
    _clinic = widget.supplyMovement?.clinic;
    _reason = widget.supplyMovement?.reason;
    _movement_amount = widget.supplyMovement?.movement_amount;
    _movement_amount_controller = TextEditingController(
      text: _movement_amount?.toString() ?? '',
    );
    _movement_quantity = widget.supplyMovement?.movement_quantity;
    _movement_type = widget.supplyMovement?.movement_type;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxClinics, PxDoctorProfileItems<DoctorSupplyItem>,
        PxLocale>(
      builder: (context, c, s, l, _) {
        while (c.result == null || s.data == null) {
          return const CentralLoading();
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: widget.supplyMovement == null
                    ? Text(context.loc.newSupplyMovement)
                    : Text(context.loc.editSupplyMovement),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton.outlined(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: Form(
            key: formKey,
            child: Column(
              spacing: 8,
              children: [
                ListTile(
                  title: Text(context.loc.pickClinic),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<Clinic>(
                            items: (c.result as ApiDataResult<List<Clinic>>)
                                .data
                                .map((e) {
                              return DropdownMenuItem<Clinic>(
                                alignment: Alignment.center,
                                value: e,
                                child: Text(
                                  l.isEnglish ? e.name_en : e.name_ar,
                                ),
                              );
                            }).toList(),
                            alignment: Alignment.center,
                            onChanged: (val) {
                              setState(() {
                                _clinic = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(context.loc.pickSupplyItem),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<DoctorSupplyItem>(
                            items: (s.data
                                    as ApiDataResult<List<DoctorSupplyItem>>)
                                .data
                                .map((e) {
                              return DropdownMenuItem<DoctorSupplyItem>(
                                alignment: Alignment.center,
                                value: e,
                                child: Text(
                                  l.isEnglish ? e.name_en : e.name_ar,
                                ),
                              );
                            }).toList(),
                            alignment: Alignment.center,
                            onChanged: (val) {
                              setState(() {
                                _supplyItem = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(context.loc.movementDirection),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            items: SupplyMovementType.values.map((e) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: e.en.toLowerCase(),
                                child: Text(
                                  l.isEnglish ? e.en.toUpperCase() : e.ar,
                                ),
                              );
                            }).toList(),
                            alignment: Alignment.center,
                            onChanged: (val) {
                              setState(() {
                                _movement_type = val;
                                _movement_quantity = null;
                                _movement_amount = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(context.loc.movementReason),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: context.loc.enterMovementReason,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _reason = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(context.loc.movementQuantity),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: context.loc.enterMovementQuantity,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            setState(() {
                              _movement_quantity = double.parse(value);
                            });
                            if (_supplyItem != null &&
                                _movement_quantity != null) {
                              _movement_amount_controller.text =
                                  switch (_movement_type) {
                                'in' => (-_supplyItem!.buying_price *
                                        _movement_quantity!)
                                    .toString(),
                                'out' => (_supplyItem!.selling_price *
                                        _movement_quantity!)
                                    .toString(),
                                _ => '',
                              };
                              _movement_amount = double.parse(
                                  _movement_amount_controller.text);
                            }
                          },
                        ),
                      ),
                      if (_supplyItem != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            l.isEnglish
                                ? _supplyItem!.unit_en
                                : _supplyItem!.unit_ar,
                          ),
                        ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(context.loc.movementAmount),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _movement_amount_controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: context.loc.enterMovementAmount,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          enabled: false,
                        ),
                      ),
                      if (_supplyItem != null && _movement_quantity != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(context.loc.egp),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final _supplyMovementDto = SupplyMovementDto(
                    id: '',
                    clinic_id: _clinic?.id ?? '',
                    supply_item_id: _supplyItem?.id ?? '',
                    movement_type: _movement_type ?? '',
                    related_visit_id: widget.supplyMovement?.visit?.id ?? '',
                    reason: _reason ?? '',
                    added_by_id: context.read<PxAuth>().doc_id,
                    movement_amount: _movement_amount ?? 0.0,
                    movement_quantity: _movement_quantity ?? 0.0,
                    auto_add: false,
                    updated_by_id: '',
                    number_of_updates: 0,
                  );
                  Navigator.pop(context, _supplyMovementDto);
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(
                Icons.check,
                color: Colors.green.shade100,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
