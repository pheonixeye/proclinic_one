import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:proklinik_one/utils/shared_prefs.dart';
import 'package:proklinik_one/widgets/central_loading.dart';
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
    final _token = await asyncPrefs.getString('token');

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
