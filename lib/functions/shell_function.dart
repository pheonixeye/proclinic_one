import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/widgets/central_loading.dart';

// ignore: must_be_immutable
class BaseOverlayEntry extends StatefulWidget {
  BaseOverlayEntry({
    super.key,
    required this.message,
    this.color,
    this.onTap,
  });
  final String message;
  final Color? color;
  VoidCallback? onTap;

  @override
  State<BaseOverlayEntry> createState() => _BaseOverlayEntryState();
}

class _BaseOverlayEntryState extends State<BaseOverlayEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _duration = const Duration(seconds: 5);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
      onTap: widget.onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.message,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.info,
              color: widget.color ?? Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _controller.value,
              color: Colors.amber,
              backgroundColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RetryButton extends StatefulWidget {
  RetryButton({
    super.key,
    required this.toRetry,
    this.toClose,
  });
  final Function toRetry;
  VoidCallback? toClose;

  @override
  State<RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<RetryButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: context.loc.retry,
      heroTag: UniqueKey(),
      onPressed: () {
        widget.toRetry();
        if (widget.toClose != null) {
          widget.toClose!();
        }
      },
      child: const Icon(Icons.refresh),
    );
  }
}

OverlayEntry _retryOverlayEntry(Function toRetry) {
  final _overlay = RetryButton(toRetry: toRetry);

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

OverlayEntry _overlay(
  String message, [
  Color? color,
]) {
  final _overlay = BaseOverlayEntry(
    message: message,
    color: color,
  );

  final _entry = OverlayEntry(
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 10,
            height: 65,
            child: Card.outlined(
              child: _overlay,
            ),
          ),
        ),
      );
    },
  );

  _overlay.onTap = () {
    _entry.remove();
  };
  return _entry;
}

///Shell function encapsulating loading & error handling logic in the UI
Future<void> shellFunction(
  BuildContext context, {
  required Function toExecute,
  String sucessMsg = '',
  Function? onCatch,
  Duration duration = const Duration(seconds: 5),
}) async {
  late BuildContext loadingContext;
  try {
    if (sucessMsg.isEmpty) {
      sucessMsg = context.loc.success;
    }
    if (context.mounted) {
      //todo: change to overlay logic
      showDialog(
          context: context,
          builder: (context) {
            loadingContext = context;
            return const CentralLoading();
          });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    await toExecute();
    if (loadingContext.mounted) {
      Navigator.pop(loadingContext);
    }
    if (context.mounted) {
      final _successOverlay = _overlay(sucessMsg);

      Overlay.of(context).insert(_successOverlay);

      await Future.delayed(duration);
      if (_successOverlay.mounted) {
        _successOverlay.remove();
      }
    }
  } catch (e) {
    if (loadingContext.mounted) {
      Navigator.pop(loadingContext);
    }
    if (context.mounted) {
      print('error-overlay-init');
      final _errorOverlay = _overlay(e.toString(), Colors.red);
      Overlay.of(context).insert(_errorOverlay);
      await Future.delayed(duration);
      if (_errorOverlay.mounted) {
        _errorOverlay.remove();
        print('error-overlay-dispose');
      }

      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        print('retry-overlay-init');
        final _retryOverlay = _retryOverlayEntry(() async {
          await shellFunction(
            context,
            toExecute: toExecute,
          );
        });
        Overlay.of(context).insert(_retryOverlay);
      }

      debugPrint(e.toString());
      if (onCatch != null) {
        onCatch();
      }
    }
  }
}
