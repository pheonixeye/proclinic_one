import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:provider/provider.dart';

class TodayVisits extends StatelessWidget {
  const TodayVisits({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('dd/MM/yyyy', l.lang).format(DateTime.now())),
              ],
            ),
          ),
        );
      },
    );
  }
}
