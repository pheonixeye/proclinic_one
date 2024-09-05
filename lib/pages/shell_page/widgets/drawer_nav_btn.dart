import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/extensions/is_mobile_context.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/theme/app_theme.dart';
import 'package:provider/provider.dart';

class DrawerNavBtn extends StatefulWidget {
  const DrawerNavBtn({
    super.key,
    this.routePath,
    required this.title,
    this.icondata,
  });
  final String? routePath;
  final String title;
  final IconData? icondata;

  @override
  State<DrawerNavBtn> createState() => _DrawerNavBtnState();
}

class _DrawerNavBtnState extends State<DrawerNavBtn> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            mouseCursor: SystemMouseCursors.click,
            onTap: () {
              GoRouter.of(context).go("/${l.lang}/${widget.routePath ?? ''}");
              if (context.isMobile) {
                Scaffold.of(context).closeEndDrawer();
              }
            },
            selectedColor: AppTheme.secondaryOrangeColor,
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
