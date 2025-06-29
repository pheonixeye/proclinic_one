import 'package:flutter/material.dart';
import 'package:proklinik_one/models/x_pay/x_pay_direct_order_request.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.request});
  final XPayDirectOrderRequest request;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(request.toString()),
      ),
    );
  }
}
