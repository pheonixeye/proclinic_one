import 'package:flutter/material.dart';
// import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;
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
  initAsyncPrefs();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
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
          title: "ProKliniK-One",
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
  //TODO: add caching for pdf.min.js via cdn "https://unpkg.com/pdfjs-dist@3.11.174/build/pdf.min.js"
  //TODO: add doctor initialization script on create doctor account (maybe a backend script)
  //TODO: implement api cache over the whole app*(only in patients && clinics apis yet)
  //TODO: add initialization logic / workflow for newly registered doctors => could be replaced by a follow up team
  //TODO: add ios safari logic script in index.html
  //TODO: add validation that the doctor inputs atleast 2 names in the registeration form
  //TODO: add application error codes && messages
  //TODO: migrate (create doctor_subscription) to the backend
}
