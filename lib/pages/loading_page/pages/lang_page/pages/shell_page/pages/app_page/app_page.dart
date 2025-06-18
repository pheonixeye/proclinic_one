import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/providers/px_doctor.dart';
import 'package:provider/provider.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<PxDoctor>(
          builder: (context, d, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.loc.homepage),
                if (d.doctor != null) ...[
                  Text('${d.doctor?.name_en}'),
                  Text('${d.doctor?.name_ar}'),
                  Text('${d.doctor?.phone}'),
                  Text('${d.doctor?.speciality.name_en}'),
                  Text('${d.doctor?.speciality.name_ar}'),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}
