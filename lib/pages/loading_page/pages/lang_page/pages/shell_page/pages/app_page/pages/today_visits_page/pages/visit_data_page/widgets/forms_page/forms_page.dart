import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/pc_form.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/forms_page/form_picker_dialog.dart';
import 'package:proklinik_one/providers/px_forms.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_data.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:proklinik_one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class VisitFormsPage extends StatelessWidget {
  const VisitFormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisitData, PxForms, PxLocale>(
      builder: (context, v, f, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (f.result == null || v.result == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult) {
                return CentralError(
                  code: (f.result as ApiErrorResult).errorCode,
                  toExecute: f.retry,
                );
              }
              while (
                  (v.result as ApiDataResult<VisitData>).data.forms.isEmpty) {
                return CentralNoItems(
                  message: context.loc.noItemsFound,
                );
              }
              final _items = (v.result as ApiDataResult<VisitData>).data.forms;
              return ListView.builder(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FloatingActionButton.small(
                                heroTag: _item,
                                onPressed: null,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                l.isEnglish ? _item.name_en : _item.name_ar,
                              ),
                            ),
                            FloatingActionButton.small(
                              tooltip: context.loc.deleteForm,
                              backgroundColor: Colors.red.shade200,
                              heroTag: 'detach$_item',
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
                                    toExecute: (context) async {
                                      await v.detachForm(_item.id);
                                    },
                                  );
                                }
                              },
                              child: const Icon(Icons.delete_forever),
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
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-form-to-visit',
            tooltip: context.loc.addNewForm,
            onPressed: () async {
              final _form = await showDialog<PcForm?>(
                context: context,
                builder: (context) {
                  return const FormPickerDialog();
                },
              );
              if (_form == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await v.attachForm(_form.id);
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
