enum DmDashboardActivityKind { delivery, collection, handover }

class DmDashboardActivityItem {
  const DmDashboardActivityItem({
    required this.kind,
    required this.id,
    required this.title,
    required this.at,
    this.amount,
  });

  final DmDashboardActivityKind kind;
  final String id;
  final String title;
  final DateTime at;
  final double? amount;
}

enum DmNextActionKind { pickup, deliver, unload, collect, handover }

class DmNextActionModel {
  const DmNextActionModel({
    required this.kind,
    required this.message,
    required this.buttonLabel,
  });

  final DmNextActionKind kind;
  final String message;
  final String buttonLabel;
}
