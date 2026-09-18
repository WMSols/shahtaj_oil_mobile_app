/// Lightweight row for van stock UI (snapshot or WH catalog).
class DmVanItemView {
  const DmVanItemView({
    required this.id,
    required this.productId,
    required this.name,
    this.uom,
    this.qtyOnVan = 0,
    this.qtyInWarehouse = 0,
    this.maxEditable = 0,
  });

  final String id;
  final int productId;
  final String name;
  final String? uom;
  final double qtyOnVan;
  final double qtyInWarehouse;
  final double maxEditable;
}
