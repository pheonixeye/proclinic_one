import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/doctor_items/doctor_drug_item.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class AddDrugsToVisitDialog extends StatefulWidget {
  const AddDrugsToVisitDialog({
    super.key,
    required this.drugs_ids,
  });
  final List<String> drugs_ids;

  @override
  State<AddDrugsToVisitDialog> createState() => _AddDrugsToVisitDialogState();
}

class _AddDrugsToVisitDialogState extends State<AddDrugsToVisitDialog> {
  List<String> _state = [];

  @override
  void initState() {
    _state = widget.drugs_ids;
    // print(_state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctorProfileItems<DoctorDrugItem>, PxLocale>(
      builder: (context, p, l, _) {
        while (p.data == null) {
          return const CentralLoading();
        }
        final _items =
            (p.filteredData as ApiDataResult<List<DoctorDrugItem>>).data;
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '${context.loc.add} ${context.loc.visitDrugs}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: context.visitItemDialogWidth,
            height: context.visitItemDialogHeight,
            child: Column(
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.doctorDrugs),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: context.loc.search,
                            ),
                            onChanged: (value) {
                              //todo: filter drugs
                              p.searchForItems(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FloatingActionButton.small(
                            tooltip: context.loc.clearSearch,
                            heroTag: 'clear-doctor-drugs-filter',
                            backgroundColor: Colors.red.shade300,
                            onPressed: () {
                              p.clearSearch();
                            },
                            child: const Icon(Icons.refresh_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final _item = _items[index];
                      return Card.outlined(
                        elevation: 6,
                        child: CheckboxListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: FloatingActionButton.small(
                                    heroTag: '$_item _ ${index * index}',
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
                              ],
                            ),
                          ),
                          value: _state.contains(_item.id),
                          onChanged: (value) {
                            if (_state.contains(_item.id)) {
                              setState(() {
                                _state.remove(_item.id);
                              });
                            } else {
                              setState(() {
                                _state.add(_item.id);
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context, _state);
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
