import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proklinik_doctor_portal/extensions/is_mobile_context.dart';
import 'package:proklinik_doctor_portal/extensions/loc_ext.dart';
import 'package:proklinik_doctor_portal/pages/shell_page/widgets/drawer_nav_btn.dart';
import 'package:proklinik_doctor_portal/pages/shell_page/widgets/thin_divider.dart';
import 'package:proklinik_doctor_portal/router/router.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      width: MediaQuery.sizeOf(context).width * 0.65,
      backgroundColor: Colors.green.shade500.withOpacity(0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          const SizedBox(height: 40),
          const ThinDivider(),
          DrawerNavBtn(
            title: context.loc.homepage,
            icondata: FontAwesomeIcons.house,
            // routePath: AppRouter.home,
          ),
          const ThinDivider(),
          DrawerNavBtn(
            title: context.loc.todayVisits,
            icondata: Icons.today,
            routePath: AppRouter.todayvisits,
          ),
          // const ThinDivider(),
          // DrawerNavBtn(
          //   title: context.loc.login,
          //   icondata: FontAwesomeIcons.arrowRightToBracket,
          //   routePath: AppRouter.login,
          // ),
          // const ThinDivider(),
          // DrawerNavBtn(
          //   title: context.loc.forProviders,
          //   icondata: FontAwesomeIcons.handHoldingMedical,
          //   routePath: AppRouter.forproviders,
          // ),
          // const ThinDivider(),
          // DrawerNavBtn(
          //   title: context.loc.contactUs,
          //   icondata: Icons.phone,
          //   routePath: AppRouter.contactus,
          // ),
          const ThinDivider(),
        ],
      ),
    );
  }
}
