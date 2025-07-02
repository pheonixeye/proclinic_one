import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
