import 'package:flutter/material.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_doc_subscription_info.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class SelectSubscriptionDialog extends StatefulWidget {
  const SelectSubscriptionDialog({super.key});

  @override
  State<SelectSubscriptionDialog> createState() =>
      _SelectSubscriptionDialogState();
}

class _SelectSubscriptionDialogState extends State<SelectSubscriptionDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxDocSubscriptionInfo, PxLocale>(
      builder: (context, a, s, l, _) {
        while (a.constants == null || s.result == null) {
          return const CentralLoading();
        }
        return AlertDialog();
      },
      //TODO:
    );
  }
}
