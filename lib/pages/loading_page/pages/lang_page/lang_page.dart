import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class _LangPageState extends State<LangPage> {
  @override
  void initState() {
    super.initState();
    _matchNavigation(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CentralLoading(),
      ),
    );
  }

  FutureOr<void> _matchNavigation(BuildContext context) async {
    ///todo: check saved token logic
    final _pxAuth = context.read<PxAuth>();
    final _token = await AsyncPrefs.instance.prefs.getString('token');

    dprint('_token in langPage: ${_token?.substring(0, 5)}');
    if (_token != null) {
      try {
        await _pxAuth.loginWithToken();
        if (context.mounted) {
          GoRouter.of(context).goNamed(AppRouter.app,
              pathParameters: defaultPathParameters(context));
        }
      } catch (e) {
        dprint(e.toString());
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
