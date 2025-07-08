import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/drawer_nav_btn.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/thin_divider.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:provider/provider.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      width: MediaQuery.sizeOf(context).width * 0.65,
      backgroundColor: Colors.blue.shade500.withValues(alpha: 0.9),
      child: Consumer<GoRouteInformationProvider>(
        builder: (context, r, _) {
          bool selected(String path) => r.value.uri.path.endsWith('/$path');
          // print(r.value.uri.path);
          return ListView(
            children: [
              if (context.isMobile)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Scaffold.of(context).closeEndDrawer();
                            },
                            icon: const Icon(Icons.arrow_forward),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.dashboard,
                icondata: FontAwesomeIcons.houseMedical,
                routePath: AppRouter.app,
                selected: selected(AppRouter.app),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.patients,
                icondata: FontAwesomeIcons.person,
                routePath: AppRouter.patients,
                selected: selected(AppRouter.patients),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.myClinics,
                icondata: Icons.calendar_month,
                routePath: AppRouter.clinics,
                selected: selected(AppRouter.clinics),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.forms,
                icondata: Icons.edit_document,
                routePath: AppRouter.forms,
                selected: selected(AppRouter.forms),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.supplyItemsMovement,
                icondata: Icons.warehouse,
                routePath: AppRouter.inventory_supplies,
                selected: selected(AppRouter.inventory_supplies),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.mySubscription,
                icondata: Icons.receipt_long,
                routePath: AppRouter.mysubscription,
                selected: selected(AppRouter.mysubscription),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.settings,
                icondata: Icons.settings,
                routePath: AppRouter.settings,
                selected: selected(AppRouter.settings),
              ),
              const ThinDivider(),
            ],
          );
        },
      ),
    );
  }
}
