import 'package:flutter/material.dart';

class AppAnimatedDirectionality extends StatelessWidget {
  const AppAnimatedDirectionality({
    super.key,
    required this.textDirection,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeInOut,
  });

  final TextDirection textDirection;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          fit: StackFit.passthrough,
          children: [...previousChildren, ?currentChild],
        );
      },
      child: Directionality(
        key: ValueKey(textDirection),
        textDirection: textDirection,
        child: child,
      ),
    );
  }
}
