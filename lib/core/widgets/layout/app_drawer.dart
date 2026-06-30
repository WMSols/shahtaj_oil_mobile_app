import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';

typedef AppDrawerItem = ({
  IconData icon,
  String label,
  Widget screen,
  VoidCallback? initBinding,
});

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemTap,
    required this.roleLabel,
  });

  final List<AppDrawerItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemTap;
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
                  Obx(
                    () => Text(
                      session.user.value?.name ?? AppTexts.defaultUserName,
                      style: AppTextStyles.sectionTitle(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    roleLabel,
                    style: AppTextStyles.bodyText(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: ListView.builder(
                padding: AppSpacing.screenPadding(
                  context,
                ).copyWith(right: 0, left: 0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = index == selectedIndex;

                  return Material(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: itemRadius,
                    elevation: isSelected ? 10 : 0,
                    child: ListTile(
                      leading: Icon(
                        item.icon,
                        color: isSelected ? AppColors.white : AppColors.black,
                      ),
                      title: Text(
                        item.label,
                        style: AppTextStyles.bodyText(context).copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected ? AppColors.white : AppColors.black,
                        ),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: itemRadius),
                      onTap: () => onItemTap(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
