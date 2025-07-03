import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/models/visit_data/visit_data_nav_item.dart';

class VisitDataPage extends StatefulWidget {
  const VisitDataPage({super.key});

  @override
  State<VisitDataPage> createState() => _VisitDataPageState();
}

class _VisitDataPageState extends State<VisitDataPage> {
  bool _isExtended = false;
  int _index = 0;
  late final _items = VisitDataNavItem.items(context);

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
              destinations: _items.map((e) {
                return NavigationRailDestination(
                  icon: e.icon,
                  selectedIcon: e.selectedIcon,
                  label: Text(e.title),
                );
              }).toList(),
              selectedIndex: _index,
              onDestinationSelected: (value) {
                setState(() {
                  _index = value;
                  _isExtended = false;
                });
              },
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.small(
                  heroTag: 'nav-rail-exp-btn-visit-data',
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
              index: _index,
              alignment: Alignment.center,
              children: _items.map((e) => e.page).toList(),
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
              items: _items
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: e.icon,
                      activeIcon: e.selectedIcon,
                      label: e.title,
                    ),
                  )
                  .toList(),
              onTap: (value) {
                setState(() {
                  _index = value;
                });
              },
            )
          : null,
    );
  }
}
