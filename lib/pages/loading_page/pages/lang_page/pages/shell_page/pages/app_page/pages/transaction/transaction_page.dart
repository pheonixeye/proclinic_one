import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({
    super.key,
    required this.transactionResult,
  });
  final Map<String, dynamic> transactionResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 12,
          children: [
            Text('transaction result\n'),
            Text(
              transactionResult.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
