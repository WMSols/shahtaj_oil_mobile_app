class ObRouteOption {
  const ObRouteOption({
    required this.id,
    required this.zoneId,
    required this.name,
  });

  final int id;
  final int zoneId;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObRouteOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
