// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/random_curved_animation.dart';

// ignore: must_be_immutable
class RetryButtonWidget extends StatefulWidget {
  RetryButtonWidget({
    super.key,
    required this.toRetry,
    this.toClose,
  });
  final Function toRetry;
  VoidCallback? toClose;

  @override
  State<RetryButtonWidget> createState() => _RetryButtonWidgetState();
}

class _RetryButtonWidgetState extends State<RetryButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final _duration = const Duration(milliseconds: 1000);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
      lowerBound: 0.3,
      upperBound: 1.0,
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: RandomCurver().curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton.small(
        tooltip: context.loc.retry,
        heroTag: UniqueKey(),
        onPressed: () {
          widget.toRetry();
          if (widget.toClose != null) {
            widget.toClose!();
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

OverlayEntry retryOverlayEntry(Function toRetry) {
  final _overlay = RetryButtonWidget(toRetry: toRetry);

  final _entry = OverlayEntry(
    builder: (context) {
      return Draggable(
        hitTestBehavior: HitTestBehavior.opaque,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        onDragUpdate: (details) {
          if (details.delta.distance * 100 > 250 &&
              // ignore: unnecessary_null_comparison
              _overlay != null &&
              _overlay.toClose != null) {
            //close
            _overlay.toClose!();
          }
        },
        feedback: _overlay,
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 60,
            width: 60,
            child: Card.outlined(
              color: Colors.red.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _overlay,
              ),
            ),
          ),
        ),
      );
    },
  );

  _overlay.toClose = () {
    _entry.remove();
  };

  return _entry;
}
