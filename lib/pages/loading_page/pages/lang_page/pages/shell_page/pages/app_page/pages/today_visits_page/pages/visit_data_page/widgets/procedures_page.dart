import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';

class VisitProceduresPage extends StatelessWidget {
  const VisitProceduresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.loc.visitProcedures),
    );
  }
}
