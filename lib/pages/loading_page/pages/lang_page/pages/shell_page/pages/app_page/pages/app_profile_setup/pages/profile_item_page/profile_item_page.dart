import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/doctor_items/_doctor_item.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/dialogs/doctor_item_create_edit_dialog.dart';
import 'package:proklinik_one/extensions/profile_setup_item_ext.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/profile_item_page/widgets/doctor_item_view_card.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class ProfileItemPage extends StatefulWidget {
  const ProfileItemPage({
    super.key,
    //drugs-labs-rads-procedures-supplies
    required this.profileSetupItem,
  });
  final ProfileSetupItem profileSetupItem;

  @override
  State<ProfileItemPage> createState() => _ProfileItemPageState();
}

class _ProfileItemPageState extends State<ProfileItemPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctorProfileItems, PxLocale>(
      builder: (context, i, l, _) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton.small(
                            tooltip: context.loc.back,
                            heroTag: '${widget.profileSetupItem.name}pop',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Text(widget.profileSetupItem.pageTitleName(context)),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    context.loc.searchByEnglishOrArabicItemName,
                              ),
                              controller: _controller,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  i.clearSearch();
                                }
                                i.searchForItems(value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FloatingActionButton.small(
                            tooltip: context.loc.clearSearch,
                            heroTag:
                                '${widget.profileSetupItem.name}clear-search',
                            onPressed: () {
                              i.clearSearch();
                              _controller.clear();
                            },
                            backgroundColor: Colors.red.shade300,
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    subtitle: const Divider(),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      while (i.data == null) {
                        return const CentralLoading();
                      }

                      while (i.data is ApiErrorResult) {
                        return CentralError(
                          code: (i.data as ApiErrorResult).errorCode,
                          toExecute: i.retry,
                        );
                      }

                      while (i.data != null &&
                          (i.data is ApiDataResult) &&
                          (i.data as ApiDataResult<List<DoctorItem>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message:
                              '${context.loc.noItemsFound}\n(${widget.profileSetupItem.pageTitleName(context)})',
                        );
                      }
                      final _items =
                          (i.filteredData as ApiDataResult<List<DoctorItem>>)
                              .data;
                      return ListView.builder(
                        itemCount: _items.length,
                        cacheExtent: 3000,
                        itemBuilder: (context, index) {
                          final _profileItem = _items[index];
                          return DoctorItemViewCard(
                            item: _profileItem,
                            index: index,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag:
                'add${widget.profileSetupItem.actionButtonTooltip(context)}',
            tooltip: widget.profileSetupItem.actionButtonTooltip(context),
            onPressed: () async {
              final _doctorItemJson = await showDialog<Map<String, dynamic>?>(
                context: context,
                builder: (context) {
                  return DoctorItemCreateEditDialog(
                    type: widget.profileSetupItem,
                    item: null,
                  );
                },
              );
              if (_doctorItemJson == null) {
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await i.addNewItem(_doctorItemJson);
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
