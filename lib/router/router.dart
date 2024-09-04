import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/functions/dprint.dart';
import 'package:proklinik_doctor_portal/pages/error_page/error_page.dart';
import 'package:proklinik_doctor_portal/pages/home_page/home_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/loading_page.dart';
import 'package:proklinik_doctor_portal/pages/shell_page/shell_page.dart';
import 'package:proklinik_doctor_portal/pages/today_visits/today_visits.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/utils/utils_keys.dart';
import 'package:provider/provider.dart';

const _langs = ["en", "ar"];

Map<String, String> defaultPathParameters(BuildContext context) {
  final lang = context.read<PxLocale>().lang;
  return {
    "lang": lang,
  };
}

/// GoRouter configuration
///
class AppRouter {
  AppRouter();
  static const String loading = "/";
  static const String home = ":lang";
  static const String todayvisits = "today";

  static final router = GoRouter(
    refreshListenable: Listenable.merge(
      [
        PxLocale(),
      ],
    ),
    navigatorKey: UtilsKeys.navigatorKey,
    initialLocation: loading,
    redirect: (context, state) {
      dprint(state.fullPath);
      if (state.fullPath == '/') {
        return '/en';
      } else {
        final lang = state.pathParameters['lang'];
        context.read<PxLocale>().setLang(lang!);
        return null;
      }
    },
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: ErrorPage(
          key: state.pageKey,
        ),
      );
    },
    routes: [
      GoRoute(
        path: loading,
        name: loading,
        builder: (context, state) {
          return LoadingPage(
            key: state.pageKey,
          );
        },
        routes: [
          ShellRoute(
            pageBuilder: (context, state, child) {
              final lang = state.pathParameters["lang"]!;

              final key = ValueKey((lang, state.pageKey));
              return MaterialPage(
                child: ShellPage(
                  key: key,
                  child: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: home,
                name: home,
                builder: (context, state) {
                  final lang = state.pathParameters["lang"]!;
                  final key = ValueKey(lang);
                  return HomePage(
                    key: key,
                  );
                },
                routes: [
                  GoRoute(
                    path: todayvisits,
                    name: todayvisits,
                    builder: (context, state) {
                      return TodayVisits(
                        key: state.pageKey,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
