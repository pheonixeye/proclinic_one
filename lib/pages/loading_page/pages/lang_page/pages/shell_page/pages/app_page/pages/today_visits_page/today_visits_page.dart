import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/clinic/clinic.dart';
import 'package:proklinik_one/models/visits/_visit.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/clinics_tab_bar.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visits.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class TodayVisitsPage extends StatefulWidget {
  const TodayVisitsPage({super.key});

  @override
  State<TodayVisitsPage> createState() => _TodayVisitsPageState();
}

class _TodayVisitsPageState extends State<TodayVisitsPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisits, PxClinics, PxLocale>(
      builder: (context, v, c, l, _) {
        while (c.result == null) {
          return const CentralLoading();
        }

        while ((c.result as ApiDataResult<List<Clinic>>).data.isEmpty) {
          return CentralNoItems(
            message: context.loc.noClinicsFound,
          );
        }

        final _clinics = (c.result as ApiDataResult<List<Clinic>>).data;

        final _tabController =
            v.getTabController(length: _clinics.length, vsync: this);

        return Scaffold(
          body: Column(
            children: [
              Stack(
                children: [
                  ClinicsTabBar(
                    clinics: _clinics,
                    controller: _tabController,
                  ),
                  if (v.isUpdating)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (v.visits == null) {
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
                    return TabBarView(
                      controller: _tabController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        ...(c.result as ApiDataResult<List<Clinic>>)
                            .data
                            .map((x) {
                          final _clinicItems =
                              _items.where((e) => e.clinic.id == x.id).toList();

                          while (_clinicItems.isEmpty) {
                            return CentralNoItems(
                                message: context.loc.noVisitsFoundForToday);
                          }

                          return ListView.builder(
                            itemCount: _clinicItems.length,
                            itemBuilder: (context, index) {
                              final _item = _clinicItems[index];
                              return VisitViewCard(
                                visit: _item,
                                index: index,
                              );
                            },
                          );
                        })
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-new-visit-nav',
            tooltip: context.loc.addNewVisit,
            onPressed: () {
              GoRouter.of(context).goNamed(
                AppRouter.patients,
                pathParameters: defaultPathParameters(context),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
