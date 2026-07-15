import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_profile_avatar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.entries,
    required this.selectedLeafId,
    required this.expandedGroupIds,
    required this.onLeafTap,
    required this.onGroupToggle,
    required this.roleLabel,
  });

  final List<AppDrawerEntry> entries;
  final String selectedLeafId;
  final Set<String> expandedGroupIds;
  final ValueChanged<String> onLeafTap;
  final ValueChanged<String> onGroupToggle;
  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    final session = Get.find<SessionService>();
    final drawerWidth = AppResponsive.screenWidth(context) * 0.8;
    final logoWidth = drawerWidth * 0.4;
    final itemRadius = BorderRadius.only(
      topLeft: Radius.circular(AppResponsive.radius(context, factor: 5)),
      bottomLeft: Radius.circular(AppResponsive.radius(context, factor: 5)),
    );

    return Drawer(
      width: drawerWidth,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSpacing.screenPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Image.asset(
                      localeService.isRtl
                          ? AppImages.appLogoUrdu
                          : AppImages.appLogoEnglish,
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                  AppSpacing.vertical(context, 0.015),
                  Obx(() {
                    final currentRole =
                        session.role.value ?? UserRole.orderBooker;
                    final currentName =
                        session.user.value?.displayName(
                          AppTexts.defaultUserName,
                        ) ??
                        AppTexts.defaultUserName;
                    final chipRole = session.role.value == null
                        ? roleLabel
                        : currentRole.label;
                    final connectivity = Get.find<ConnectivityService>();
                    final presence = !connectivity.isOnline.value
                        ? PresenceStatus.offline
                        : (session.user.value?.presenceStatus ??
                              PresenceStatus.away);

                    return Row(
                      children: [
                        AppProfileAvatar(
                          size: 48,
                          name: currentName,
                          presenceStatus: presence,
                          showPresenceDot: true,
                        ),
                        AppSpacing.horizontal(context, 0.02),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentName,
                                style: AppTextStyles.sectionTitle(context)
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AppSpacing.vertical(context, 0.004),
                              if (session.role.value == null)
                                AppStatusChip(
                                  label: chipRole,
                                  color: AppColors.primary,
                                )
                              else
                                AppStatusChip.role(currentRole),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: ListView(
                padding: AppSpacing.screenPadding(
                  context,
                ).copyWith(right: 0, left: 0),
                children: [
                  for (final entry in entries)
                    if (entry.isGroup)
                      _DrawerGroupTile(
                        entry: entry,
                        itemRadius: itemRadius,
                        isExpanded: expandedGroupIds.contains(entry.id),
                        selectedLeafId: selectedLeafId,
                        onGroupToggle: () => onGroupToggle(entry.id),
                        onLeafTap: onLeafTap,
                      )
                    else
                      _DrawerLeafTile(
                        leaf: entry.leaf!,
                        itemRadius: itemRadius,
                        isSelected: entry.leaf!.id == selectedLeafId,
                        onTap: () => onLeafTap(entry.leaf!.id),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerGroupTile extends StatelessWidget {
  const _DrawerGroupTile({
    required this.entry,
    required this.itemRadius,
    required this.isExpanded,
    required this.selectedLeafId,
    required this.onGroupToggle,
    required this.onLeafTap,
  });

  final AppDrawerEntry entry;
  final BorderRadius itemRadius;
  final bool isExpanded;
  final String selectedLeafId;
  final VoidCallback onGroupToggle;
  final ValueChanged<String> onLeafTap;

  bool get _hasActiveChild =>
      entry.children!.any((child) => child.id == selectedLeafId);

  @override
  Widget build(BuildContext context) {
    final headerActive = _hasActiveChild && !isExpanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: headerActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : null,
          borderRadius: itemRadius,
          child: ListTile(
            leading: Icon(
              AppIcons.filled(
                entry.icon,
                active: headerActive || _hasActiveChild,
              ),
              color: headerActive ? AppColors.primary : AppColors.black,
            ),
            title: Text(
              entry.label,
              style: AppTextStyles.bodyText(context).copyWith(
                fontWeight: FontWeight.w500,
                color: headerActive ? AppColors.primary : AppColors.black,
              ),
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                AppIcons.filled(AppIcons.arrowDown, active: headerActive),
                color: headerActive ? AppColors.primary : AppColors.grey,
                size: AppResponsive.iconSize(context, factor: 0.9),
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: itemRadius),
            onTap: onGroupToggle,
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              for (final child in entry.children!)
                _DrawerLeafTile(
                  leaf: child,
                  itemRadius: itemRadius,
                  isSelected: child.id == selectedLeafId,
                  isNested: true,
                  onTap: () => onLeafTap(child.id),
                ),
            ],
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeOutCubic,
        ),
      ],
    );
  }
}

class _DrawerLeafTile extends StatelessWidget {
  const _DrawerLeafTile({
    required this.leaf,
    required this.itemRadius,
    required this.isSelected,
    required this.onTap,
    this.isNested = false,
  });

  final AppDrawerLeaf leaf;
  final BorderRadius itemRadius;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isNested ? AppSpacing.horizontalValue(context, 0.06) : 0,
      ),
      child: Material(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: itemRadius,
        child: ListTile(
          leading: leaf.icon == null
              ? null
              : Icon(
                  AppIcons.filled(leaf.icon!, active: isSelected),
                  color: isSelected ? AppColors.white : AppColors.black,
                ),
          title: Text(
            leaf.label,
            style: AppTextStyles.bodyText(context).copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.black,
            ),
          ),
          dense: isNested,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalValue(context, 0.04),
            vertical: isNested
                ? AppSpacing.verticalValue(context, 0.002)
                : AppSpacing.verticalValue(context, 0.004),
          ),
          shape: RoundedRectangleBorder(borderRadius: itemRadius),
          onTap: onTap,
        ),
      ),
    );
  }
}
