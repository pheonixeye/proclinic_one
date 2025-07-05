import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/doctor_items/doctor_drug_item.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_data.dart';
import 'package:provider/provider.dart';

enum DrugCardState {
  saved_dose(
    en: 'From Saved Doses',
    ar: 'من الجرعات المسجلة',
  ),
  new_dose(
    en: 'Prescribe New Dose',
    ar: 'كتابة جرعة جديدة',
  );

  final String en;
  final String ar;

  const DrugCardState({required this.en, required this.ar});
}

class DrugDoseViewEditCard extends StatefulWidget {
  const DrugDoseViewEditCard({
    super.key,
    required this.item,
    required this.index,
    this.dose,
  });
  final DoctorDrugItem item;
  final int index;
  final String? dose;

  @override
  State<DrugDoseViewEditCard> createState() => _DrugDoseViewEditCardState();
}

class _DrugDoseViewEditCardState extends State<DrugDoseViewEditCard> {
  final formKey = GlobalKey<FormState>();
  DrugCardState? _state;
  String? _drugSavedDose;
  String? _drugNewDose;

  @override
  void initState() {
    super.initState();
    if (widget.item.default_doses.contains(widget.dose)) {
      _drugSavedDose = widget.dose;
    } else {
      _drugNewDose = widget.dose;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxDoctorProfileItems<DoctorDrugItem>, PxVisitData,
        PxLocale>(
      builder: (context, p, v, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              showTrailingIcon: false,
              title: Row(
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
                      l.isEnglish
                          ? widget.item.prescriptionNameEn
                          : widget.item.prescriptionNameAr,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FloatingActionButton.small(
                      tooltip: context.loc.delete,
                      heroTag: 'delete_drug_${widget.item.id}',
                      backgroundColor: Colors.red.shade200,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await v.removeDrugsFromVisit(
                              [widget.item.id],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.delete_forever),
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.amber.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(context.loc.drugDose),
                    ),
                    subtitle: Row(
                      children: [
                        ...DrugCardState.values.map((e) {
                          final _isSelected = _state == e;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: RadioListTile(
                                selected: _isSelected,
                                selectedTileColor: Colors.blue.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: _isSelected
                                      ? BorderSide()
                                      : BorderSide.none,
                                ),
                                title: Text(l.isEnglish ? e.en : e.ar),
                                value: e,
                                onChanged: (value) {
                                  setState(() {
                                    _state = value;
                                  });
                                },
                                groupValue: _state,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                if (_state == DrugCardState.saved_dose)
                  ...widget.item.default_doses.map((x) {
                    return RadioListTile(
                      title: Text(x),
                      value: x,
                      groupValue: _drugSavedDose,
                      onChanged: (value) async {
                        setState(() {
                          _drugSavedDose = value;
                        });
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await v.setDrugDose(
                              widget.item.id,
                              _drugSavedDose!,
                            );
                          },
                        );
                      },
                    );
                  })
                else if (_state == DrugCardState.new_dose)
                  //TODO: formulate a point & click ui
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _drugNewDose,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText:
                                    '${context.loc.enter} ${context.loc.drugDose}',
                              ),
                              maxLines: 3,
                              onChanged: (value) {
                                setState(() {
                                  _drugNewDose = value;
                                });
                              },
                              validator: (value) {
                                if (_drugNewDose == null ||
                                    _drugNewDose!.isEmpty) {
                                  return '${context.loc.enter} ${context.loc.drugDose}';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FloatingActionButton.small(
                              tooltip: context.loc.saveToDefaultDoses,
                              heroTag: '${widget.item.id}-save-to-favorites',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      final _toUpdateDrug =
                                          widget.item.copyWith(
                                        default_doses: [
                                          ...widget.item.default_doses,
                                          _drugNewDose!
                                        ],
                                      );
                                      await p
                                          .updateItem(_toUpdateDrug.toJson());
                                    },
                                  );
                                }
                              },
                              child: const Icon(Icons.favorite),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FloatingActionButton.small(
                              tooltip: context.loc.save,
                              heroTag: '${widget.item.id}-save-drug-dose',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      //todo
                                      await v.setDrugDose(
                                        widget.item.id,
                                        _drugNewDose!,
                                      );
                                    },
                                  );
                                }
                              },
                              child: const Icon(Icons.save),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
