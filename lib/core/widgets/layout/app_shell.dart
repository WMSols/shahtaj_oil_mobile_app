import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer.dart';

class AppShell<T extends AppShellController> extends GetView<T> {
  const AppShell({super.key});

  static const _transitionDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionService>();
    final roleLabel = session.role.value?.label ?? '';

    return Obx(() {
      final currentLeaf = controller.currentLeaf;

      return Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: AppColors.scaffoldBackground,
        drawer: AppDrawer(
          entries: controller.drawerEntries,
          selectedLeafId: controller.selectedLeafId.value,
          expandedGroupIds: controller.expandedGroupIds.toSet(),
          onLeafTap: controller.selectLeaf,
          onGroupToggle: controller.toggleGroup,
          roleLabel: roleLabel,
        ),
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(currentLeaf.label, style: AppTextStyles.heading(context)),
          leading: IconButton(
            icon: Icon(
              AppIcons.menu,
              color: AppColors.primary,
              size: AppResponsive.iconSize(context, factor: 1.5),
            ),
            onPressed: controller.openDrawer,
          ),
          actions: [AppSpacing.horizontal(context, 0.2)],
        ),
        body: AnimatedSwitcher(
          duration: _transitionDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<String>(currentLeaf.id),
            child: currentLeaf.screen,
          ),
        ),
      );
    });
  }
}
