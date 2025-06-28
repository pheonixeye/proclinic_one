import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/x-pay/x_pay_api.dart';
import 'package:proklinik_one/models/app_constants/subscription_plan.dart';
import 'package:proklinik_one/models/doctor.dart';
import 'package:proklinik_one/models/x_pay/x_pay_direct_order_request.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_doctor.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class BookkeepingPage extends StatefulWidget {
  const BookkeepingPage({super.key});

  @override
  State<BookkeepingPage> createState() => _BookkeepingPageState();
}

class _BookkeepingPageState extends State<BookkeepingPage> {
  XPayDirectOrderRequest? _request;
  Doctor? _doctor;
  SubscriptionPlan? _plan;

  final _api = XPayApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<PxAppConstants>(
                builder: (context, c, _) {
                  while (c.constants == null) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Constants are Still null'),
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                  _doctor = context.read<PxDoctor>().doctor;
                  _plan = context.read<PxAppConstants>().annual;
                  final _email = context
                      .read<PxAuth>()
                      .authModel!
                      .record
                      .toJson()['email'] as String;
                  _request = XPayDirectOrderRequest.fromApplicationData(
                    doctor: _doctor!,
                    plan: _plan!,
                    billing_address: 'Zahraa El-Maadi, El Nada Tower',
                    doctor_email: _email,
                  );
                  return FutureBuilder<Map<String, dynamic>>(
                    future: _api.pay(_request!),
                    builder: (context, asyncSnapshot) {
                      while (asyncSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          asyncSnapshot.connectionState ==
                              ConnectionState.active ||
                          asyncSnapshot.data == null) {
                        return CentralLoading();
                      }
                      final _url =
                          asyncSnapshot.requireData['data']['payment_url'];
                      return Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Payment Url',
                            children: [
                              TextSpan(text: '\n'),
                              TextSpan(
                                text: _url,
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    web.window.open(_url, '_self');
                                  },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
