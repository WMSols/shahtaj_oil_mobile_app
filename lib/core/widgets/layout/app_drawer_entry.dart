import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';

typedef AppDrawerLeaf = ({
  String id,
  IconData? icon,
  String label,
  Widget screen,
  VoidCallback? initBinding,
});

class AppDrawerGroup {
  const AppDrawerGroup({
    required this.id,
    required this.icon,
    required this.label,
    required this.children,
  });

  final String id;
  final IconData icon;
  final String label;
  final List<AppDrawerLeaf> children;
}

class AppDrawerEntry {
  const AppDrawerEntry._({
    required this.id,
    required this.icon,
    required this.label,
    this.leaf,
    this.children,
  });

  factory AppDrawerEntry.leaf(AppDrawerLeaf leaf) => AppDrawerEntry._(
    id: leaf.id,
    icon: leaf.icon ?? AppIcons.circle,
    label: leaf.label,
    leaf: leaf,
  );

  factory AppDrawerEntry.group(AppDrawerGroup group) => AppDrawerEntry._(
    id: group.id,
    icon: group.icon,
    label: group.label,
    children: group.children,
  );

  final String id;
  final IconData icon;
  final String label;
  final AppDrawerLeaf? leaf;
  final List<AppDrawerLeaf>? children;

  bool get isGroup => children != null && children!.isNotEmpty;
}
