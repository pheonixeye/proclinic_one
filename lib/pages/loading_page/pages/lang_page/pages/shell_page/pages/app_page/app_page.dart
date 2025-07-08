import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/app_profile_setup.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/bookkeeping_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/today_visits_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/visits_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SingleTickerProviderStateMixin {
  int _index = 0;
  bool _isExtended = false;

  late final _navDestinationItems = <NavigationRailDestination>[
    NavigationRailDestination(
      icon: const Icon(Icons.perm_contact_calendar_outlined),
      selectedIcon: const Icon(Icons.perm_contact_calendar),
      label: Text(context.loc.todayVisits),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.person),
      selectedIcon: const Icon(FontAwesomeIcons.personCirclePlus),
      label: Text(context.loc.visits),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.monetization_on),
      selectedIcon: const Icon(FontAwesomeIcons.moneyCheck),
      label: Text(context.loc.bookkeeping),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.settings),
      selectedIcon: const Icon(Icons.settings_suggest),
      label: Text(context.loc.profileSetup),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (!context.isMobile)
            NavigationRail(
              useIndicator: true,
              indicatorColor: Colors.amber.shade200,
              elevation: 6,
              backgroundColor: Colors.blue.shade200,
              extended: _isExtended,
              destinations: _navDestinationItems,
              selectedIndex: _index,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.amber.shade200,
                  child: _navDestinationItems[_index].selectedIcon,
                ),
              ),
              onDestinationSelected: (value) {
                setState(() {
                  _index = value;
                  _isExtended = false;
                });
              },
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.small(
                  heroTag: 'nav-rail-exp-btn--app',
                  onPressed: () {
                    setState(() {
                      _isExtended = !_isExtended;
                    });
                  },
                  child: Icon(
                    _isExtended ? Icons.arrow_back : Icons.arrow_forward,
                  ),
                ),
              ),
            ),
          Expanded(
            child: IndexedStack(
              alignment: Alignment.center,
              index: _index,
              children: <Widget>[
                const TodayVisitsPage(),
                const VisitsPage(),
                const BookkeepingPage(),
                const AppProfileSetup(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: context.isMobile
          ? BottomNavigationBar(
              useLegacyColorScheme: false,
              currentIndex: _index,
              type: BottomNavigationBarType.shifting,
              elevation: 6,
              mouseCursor: SystemMouseCursors.click,
              showSelectedLabels: true,
              onTap: (value) {
                setState(() {
                  _index = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.perm_contact_calendar_outlined),
                  activeIcon: const Icon(Icons.perm_contact_calendar),
                  label: context.loc.todayVisits,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  activeIcon: const Icon(FontAwesomeIcons.personCirclePlus),
                  label: context.loc.visits,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.monetization_on),
                  activeIcon: const Icon(FontAwesomeIcons.moneyCheck),
                  label: context.loc.bookkeeping,
                ),
                BottomNavigationBarItem(
                  tooltip: context.loc.profileSetup,
                  icon: const Icon(Icons.settings),
                  activeIcon: const Icon(Icons.settings_suggest),
                  label: context.loc.profileSetup,
                ),
              ],
            )
          : null,
    );
  }
}
