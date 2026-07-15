import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_line_summary_tile.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';

class ObVisitDetailLineTile extends StatelessWidget {
  const ObVisitDetailLineTile({super.key, required this.line});

  final ObVisitCartLineModel line;

  @override
  Widget build(BuildContext context) {
    return AppLineSummaryTile(
      title: line.productName,
      quantityLabel: '${line.quantity.toStringAsFixed(0)} ${line.unit ?? ''}'
          .trim(),
      unitPrice: line.priceUnit,
      lineTotal: line.lineTotal,
      emphasized: true,
      mutedBackground: true,
      quantityCaption: AppTexts.obCartQuantityHint,
      priceCaption: AppTexts.obCartPriceHint,
      totalCaption: AppTexts.obTotalLabel,
    );
  }
}
