import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/gradients/app_gradients.dart';

/// App-wide light background with subtle gradient.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: child,
    );
  }
}
