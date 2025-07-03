import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';

class VisitRadsPage extends StatelessWidget {
  const VisitRadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.loc.visitRads),
    );
  }
}
