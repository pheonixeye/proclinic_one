import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_one/extensions/is_mobile_context.dart';
import 'package:proklinik_one/models/visit_data/visit_data_nav_item.dart';

class VisitDataPage extends StatefulWidget {
  const VisitDataPage({
    super.key,
    required this.navigationShell,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<VisitDataPage> createState() => _VisitDataPageState();
}

class _VisitDataPageState extends State<VisitDataPage> {
  bool _isExtended = false;
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
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: (value) {
                widget.navigationShell.goBranch(value);
                setState(() {
                  _isExtended = false;
                });
              },
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.small(
                  heroTag: 'nav-rail-exp-btn--visit-data',
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
            child: widget.navigationShell,
          ),
        ],
      ),
      bottomNavigationBar: context.isMobile
          ? BottomNavigationBar(
              useLegacyColorScheme: false,
              currentIndex: widget.navigationShell.currentIndex,
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
                widget.navigationShell.goBranch(value);
              },
            )
          : null,
    );
  }
}
