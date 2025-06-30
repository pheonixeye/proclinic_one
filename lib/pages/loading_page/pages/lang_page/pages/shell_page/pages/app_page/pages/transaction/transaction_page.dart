import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/doc_sub_pay_api.dart';
import 'package:proklinik_one/extensions/after_layout.dart';
import 'package:proklinik_one/models/page_states_enum.dart';
import 'package:proklinik_one/models/x_pay/x_pay_transaction_result.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({
    super.key,
    required this.query,
  });
  final Map<String, dynamic> query;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AfterLayoutMixin {
  late final XPayTransactionResult _xPayTransactionResult;
  PageState _state = PageState.initial;

  void _updateState(PageState s) {
    setState(() {
      _state = s;
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      _xPayTransactionResult = XPayTransactionResult.fromJson(widget.query);
      _updateState(PageState.processing);
    } catch (e) {
      _updateState(PageState.hasError);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    try {
      await DocSubPayApi
          .updateSubscriptionPaymentsAndActivateDoctorSubscription(
        doc_id: context.read<PxAuth>().doc_id,
        x_pay_payment_id: _xPayTransactionResult.payment_id,
        x_pay_transaction_id: _xPayTransactionResult.transaction_id,
        x_pay_transaction_status: _xPayTransactionResult.transaction_status,
        amount: _xPayTransactionResult.total_amount,
      );

      _updateState(PageState.hasResult);
    } catch (e) {
      _updateState(PageState.hasError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      PageState.initial => throw UnimplementedError(),
      PageState.processing => throw UnimplementedError(),
      PageState.hasResult => throw UnimplementedError(),
      PageState.hasError => throw UnimplementedError(),
    };
  }
}
