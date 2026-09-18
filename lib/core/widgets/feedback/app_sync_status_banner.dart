import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';

/// Sticky sync strip under the app bar — same bar chrome as offline/location.
///
/// Shows day-bootstrap download, outbox syncing / pending / attention, then a
/// brief success flash when a flush clears the queue before sliding away.
class AppSyncStatusBanner extends StatefulWidget {
  const AppSyncStatusBanner({super.key});

  static const _completedHold = Duration(seconds: 2);

  @override
  State<AppSyncStatusBanner> createState() => _AppSyncStatusBannerState();
}

class _AppSyncStatusBannerState extends State<AppSyncStatusBanner> {
  Worker? _flushWorker;
  Timer? _completedTimer;
  bool _showCompleted = false;
  bool _wasFlushing = false;
  int _openWhenFlushStarted = 0;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SyncOutboxService>()) return;
    final outbox = Get.find<SyncOutboxService>();
    _wasFlushing = outbox.isFlushing.value;
    _flushWorker = ever(outbox.isFlushing, _onFlushingChanged);
  }

  void _onFlushingChanged(bool flushing) {
    if (!Get.isRegistered<SyncOutboxService>()) return;
    final outbox = Get.find<SyncOutboxService>();

    if (flushing && !_wasFlushing) {
      _openWhenFlushStarted = outbox.pendingCount.value;
      _completedTimer?.cancel();
      if (_showCompleted && mounted) {
        setState(() => _showCompleted = false);
      } else {
        _showCompleted = false;
      }
    } else if (!flushing && _wasFlushing) {
      final cleared =
          outbox.pendingCount.value == 0 && outbox.attentionCount.value == 0;
      if (cleared && _openWhenFlushStarted > 0) {
        _completedTimer?.cancel();
        if (mounted) setState(() => _showCompleted = true);
        _completedTimer = Timer(AppSyncStatusBanner._completedHold, () {
          if (!mounted) return;
          setState(() => _showCompleted = false);
        });
      }
    }
    _wasFlushing = flushing;
  }

  @override
  void dispose() {
    _flushWorker?.dispose();
    _completedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasOutbox = Get.isRegistered<SyncOutboxService>();
    final hasBootstrap = Get.isRegistered<ObDayBootstrapService>();
    if (!hasOutbox && !hasBootstrap) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final bootstrap = hasBootstrap ? Get.find<ObDayBootstrapService>() : null;
      final bootstrapping = bootstrap?.isRunning.value ?? false;
      final bootstrapMsg = bootstrap?.statusMessage.value;

      if (bootstrapping) {
        return AppSlideInBar(
          visible: true,
          child: AppToastBar(
            message: bootstrapMsg?.trim().isNotEmpty == true
                ? bootstrapMsg!
                : AppTexts.obDayBootstrapRunning,
            style: AppToastStyle.information,
          ),
        );
      }

      if (!hasOutbox) return const SizedBox.shrink();
      final outbox = Get.find<SyncOutboxService>();
      final syncing = outbox.isFlushing.value;
      final attention = outbox.attentionCount.value;
      final pending = outbox.pendingCount.value;

      if (_showCompleted && (syncing || pending > 0 || attention > 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_showCompleted) return;
          if (outbox.isFlushing.value ||
              outbox.pendingCount.value > 0 ||
              outbox.attentionCount.value > 0) {
            _completedTimer?.cancel();
            setState(() => _showCompleted = false);
          }
        });
      }

      final visible = syncing || attention > 0 || pending > 0 || _showCompleted;

      late final String message;
      late final AppToastStyle style;
      if (syncing) {
        message = AppTexts.syncBannerSyncing;
        style = AppToastStyle.information;
      } else if (_showCompleted) {
        message = AppTexts.syncBannerCompleted;
        style = AppToastStyle.success;
      } else if (attention > 0) {
        message = AppTexts.syncBannerNeedsAttention;
        style = AppToastStyle.error;
      } else {
        message = AppTexts.syncBannerPending(pending);
        style = AppToastStyle.warning;
      }

      return AppSlideInBar(
        visible: visible,
        child: visible
            ? GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.syncCenter),
                behavior: HitTestBehavior.opaque,
                child: AppToastBar(message: message, style: style),
              )
            : const SizedBox.shrink(),
      );
    });
  }
}
