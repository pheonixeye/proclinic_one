import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/app_profile_setup.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/today_visits_page.dart';
import 'package:proklinik_one/providers/px_doctor.dart';
import 'package:provider/provider.dart';

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
      icon: const Icon(Icons.home),
      selectedIcon: const Icon(Icons.home_max),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.person),
      selectedIcon: const Icon(Icons.person_pin),
      label: Text('Profile'),
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
                  heroTag: 'nav-rail-exp-btn',
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
                const Center(
                  child: Text("Home"),
                ),
                Center(
                  child: Consumer<PxDoctor>(
                    builder: (context, d, _) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.loc.homepage),
                          if (d.doctor == null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: CircularProgressIndicator(),
                            )
                          else if (d.doctor != null) ...[
                            Text('${d.doctor?.name_en}'),
                            Text('${d.doctor?.name_ar}'),
                            Text('${d.doctor?.phone}'),
                            Text('${d.doctor?.speciality.name_en}'),
                            Text('${d.doctor?.speciality.name_ar}'),
                            Text('${d.doctor?.email}'),
                          ]
                        ],
                      );
                    },
                  ),
                ),
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
                  icon: const Icon(Icons.home),
                  activeIcon: const Icon(Icons.home_max),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  activeIcon: const Icon(Icons.person_pin),
                  label: 'Profile',
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
