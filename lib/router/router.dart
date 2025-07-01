import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/core/api/clinics_api.dart';
import 'package:proklinik_one/core/api/doctor_profile_items_api.dart';
import 'package:proklinik_one/core/api/forms_api.dart';
import 'package:proklinik_one/core/api/patients_api.dart';
import 'package:proklinik_one/functions/dprint.dart';
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
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/pages/order_details_page/order_details_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/transaction/transaction_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/visits_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/patients_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/settings_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/my_subscription_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/shell_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/thankyou_page/thankyou_screen.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_forms.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_patients.dart';
import 'package:proklinik_one/providers/px_speciality.dart';
import 'package:proklinik_one/utils/shared_prefs.dart';
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
  static const String mysubscription = "subscription";
  static const String orderdetails = "orderdetails";
  static const String visits = "visits";
  static const String patients = "patients";
  static const String clinics = "clinics";
  static const String forms = "forms";
  static const String bookkeeping = "bookkeeping";
  static const String settings = "settings";
  static const String transaction = "transaction";

  String? get currentRouteName =>
      router.routerDelegate.currentConfiguration.last.route.name;

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
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
    redirect: (context, state) async {
      final _locale = context.read<PxLocale>();
      final _urlLang = state.pathParameters['lang'];
      if (_urlLang != null && _urlLang != _locale.lang) {
        dprint('PxLocale.setLocale($_urlLang)(from router-redirect)');
        try {
          await _locale.setLang(_urlLang);
          _locale.setLocale();
          return null;
        } catch (e) {
          dprint(
              'PxLocale.setLocale($_urlLang)(from router-redirect)(couldnnot set locale correctly)');
          return null;
        }
      }
      return null;
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
        redirect: (context, state) async {
          if (state.fullPath == loading) {
            final _storedLanguage = await asyncPrefs.getString('lang');
            if (_storedLanguage != null) {
              return '/$_storedLanguage';
            } else {
              return '/en';
            }
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
            redirect: (context, state) async {
              final _auth = context.read<PxAuth>();
              if (_auth.isLoggedIn && state.fullPath == '/:lang') {
                return '/${state.pathParameters['lang']}/$app';
              }
              if (!_auth.isLoggedIn && state.fullPath == '/:lang') {
                try {
                  await _auth.loginWithToken();
                  dprint(
                      'authWithToken(LangPage-Redirect)(isLoggedIn=${_auth.isLoggedIn})');
                  return '/${state.pathParameters['lang']}/$app';
                } catch (e) {
                  return '/${state.pathParameters['lang']}/$login';
                }
              }
              if (_auth.isLoggedIn && state.fullPath != '/:lang') {
                return null;
              }
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
                redirect: (context, state) {
                  if (context.read<PxAuth>().isLoggedIn) {
                    return '/${state.pathParameters['lang']}/$app';
                  }
                  return null;
                },
              ),
              GoRoute(
                path: register,
                name: register,
                builder: (context, state) {
                  return ChangeNotifierProvider.value(
                    key: state.pageKey,
                    value: PxSpec(),
                    child: RegisterPage(
                      key: state.pageKey,
                    ),
                  );
                },
                redirect: (context, state) {
                  if (context.read<PxAuth>().isLoggedIn) {
                    return '/${state.pathParameters['lang']}/$app';
                  }
                  return null;
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
                    redirect: (context, state) async {
                      final _auth = context.read<PxAuth>();
                      if (_auth.isLoggedIn) {
                        return null;
                      }
                      if (!_auth.isLoggedIn) {
                        try {
                          await _auth.loginWithToken();
                          dprint(
                              'authWithToken(AppPage-Redirect)(isLoggedIn=${_auth.isLoggedIn})');
                          return null;
                        } catch (e) {
                          return '/${state.pathParameters['lang']}/$login';
                        }
                      }
                      return null;
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
                            query: _query,
                          );
                        },
                      ),
                      //profile_setup_routes
                      ...ProfileSetupItem.values.map((e) {
                        return GoRoute(
                          path: e.route,
                          name: e.route,
                          builder: (context, state) {
                            return ChangeNotifierProvider.value(
                              value: PxDoctorProfileItems(
                                api: DoctorProfileItemsApi(
                                  doc_id: context.read<PxAuth>().doc_id,
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
                        path: mysubscription,
                        name: mysubscription,
                        builder: (context, state) {
                          return MySubscriptionPage(
                            key: state.pageKey,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: orderdetails,
                            name: orderdetails,
                            builder: (context, state) {
                              try {
                                final _data =
                                    state.extra as Map<String, dynamic>?;
                                return OrderDetailsPage(
                                  key: state.pageKey,
                                  data: _data,
                                );
                              } catch (e) {
                                rethrow;
                              }
                            },
                          ),
                        ],
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
                          return ChangeNotifierProvider.value(
                            value: PxPatients(
                              api: PatientsApi(
                                doc_id: context.read<PxAuth>().doc_id,
                              ),
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
                          return ChangeNotifierProvider.value(
                            value: PxClinics(
                              api: ClinicsApi(
                                doc_id: context.read<PxAuth>().doc_id,
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
                          return ChangeNotifierProvider.value(
                            value: PxForms(
                              api: FormsApi(
                                doc_id: context.read<PxAuth>().doc_id,
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
