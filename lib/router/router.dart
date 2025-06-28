import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/core/api/clinics_api.dart';
import 'package:proklinik_one/core/api/doctor_profile_items_api.dart';
import 'package:proklinik_one/core/api/forms_api.dart';
import 'package:proklinik_one/core/api/patients_api.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/pages/loading_page/pages/error_page/error_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/lang_page.dart';
import 'package:proklinik_one/pages/loading_page/loading_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/login_page/login_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/register_page/register_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/app_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/profile_item_page/profile_item_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/clinics_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/bookkeeping_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/forms_page/forms_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/transaction/transaction_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/visits_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/patients_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/settings_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits/today_visits.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/shell_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/thankyou_page/thankyou_screen.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_doctor.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_forms.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_patients.dart';
import 'package:proklinik_one/providers/px_speciality.dart';
import 'package:proklinik_one/utils/utils_keys.dart';
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

  ///TODO: login register flow needs something that i don't know
  ///change logic - better implementation - rely on bloc instead of provider
  ///there is something wrong idk what that is
  static const String loading = "/";
  static const String lang = ":lang";
  static const String login = "login";
  static const String register = "register";
  static const String thankyou = "thankyou";
  static const String app = "app";
  //profile_setup_routes
  static const _profile_setup = 'profile_setup_';
  static const String drugs = "${_profile_setup}drugs";
  static const String labs = "${_profile_setup}labs";
  static const String rads = "${_profile_setup}rads";
  static const String procedures = "${_profile_setup}procedures";
  static const String supplies = "${_profile_setup}supplies";
  //main_routes
  static const String todayvisits = "todayvisits";
  static const String visits = "visits";
  static const String patients = "patients";
  static const String clinics = "clinics";
  static const String forms = "forms";
  static const String bookkeeping = "bookkeeping";
  static const String settings = "settings";
  static const String transaction = "transaction";

  static String? get currentRouteName =>
      router.routerDelegate.currentConfiguration.last.route.name;

  static final router = GoRouter(
    debugLogDiagnostics: true,
    // refreshListenable: Listenable.merge(
    //   [
    //     PxLocale(),
    //   ],
    // ),
    navigatorKey: UtilsKeys.navigatorKey,
    initialLocation: loading,
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
        redirect: (context, state) {
          if (state.pathParameters['lang'] == null ||
              state.pathParameters['lang']!.isEmpty) {
            print(
                'loading screen redirect fired with (if), path => ${state.fullPath}');
            state.pathParameters['lang'] = 'en';
            context.read<PxLocale>().setLang('en');
            return '/en';
          }
          return null;
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
                redirect: (context, state) async {
                  final lang = state.pathParameters['lang']!;
                  final _pxAuth = context.read<PxAuth>();
                  try {
                    await _pxAuth.loginWithToken();
                    return null;
                  } catch (e) {
                    return '/$lang/$login';
                  }
                  // if (_pxAuth.authModel != null) {
                  //   return null;
                  // } else {}
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
                      //transaction_result page
                      GoRoute(
                        path: transaction,
                        name: transaction,
                        builder: (context, state) {
                          final _query = state.uri.queryParameters;
                          return TransactionPage(
                            key: state.pageKey,
                            transactionResult: _query,
                          );
                        },
                      ),
                      //profile_setup_routes
                      ...ProfileSetupItem.values.map((e) {
                        return GoRoute(
                          path: e.route,
                          name: e.route,
                          builder: (context, state) {
                            return ChangeNotifierProvider(
                              create: (context) => PxDoctorProfileItems(
                                api: DoctorProfileItemsApi(
                                  doc_id:
                                      context.read<PxDoctor>().doctor?.id ?? '',
                                  item: e,
                                ),
                              ),
                              child: ProfileItemPage(
                                key: state.pageKey,
                                profileSetupItem: e,
                              ),
                            );
                          },
                        );
                      }),

                      //main_routes
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
                          return ChangeNotifierProvider(
                            create: (context) => PxPatients(
                              api: PatientsApi(
                                  doc_id: context.read<PxDoctor>().doctor?.id ??
                                      ''),
                            ),
                            child: PatientsPage(
                              key: state.pageKey,
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: clinics,
                        name: clinics,
                        builder: (context, state) {
                          return ChangeNotifierProvider(
                            create: (context) => PxClinics(
                              api: ClinicsApi(
                                doc_id:
                                    context.read<PxDoctor>().doctor?.id ?? '',
                              ),
                            ),
                            child: ClinicsPage(
                              key: state.pageKey,
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: forms,
                        name: forms,
                        builder: (context, state) {
                          return ChangeNotifierProvider(
                            create: (context) => PxForms(
                              api: FormsApi(
                                doc_id:
                                    context.read<PxDoctor>().doctor?.id ?? '',
                              ),
                            ),
                            child: FormsPage(
                              key: state.pageKey,
                            ),
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
