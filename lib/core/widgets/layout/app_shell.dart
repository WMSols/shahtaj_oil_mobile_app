import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer.dart';

class AppShell<T extends AppShellController> extends GetView<T> {
  const AppShell({super.key});

  static const _transitionDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionService>();
    final localeService = Get.find<LocaleService>();
    final roleLabel = session.role.value?.label ?? '';
    final iconSize = AppResponsive.iconSize(context, factor: 1.5);

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
          leadingWidth: AppResponsive.screenWidth(context) * 0.1,
          leading: SizedBox(
            width: AppResponsive.screenWidth(context) * 0.1,
            child: Center(
              child: AppIconButton(
                icon: AppIcons.menu,
                iconColor: AppColors.primary,
                iconSize: iconSize,
                onTap: controller.openDrawer,
              ),
            ),
          ),
          actions: [
            AppIconButton(
              icon: AppIcons.language,
              iconColor: AppColors.primary,
              iconSize: iconSize,
              onTap: localeService.toggleLocale,
            ),
            AppSpacing.horizontal(context, 0.02),
          ],
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
