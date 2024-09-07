import 'package:flutter/material.dart';
import 'package:proklinik_doctor_portal/widgets/central_loading.dart';

class LangPage extends StatefulWidget {
  const LangPage({super.key});

  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CentralLoading(),
      ),
    );
  }
}
