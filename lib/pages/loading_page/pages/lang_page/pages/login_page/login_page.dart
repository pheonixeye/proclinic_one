import 'package:flutter/material.dart';
import 'package:proklinik_doctor_portal/extensions/loc_ext.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.loc.login),
          ],
        ),
      ),
    );
  }
}
