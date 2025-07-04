import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/pc_form.dart';
import 'package:proklinik_one/models/pc_form_field_types.dart';
import 'package:proklinik_one/models/visit_data/visit_form_data.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_data.dart';
import 'package:proklinik_one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class VisitFormViewEditCard extends StatefulWidget {
  const VisitFormViewEditCard({
    super.key,
    required this.form,
    required this.formData,
    required this.index,
  });
  final PcForm form;
  final int index;
  final VisitFormData formData;

  @override
  State<VisitFormViewEditCard> createState() => _VisitFormViewEditCardState();
}

class _VisitFormViewEditCardState extends State<VisitFormViewEditCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
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
                      heroTag: widget.form,
                      onPressed: null,
                      child: Text('${widget.index + 1}'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l.isEnglish ? widget.form.name_en : widget.form.name_ar,
                    ),
                  ),
                  FloatingActionButton.small(
                    tooltip: context.loc.deleteForm,
                    backgroundColor: Colors.red.shade200,
                    heroTag: 'detach${widget.form.name_en}${widget.index}',
                    onPressed: () async {
                      //todo: detach Form
                      final _toDetach = await showDialog<bool?>(
                        context: context,
                        builder: (context) {
                          return PromptDialog(
                            message: context.loc.detachFormPrompt,
                          );
                        },
                      );
                      if (_toDetach == null || _toDetach == false) {
                        return;
                      }
                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await v.detachForm(widget.form.id);
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.delete_forever),
                  ),
                ],
              ),
              children: [
                ...widget.form.form_fields.map((e) {
                  return switch (e.field_type) {
                    PcFormFieldType.textfield => ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.field_name),
                        ),
                        subtitle: Builder(
                          builder: (context) {
                            final _controller = TextEditingController(
                                //TODO: change initial value
                                );
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    controller: _controller,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton.small(
                                    heroTag: e.id + e.field_type.name,
                                    onPressed: () async {},
                                    child: const Icon(Icons.save),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    PcFormFieldType.dropdown => ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.field_name),
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  items: e.values.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      alignment: Alignment.center,
                                      child: Text(
                                        e,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }).toList(),
                                  value: null, //TODO
                                  alignment: Alignment.center,
                                  onChanged: (value) async {
                                    //TODO: update values in _formItem.formData
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    PcFormFieldType.checkbox => ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.field_name),
                        ),
                        subtitle: Wrap(
                          children: [
                            ...e.values.map((e) {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(e),
                                tristate: true,
                                value: null,
                                onChanged: (val) async {
                                  //TODO:
                                },
                              );
                            })
                          ],
                        ),
                      ),
                  };
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
