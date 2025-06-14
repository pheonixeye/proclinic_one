import 'package:proklinik_one/core/api/auth/api_auth.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:proklinik_one/utils/shared_prefs.dart';
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
      api: AuthApi(
        asyncPrefs: AsyncPrefs.instance.prefs,
      ),
    ),
  ),
];
