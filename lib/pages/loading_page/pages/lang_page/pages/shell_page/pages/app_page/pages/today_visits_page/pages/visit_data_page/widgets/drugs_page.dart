import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_data.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitDrugsPage extends StatelessWidget {
  const VisitDrugsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (v.result == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: v.retry,
                );
              }
              while (
                  (v.result as ApiDataResult<VisitData>).data.drugs.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: (v.result as ApiDataResult<VisitData>)
                            .data
                            .patient
                            .id,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (v.result as ApiDataResult<VisitData>)
                                  .data
                                  .patient
                                  .name,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: CentralNoItems(
                          message: context.loc.noItemsFound,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: (v.result as ApiDataResult<VisitData>)
                          .data
                          .patient
                          .id,
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (v.result as ApiDataResult<VisitData>)
                                .data
                                .patient
                                .name,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
