import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';

class ObVisitCartModel {
  const ObVisitCartModel({
    required this.visitId,
    required this.shopName,
    this.lines = const [],
  });

  final int visitId;
  final String shopName;
  final List<ObVisitCartLineModel> lines;

  double get subtotal =>
      lines.fold<double>(0, (sum, line) => sum + line.lineTotal);

  int get lineCount => lines.length;

  ObVisitCartModel copyWith({
    int? visitId,
    String? shopName,
    List<ObVisitCartLineModel>? lines,
  }) => ObVisitCartModel(
    visitId: visitId ?? this.visitId,
    shopName: shopName ?? this.shopName,
    lines: lines ?? this.lines,
  );
}
