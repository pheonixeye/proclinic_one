import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/assets/assets.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/x_pay/x_pay_response.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/pages/order_details_page/order_details_page.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:web/web.dart' as web;

class BottomResultSheet extends StatelessWidget {
  const BottomResultSheet({
    super.key,
    required this.state,
    required this.xPayResponse,
    required this.modalHeight,
  });
  final DetailsPageState state;
  final XPayResponse xPayResponse;
  final double modalHeight;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      onClosing: () {
        GoRouter.of(context).goNamed(
          AppRouter.mysubscription,
          pathParameters: defaultPathParameters(context),
        );
      },
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
          ),
          height: modalHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card.outlined(
              color: Colors.white.withValues(alpha: 0.7),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      if (state == DetailsPageState.hasError)
                        Image.asset(
                          AppAssets.errorIcon,
                          width: 50,
                          height: 50,
                        ),
                      if (state == DetailsPageState.hasResult)
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.check,
                            color: Colors.green.shade100,
                            size: 48,
                          ),
                        ),
                      Text(
                        xPayResponse.data.message,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              web.window.open(
                                xPayResponse.data.payment_url,
                                '_self',
                              );
                            },
                            label: Text(context.loc.paymentLink),
                            icon: Icon(
                              Icons.monetization_on,
                              color: Colors.green.shade100,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: Text(context.loc.cancel),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
