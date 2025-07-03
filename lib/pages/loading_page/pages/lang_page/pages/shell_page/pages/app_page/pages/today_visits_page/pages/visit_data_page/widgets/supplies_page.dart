import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';

class VisitSuppliesPage extends StatelessWidget {
  const VisitSuppliesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.loc.visitSupplies),
    );
  }
}
