import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/pages/error_page/error_page.dart';
import 'package:proklinik_doctor_portal/pages/lang_page/lang_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/loading_page.dart';
import 'package:proklinik_doctor_portal/pages/login_page/login_page.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/utils/utils_keys.dart';
import 'package:provider/provider.dart';

Map<String, String> defaultPathParameters(BuildContext context) {
  final lang = context.read<PxLocale>().lang;
  return {"lang": lang};
}

/// GoRouter configuration
///
class AppRouter {
  AppRouter();
  static const String loading = "/";
  static const String lang = ":lang";
  static const String login = "login";
  static const String register = "register";
  static const String app = "app";
  static const String todayvisits = "today";

  static final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: Listenable.merge(
      [
        PxLocale(),
      ],
    ),
    navigatorKey: UtilsKeys.navigatorKey,
    initialLocation: loading,
    redirect: (context, state) {
      if (state.fullPath == '/') {
        context.read<PxLocale>().setLang('en');
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
          GoRoute(
            path: lang,
            name: lang,
            builder: (context, state) {
              return LangPage(
                key: state.pageKey,
              );
            },
            routes: [
              GoRoute(
                path: login,
                name: login,
                builder: (context, state) {
                  return LoginPage(
                    key: state.pageKey,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
