import 'package:flutter/material.dart';
import 'package:proklinik_one/assets/assets.dart';
import 'package:proklinik_one/extensions/after_layout.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //! IMPORTANT
    context.read<PxLocale>().setLocale();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(AppAssets.icon),
        ),
      ),
    );
  }
}
