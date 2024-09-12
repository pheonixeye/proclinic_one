import 'package:proklinik_doctor_portal/core/api/auth/auth.dart';
import 'package:proklinik_doctor_portal/providers/px_auth.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/router/router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider.value(
    value: AppRouter.router.routeInformationProvider,
  ),
  ChangeNotifierProvider(
    create: (context) => PxLocale(),
  ),
  ChangeNotifierProvider(
    create: (context) => PxAuth(
      api: AuthApi(),
    ),
  ),
];
