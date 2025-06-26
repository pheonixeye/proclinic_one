import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/providers/px_doctor.dart';
import 'package:provider/provider.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});
  //TODO: convert this page into a shellRoute

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SingleTickerProviderStateMixin {
  late final TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: <Widget>[
          Center(
            child: Consumer<PxDoctor>(
              builder: (context, d, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.loc.homepage),
                    if (d.doctor != null) ...[
                      Text('${d.doctor?.name_en}'),
                      Text('${d.doctor?.name_ar}'),
                      Text('${d.doctor?.phone}'),
                      Text('${d.doctor?.speciality.name_en}'),
                      Text('${d.doctor?.speciality.name_ar}'),
                    ]
                  ],
                );
              },
            ),
          ),
          const Center(
            child: Text("Home"),
          ),
          const Center(
            child: Text("Profile"),
          ),
          const Center(
            child: Text("Settings"),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        currentIndex: _controller.index,
        type: BottomNavigationBarType.shifting,
        elevation: 6,
        mouseCursor: SystemMouseCursors.click,
        showSelectedLabels: true,
        onTap: (value) {
          setState(() {
            _controller.animateTo(value);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            activeIcon: const Icon(Icons.dashboard_customize),
            label: 'Dashboard',
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
            icon: const Icon(Icons.settings),
            activeIcon: const Icon(Icons.settings_suggest),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
