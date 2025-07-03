import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/providers/px_forms.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_visit_data.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class VisitFormsPage extends StatelessWidget {
  const VisitFormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisitData, PxForms, PxLocale>(
      builder: (context, v, f, l, _) {
        while (v.result == null || f.result == null) {
          return const CentralLoading();
        }
        while (v.result is ApiErrorResult) {
          return CentralError(
            code: AppErrorCode.clientException.code,
            toExecute: v.retry,
          );
        }
        return Scaffold(
          body: Center(
            child: Text(context.loc.visitForms),
          ),
        );
      },
    );
  }
}
