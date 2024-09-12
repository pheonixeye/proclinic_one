import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/error_page/error_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/lang_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/loading_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/login_page/login_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/register_page/register_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/app_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/appointment_organizer_page/appointment_organizer_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/bookkeeping_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/visits_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/patients_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/settings_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits/today_visits.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/shell_page.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/thankyou_page/thankyou_screen.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/providers/px_speciality.dart';
import 'package:proklinik_doctor_portal/utils/utils_keys.dart';
import 'package:provider/provider.dart';

Map<String, String> defaultPathParameters(BuildContext context) {
  final lang = context.read<PxLocale>().lang;
  return {"lang": lang};
}

extension GoRouterExtension on GoRouter {
  String? get currentRouteName =>
      routerDelegate.currentConfiguration.last.route.name;
}

/// GoRouter configuration
///
class AppRouter {
  AppRouter();
  static const String loading = "/";
  static const String lang = ":lang";
  static const String login = "login";
  static const String register = "register";
  static const String thankyou = "thankyou";
  static const String app = "app";
  static const String todayvisits = "todayvisits";
  static const String visits = "visits";
  static const String patients = "patients";
  static const String organizer = "organizer";
  static const String bookkeeping = "bookkeeping";
  static const String settings = "settings";

  static String? get currentRouteName =>
      router.routerDelegate.currentConfiguration.last.route.name;

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
            redirect: (context, state) async {
              ///TODO: check saved token logic
              // final lang = state.pathParameters['lang'];
              // ignore: no_leading_underscores_for_local_identifiers
              // final _token = await AppDummyAuth.fetchAuthToken();
              // dprint(_token);
              // if (_token != null) return '/$lang/$app';
              // if (_token == null) return '/$lang/$login';
              return null;
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
              GoRoute(
                path: register,
                name: register,
                builder: (context, state) {
                  return ChangeNotifierProvider.value(
                    key: state.pageKey,
                    value: PxSpec.instance(),
                    child: RegisterPage(
                      key: state.pageKey,
                    ),
                  );
                },
              ),
              GoRoute(
                path: thankyou,
                name: thankyou,
                builder: (context, state) {
                  return ThankyouPage(
                    key: state.pageKey,
                  );
                },
              ),
              ShellRoute(
                builder: (context, state, child) {
                  return ShellPage(
                    key: state.pageKey,
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: app,
                    name: app,
                    builder: (context, state) {
                      return AppPage(
                        key: state.pageKey,
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
                      GoRoute(
                        path: visits,
                        name: visits,
                        builder: (context, state) {
                          return VisitsPage(
                            key: state.pageKey,
                          );
                        },
                      ),
                      GoRoute(
                        path: patients,
                        name: patients,
                        builder: (context, state) {
                          return PatientsPage(
                            key: state.pageKey,
                          );
                        },
                      ),
                      GoRoute(
                        path: organizer,
                        name: organizer,
                        builder: (context, state) {
                          return AppointmentOrganizerPage(
                            key: state.pageKey,
                          );
                        },
                      ),
                      GoRoute(
                        path: bookkeeping,
                        name: bookkeeping,
                        builder: (context, state) {
                          return BookkeepingPage(
                            key: state.pageKey,
                          );
                        },
                      ),
                      GoRoute(
                        path: settings,
                        name: settings,
                        builder: (context, state) {
                          return SettingsPage(
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
      ),
    ],
  );
}
