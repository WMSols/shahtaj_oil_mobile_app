import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';

/// Shared loading / error / empty / content branching for list screens.
class AppAsyncBody extends StatelessWidget {
  const AppAsyncBody({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.isEmpty,
    required this.child,
    this.errorMessage,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyImage = AppImages.empty,
    this.errorTitle,
    this.errorImage = AppImages.emptyError,
    this.onRefresh,
  });

  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final Widget child;
  final String? errorMessage;
  final String? emptyTitle;
  final String? emptySubtitle;
  final String emptyImage;
  final String? errorTitle;
  final String errorImage;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const AppLoader();

    if (hasError) {
      return AppEmptyState(
        title: errorTitle ?? AppTexts.emptyLoadFailedTitle,
        subtitle: errorMessage ?? AppTexts.emptyLoadFailedSubtitle,
        image: errorImage,
        onRefresh: onRefresh,
      );
    }

    if (isEmpty) {
      return AppEmptyState(
        title: emptyTitle ?? AppTexts.noDataYet,
        subtitle: emptySubtitle,
        image: emptyImage,
        onRefresh: onRefresh,
      );
    }

    if (onRefresh == null) return child;

    return RefreshIndicator(onRefresh: onRefresh!, child: child);
  }
}
