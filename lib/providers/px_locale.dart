import 'package:flutter/widgets.dart' show ChangeNotifier, Locale;
import 'package:proklinik_one/functions/dprint.dart';

class PxLocale extends ChangeNotifier {
  Locale _locale = const Locale("en");
  Locale get locale => _locale;

  void setLocale() {
    _locale = Locale(_lang);
    notifyListeners();
    dprint("PxLocale().setLocale($_locale)");
  }

  String _lang = 'en';
  String get lang => _lang;

  void setLang(String value) {
    _lang = value;
  }

  bool get isEnglish => lang == 'en' && locale == const Locale("en");
}
