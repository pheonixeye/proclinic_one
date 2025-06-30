import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/app_constants/subscription_plan.dart';
import 'package:proklinik_one/models/doctor_subscription.dart';
import 'package:proklinik_one/models/x_pay/x_pay_direct_order_request.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/widgets/billing_address_input_dialog.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/widgets/select_subscription_dialog.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/widgets/subscription_details_card.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_doc_subscription_info.dart';
import 'package:proklinik_one/providers/px_doctor.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:proklinik_one/widgets/central_no_items.dart';
import 'package:proklinik_one/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

class MySubscriptionPage extends StatelessWidget {
  const MySubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxDocSubscriptionInfo, PxAppConstants, PxDoctor, PxLocale>(
      builder: (context, s, a, d, l, _) {
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
                        if ((s.hasNoAciveSubscriptions &&
                                !s.hasAciveSubscriptions) ||
                            s.hasGracePeriodSubscription) ...[
                          Expanded(
                            flex: context.isMobile ? 2 : 1,
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
                          if (!context.isMobile) const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FloatingActionButton.small(
                              heroTag: 'purchase-subscription',
                              tooltip: context.loc.purchaseSubscription,
                              onPressed: () async {
                                if (s.hasAciveSubscriptions) {
                                  showDialog<void>(
                                    context: context,
                                    builder: (context) {
                                      return ErrorDialog(
                                        message: context
                                            .loc.errorOneSubscriptionIsActive,
                                      );
                                    },
                                  );
                                  return;
                                }
                                final _plan =
                                    await showDialog<SubscriptionPlan?>(
                                  context: context,
                                  builder: (context) {
                                    return SelectSubscriptionDialog();
                                  },
                                );
                                if (_plan == null) {
                                  return;
                                }
                                if (context.mounted) {
                                  final billing_address =
                                      await showDialog<String?>(
                                    context: context,
                                    builder: (context) {
                                      return const BillingAddressInputDialog();
                                    },
                                  );
                                  if (billing_address == null) {
                                    return;
                                  }
                                  final _xPayRequest = XPayDirectOrderRequest
                                      .fromApplicationData(
                                    doctor: d.doctor!,
                                    plan: _plan,
                                    billing_address: billing_address,
                                  );
                                  if (context.mounted) {
                                    GoRouter.of(context).goNamed(
                                      AppRouter.orderdetails,
                                      pathParameters:
                                          defaultPathParameters(context),
                                      extra: {
                                        'request': _xPayRequest,
                                        'doctor': d.doctor,
                                        'plan': _plan,
                                      },
                                    );
                                  }
                                }
                              },
                              child: const Icon(Icons.battery_saver_rounded),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
                        code: (s.result
                                as ApiErrorResult<List<DoctorSubscription>>)
                            .errorCode,
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
                    _items.sort((a, b) => a.inGracePeriod ? 0 : 1);
                    _items.sort(
                        (a, b) => a.subscription_status == 'active' ? 0 : 1);
                    return ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _sub = _items[index];
                        return SubscriptionDetailsCard(
                          sub: _sub,
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
