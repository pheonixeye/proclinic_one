import 'dart:math';

import 'package:proklinik_doctor_portal/functions/dprint.dart';

class AppDummyAuth {
  static final random = Random().nextInt(3);
  static Future<String?> fetchAuthToken() async {
    await Future.delayed(const Duration(seconds: 2));
    dprint(random);
    if (random == 2) {
      return '_token';
    } else {
      return null;
    }
  }
}
