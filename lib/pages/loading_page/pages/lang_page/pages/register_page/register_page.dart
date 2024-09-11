import 'package:flutter/material.dart';
import 'package:proklinik_doctor_portal/assets/assets.dart';
import 'package:proklinik_doctor_portal/extensions/is_mobile_context.dart';
import 'package:proklinik_doctor_portal/extensions/loc_ext.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!context.isMobile)
                //# register-avatar
                Expanded(
                  flex: 1,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        AppAssets.registerAvatar,
                        fit: BoxFit.cover,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text('lorem ipsum dolor sit amit'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                flex: 1,
                child: Column(
                  //# create account form
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.loc.register),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
