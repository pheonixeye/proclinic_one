import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/extensions/is_mobile_context.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/router/router.dart';
import 'package:proklinik_doctor_portal/theme/app_theme.dart';
import 'package:provider/provider.dart';

class DrawerNavBtn extends StatefulWidget {
  const DrawerNavBtn({
    super.key,
    this.routePath,
    required this.title,
    this.icondata,
    this.selected = false,
  });
  final String? routePath;
  final String title;
  final IconData? icondata;
  final bool selected;

  @override
  State<DrawerNavBtn> createState() => _DrawerNavBtnState();
}

class _DrawerNavBtnState extends State<DrawerNavBtn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        final r = AppRouter.router.routeInformationProvider;
        print(r.value.uri.path);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: Colors.white),
            ),
            mouseCursor: SystemMouseCursors.click,
            onTap: () {
              GoRouter.of(context).goNamed(
                widget.routePath!,
                pathParameters: defaultPathParameters(context),
              );
              if (context.isMobile) {
                Scaffold.of(context).closeEndDrawer();
              }
              setState(() {});
            },
            selectedColor: AppTheme.secondaryOrangeColor,
            selectedTileColor: AppTheme.secondaryOrangeColor,
            selected: r.value.uri.path.endsWith(widget.routePath!),
            title: Row(
              children: [
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 18,
                  child: widget.icondata == null
                      ? const SizedBox()
                      : Icon(
                          widget.icondata,
                          size: 18,
                        ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
