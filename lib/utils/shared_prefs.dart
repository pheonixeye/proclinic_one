import 'package:shared_preferences/shared_preferences.dart';

class AsyncPrefs {
  AsyncPrefs._() {
    prefs = SharedPreferencesAsync();
  }

  static final _internal = AsyncPrefs._();

  factory AsyncPrefs._instance() => _internal;

  static AsyncPrefs get instance => AsyncPrefs._instance();

  late final SharedPreferencesAsync prefs;
}
