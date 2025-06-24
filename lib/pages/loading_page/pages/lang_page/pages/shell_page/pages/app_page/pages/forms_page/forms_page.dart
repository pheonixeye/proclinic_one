import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/api_result_mapper.dart';
import 'package:proklinik_one/models/pc_form.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/forms_page/widgets/create_edit_form_dialog.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/forms_page/widgets/form_view_edit_card.dart';
import 'package:proklinik_one/providers/px_forms.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class FormsPage extends StatelessWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxForms>(
      builder: (context, f, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-new-form',
            onPressed: () async {
              //todo: add new form Dialog
              final _form = await showDialog<PcForm?>(
                context: context,
                builder: (context) {
                  return const CreateEditFormDialog();
                },
              );
              if (_form == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    //todo:
                    await f.createPcForm(_form);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.forms),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (f.result == null) {
                      return const CentralLoading();
                    }

                    while (f.result is ApiErrorResult) {
                      return CentralError(
                        code: (f.result as ApiErrorResult).errorCode,
                        toExecute: f.retry,
                      );
                    }
                    while (f.result != null &&
                        (f.result as FormDataResult).data.isEmpty) {
                      return Center(
                        child: Card.outlined(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(context.loc.noFormsFound),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: (f.result! as FormDataResult).data.length,
                      itemBuilder: (context, index) {
                        final item = (f.result! as FormDataResult).data[index];
                        return FormViewEditCard(
                          pcForm: item,
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
