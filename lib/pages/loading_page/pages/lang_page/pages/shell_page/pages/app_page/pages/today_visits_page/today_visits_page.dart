import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visits.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class TodayVisitsPage extends StatelessWidget {
  const TodayVisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<PxVisits, PxLocale>(
        builder: (context, v, l, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.todayVisits),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (v.visits == null || v.visits == null) {
                      return const CentralLoading();
                    }

                    while (v.visits is ApiErrorResult) {
                      return CentralError(
                        code:
                            (v.visits as ApiErrorResult<List<Visit>>).errorCode,
                        toExecute: v.retry,
                      );
                    }

                    while (v.visits != null &&
                        (v.visits is ApiDataResult) &&
                        (v.visits as ApiDataResult<List<Visit>>).data.isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noVisitsFoundForToday,
                      );
                    }
                    final _items =
                        (v.visits as ApiDataResult<List<Visit>>).data;
                    return ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _item = _items[index];
                        return ListTile(
                          title: Text(_item.visit_date.toIso8601String()),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
