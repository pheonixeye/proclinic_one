import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/extensions/after_layout.dart';
import 'package:proklinik_doctor_portal/router/router.dart';
import 'package:proklinik_doctor_portal/widgets/central_loading.dart';

class LangPage extends StatefulWidget {
  const LangPage({super.key});

  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    GoRouter.of(context).goNamed(
      AppRouter.login,
      pathParameters: defaultPathParameters(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CentralLoading(),
      ),
    );
  }
}
