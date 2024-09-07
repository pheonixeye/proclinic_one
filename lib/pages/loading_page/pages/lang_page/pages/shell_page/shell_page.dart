import 'package:flutter/material.dart';
import 'package:proklinik_doctor_portal/extensions/is_mobile_context.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/widgets/end_drawer.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/widgets/language_btn.dart';
import 'package:proklinik_doctor_portal/pages/loading_page/pages/lang_page/pages/shell_page/widgets/nav_bar.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController(debugLabel: "main-scroll-controller");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      //TODO: Adjust location of navigation drawer according to language
      body: Row(
        children: [
          if (!context.isMobile)
            const Expanded(
              flex: 1,
              child: EndDrawer(),
            ),
          Expanded(
            flex: 5,
            child: widget.child,
          ),
        ],
      ),
      endDrawer: context.isMobile ? const EndDrawer() : null,
      floatingActionButton: context.isMobile ? const LanguageBtn() : null,
    );
  }
}
