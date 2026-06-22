import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class AppFormRow extends StatelessWidget {
  const AppFormRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = AppResponsive.scaleSize(context, 12);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}
