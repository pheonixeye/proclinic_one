import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/doctor_subscription.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_doc_subscription_info.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class MySubscriptionPage extends StatelessWidget {
  const MySubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxDocSubscriptionInfo, PxAppConstants, PxLocale>(
      builder: (context, s, a, l, _) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(context.loc.mySubscription),
                        ),
                        if (s.hasNoAciveSubscriptions ||
                            s.hasGracePeriodSubscription) ...[
                          Expanded(
                            flex: 2,
                            child: Card(
                              elevation: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.warning_rounded,
                                      color: s.hasGracePeriodSubscription
                                          ? Colors.amber
                                          : Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    AnimatedTextKit(
                                      animatedTexts: [
                                        FlickerAnimatedText(
                                          s.hasGracePeriodSubscription
                                              ? context.loc.inGracePeriod
                                              : context
                                                  .loc.noActiveSubscriptions,
                                        ),
                                      ],
                                      repeatForever: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FloatingActionButton.small(
                              heroTag: 'purchase-subscription',
                              tooltip: context.loc.purchaseSubscription,
                              onPressed: () async {},
                              child: const Icon(Icons.battery_saver_rounded),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (s.result == null || a.constants == null) {
                      return const CentralLoading();
                    }

                    while (s.result is ApiErrorResult) {
                      return CentralError(
                        code: (s.result as ApiErrorResult).errorCode,
                        toExecute: s.retry,
                      );
                    }

                    while (s.result != null &&
                        (s.result is ApiDataResult) &&
                        (s.result as ApiDataResult<List<DoctorSubscription>>)
                            .data
                            .isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noSubscriptionsFound,
                      );
                    }
                    final _items =
                        (s.result as ApiDataResult<List<DoctorSubscription>>)
                            .data;
                    _items.sort(
                        (a, b) => a.subscription_status == 'active' ? 0 : 1);
                    _items.sort((a, b) => a.inGracePeriod ? 0 : 1);
                    return ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _sub = _items[index];
                        if (_sub.subscription_status == 'active') {
                          return Card.filled(
                            elevation: 6,
                            color: Colors.amber.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.loc.currentPlan,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: FloatingActionButton.small(
                                          heroTag: _sub,
                                          onPressed: null,
                                        ),
                                        titleAlignment:
                                            ListTileTitleAlignment.top,
                                        title: Builder(
                                          builder: (context) {
                                            final _plan = a
                                                .constants?.subscriptionPlan
                                                .firstWhereOrNull((e) =>
                                                    _sub.plan_id == e.id);
                                            if (_plan == null) {
                                              return const SizedBox();
                                            }
                                            return Text(
                                              l.isEnglish
                                                  ? _plan.name_en
                                                  : _plan.name_ar,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            );
                                          },
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            spacing: 8,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  text: context
                                                      .loc.subscriptionStatus,
                                                  children: [
                                                    TextSpan(text: ' : '),
                                                    TextSpan(
                                                      text:
                                                          '(${_sub.subscription_status.toUpperCase()})',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: context
                                                      .loc.activationDate,
                                                  children: [
                                                    TextSpan(text: ' : '),
                                                    TextSpan(
                                                      text: DateFormat(
                                                              'dd / MM / yyyy',
                                                              l.lang)
                                                          .format(
                                                              _sub.start_date),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: context.loc.expiryDate,
                                                  children: [
                                                    TextSpan(text: ' : '),
                                                    TextSpan(
                                                      text: DateFormat(
                                                              'dd / MM / yyyy',
                                                              l.lang)
                                                          .format(
                                                              _sub.end_date),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          final _plan =
                              a.constants!.subscriptionPlan.firstWhere(
                            (e) => e.id == _sub.plan_id,
                          );
                          return Card.outlined(
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                leading: FloatingActionButton.small(
                                  heroTag: _sub,
                                  onPressed: null,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l.isEnglish
                                              ? _plan.name_en
                                              : _plan.name_ar,
                                        ),
                                      ),
                                      if (_sub.inGracePeriod)
                                        Text(
                                          '${context.loc.inGracePeriod} (${_sub.gracePeriodRemaining}) ${context.loc.days}',
                                        ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  spacing: 8,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: context.loc.subscriptionStatus,
                                        children: [
                                          TextSpan(text: ' : '),
                                          TextSpan(
                                            text:
                                                '(${_sub.subscription_status.toUpperCase()})',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: context.loc.activationDate,
                                        children: [
                                          TextSpan(text: ' : '),
                                          TextSpan(
                                            text: DateFormat(
                                                    'dd / MM / yyyy', l.lang)
                                                .format(_sub.start_date),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: context.loc.expiryDate,
                                        children: [
                                          TextSpan(text: ' : '),
                                          TextSpan(
                                            text: DateFormat(
                                                    'dd / MM / yyyy', l.lang)
                                                .format(_sub.end_date),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
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
