import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_line_summary_tile.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_line_model.dart';

class ObOrderLineTile extends StatelessWidget {
  const ObOrderLineTile({super.key, required this.line});

  final ObOrderLineModel line;

  @override
  Widget build(BuildContext context) {
    return AppLineSummaryTile(
      title: line.productName,
      quantityLabel:
          '${line.quantity} x ${AppFormatter.currencyWhole(line.unitPrice)}',
      unitPrice: line.unitPrice,
      lineTotal: line.quantity * line.unitPrice,
    );
  }
}
