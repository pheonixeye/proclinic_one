import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/extensions/number_translator.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visits_filter_header.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_filter.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitsPage extends StatelessWidget {
  const VisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitFilter, PxLocale>(
      builder: (context, v, l, _) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VisitsFilterHeader(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (v.visits == null) {
                      return CentralLoading();
                    }
                    while (v.visits is ApiErrorResult) {
                      return CentralError(
                        code: (v.visits as ApiErrorResult).errorCode,
                        toExecute: v.retry,
                      );
                    }
                    final _items =
                        (v.visits as ApiDataResult<List<Visit>>).data;
                    while (_items.isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noVisitsFoundForSelectedDateRange,
                      );
                    }
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
                                spacing: 8,
                                children: [
                                  FloatingActionButton.small(
                                    heroTag: UniqueKey(),
                                    onPressed: null,
                                    child: Text(
                                        '${index + 1}'.toArabicNumber(context)),
                                  ),
                                  Text(_item.patient.name),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    onPressed: () async {
                      await shellFunction(
                        context,
                        toExecute: () async {
                          await v.previousPage();
                        },
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text('- ${v.page} -'),
                  IconButton.outlined(
                    onPressed: () async {
                      await shellFunction(
                        context,
                        toExecute: () async {
                          await v.nextPage();
                        },
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
