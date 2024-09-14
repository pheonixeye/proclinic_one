import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/extensions/after_layout.dart';
import 'package:proklinik_doctor_portal/functions/dprint.dart';
import 'package:proklinik_doctor_portal/providers/px_auth.dart';
import 'package:proklinik_doctor_portal/router/router.dart';
import 'package:proklinik_doctor_portal/utils/shared_prefs.dart';
import 'package:proklinik_doctor_portal/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class LangPage extends StatefulWidget {
  const LangPage({super.key});

  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CentralLoading(),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    ///todo: check saved token logic
    // ignore: no_leading_underscores_for_local_identifiers
    final _token = await AsyncPrefs.instance.prefs.getString('token');
    // ignore: no_leading_underscores_for_local_identifiers
    final _email = await AsyncPrefs.instance.prefs.getString('email');
    dprint('_token in langPage: ${_token?.substring(0, 5)}');
    if (_token != null && _email != null) {
      try {
        if (context.mounted) {
          await context.read<PxAuth>().loginWithToken(_email, _token);
        }
        if (context.mounted) {
          GoRouter.of(context).goNamed(AppRouter.app,
              pathParameters: defaultPathParameters(context));
        }
      } catch (e) {
        if (context.mounted) {
          GoRouter.of(context).goNamed(AppRouter.login,
              pathParameters: defaultPathParameters(context));
        }
      }
    } else {
      if (context.mounted) {
        GoRouter.of(context).goNamed(AppRouter.login,
            pathParameters: defaultPathParameters(context));
      }
    }
  }
}
