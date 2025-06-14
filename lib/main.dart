import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proklinik_one/core/localization/app_localizations.dart';
import 'package:proklinik_one/providers/_main.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:proklinik_one/theme/app_theme.dart';
import 'package:proklinik_one/utils/shared_prefs.dart';
import 'package:proklinik_one/utils/utils_keys.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  AsyncPrefs.instance;
  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return MaterialApp.router(
          scaffoldMessengerKey: UtilsKeys.scaffoldMessengerKey,
          title: "ProCliniC One",
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          locale: l.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.theme,
        );
      },
    );
  }
}
