import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

enum UserRole { orderBooker, deliveryMan, recoveryMan }

enum OrderStatus { draft, submitted, confirmed, delivered, cancelled }

enum DeliveryStatus { pending, pickedUp, inTransit, delivered, returned }

enum CollectionStatus { pending, collected, handedOver }

enum VisitStatus { checkedIn, checkedOut }

enum ShopStatus { pending, approved, rejected, active }

enum ShopType { cash, credit }

enum RouteStatus { notStarted, inProgress, completed }

enum TaskStatus { pending, inVisit, skipped, completed }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.orderBooker => AppTexts.roleOrderBooker,
    UserRole.deliveryMan => AppTexts.roleDeliveryMan,
    UserRole.recoveryMan => AppTexts.roleRecoveryMan,
  };

  String get imageAsset => switch (this) {
    UserRole.orderBooker => AppImages.selectRoleOrderBooker,
    UserRole.deliveryMan => AppImages.selectRoleDeliveryMan,
    UserRole.recoveryMan => AppImages.selectRoleRecoveryMan,
  };

  String get subtitle => switch (this) {
    UserRole.orderBooker => AppTexts.roleOrderBookerSubtitle,
    UserRole.deliveryMan => AppTexts.roleDeliveryManSubtitle,
    UserRole.recoveryMan => AppTexts.roleRecoveryManSubtitle,
  };
}

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
    OrderStatus.draft => AppTexts.orderStatusDraft,
    OrderStatus.submitted => AppTexts.orderStatusSubmitted,
    OrderStatus.confirmed => AppTexts.orderStatusConfirmed,
    OrderStatus.delivered => AppTexts.orderStatusDelivered,
    OrderStatus.cancelled => AppTexts.orderStatusCancelled,
  };

  Color get chipColor => switch (this) {
    OrderStatus.delivered => AppColors.success,
    OrderStatus.submitted || OrderStatus.confirmed => AppColors.primary,
    OrderStatus.cancelled => AppColors.error,
    OrderStatus.draft => AppColors.textMuted,
  };
}

extension DeliveryStatusX on DeliveryStatus {
  String get label => switch (this) {
    DeliveryStatus.pending => AppTexts.deliveryStatusPending,
    DeliveryStatus.pickedUp => AppTexts.deliveryStatusPickedUp,
    DeliveryStatus.inTransit => AppTexts.deliveryStatusInTransit,
    DeliveryStatus.delivered => AppTexts.deliveryStatusDelivered,
    DeliveryStatus.returned => AppTexts.deliveryStatusReturned,
  };

  Color get chipColor => switch (this) {
    DeliveryStatus.delivered => AppColors.success,
    DeliveryStatus.inTransit => AppColors.primary,
    DeliveryStatus.pickedUp => AppColors.information,
    DeliveryStatus.returned => AppColors.error,
    DeliveryStatus.pending => AppColors.warning,
  };
}

extension CollectionStatusX on CollectionStatus {
  String get label => switch (this) {
    CollectionStatus.pending => AppTexts.collectionStatusPending,
    CollectionStatus.collected => AppTexts.collectionStatusCollected,
    CollectionStatus.handedOver => AppTexts.collectionStatusHandedOver,
  };

  Color get chipColor => switch (this) {
    CollectionStatus.handedOver => AppColors.success,
    CollectionStatus.collected => AppColors.primary,
    CollectionStatus.pending => AppColors.warning,
  };
}

extension VisitStatusX on VisitStatus {
  String get label => switch (this) {
    VisitStatus.checkedIn => AppTexts.visitStatusCheckedIn,
    VisitStatus.checkedOut => AppTexts.visitStatusCheckedOut,
  };

  Color get chipColor => switch (this) {
    VisitStatus.checkedOut => AppColors.success,
    VisitStatus.checkedIn => AppColors.primary,
  };
}

extension ShopStatusX on ShopStatus {
  String get label => switch (this) {
    ShopStatus.pending => AppTexts.shopStatusPending,
    ShopStatus.approved => AppTexts.shopStatusApproved,
    ShopStatus.rejected => AppTexts.shopStatusRejected,
    ShopStatus.active => AppTexts.shopStatusActive,
  };

  Color get chipColor => switch (this) {
    ShopStatus.approved => AppColors.success,
    ShopStatus.active => AppColors.primary,
    ShopStatus.rejected => AppColors.error,
    ShopStatus.pending => AppColors.warning,
  };
}

extension ShopTypeX on ShopType {
  String get label => switch (this) {
    ShopType.cash => AppTexts.shopTypeCash,
    ShopType.credit => AppTexts.shopTypeCredit,
  };
}

extension RouteStatusX on RouteStatus {
  String get label => switch (this) {
    RouteStatus.notStarted => AppTexts.routeStatusNotStarted,
    RouteStatus.inProgress => AppTexts.routeStatusInProgress,
    RouteStatus.completed => AppTexts.routeStatusCompleted,
  };

  Color get chipColor => switch (this) {
    RouteStatus.notStarted => AppColors.textMuted,
    RouteStatus.inProgress => AppColors.primary,
    RouteStatus.completed => AppColors.success,
  };
}

extension TaskStatusX on TaskStatus {
  String get label => switch (this) {
    TaskStatus.pending => AppTexts.taskStatusPending,
    TaskStatus.inVisit => AppTexts.taskStatusInVisit,
    TaskStatus.skipped => AppTexts.taskStatusSkipped,
    TaskStatus.completed => AppTexts.taskStatusCompleted,
  };

  Color get chipColor => switch (this) {
    TaskStatus.pending => AppColors.warning,
    TaskStatus.inVisit => AppColors.primary,
    TaskStatus.skipped => AppColors.textMuted,
    TaskStatus.completed => AppColors.success,
  };
}
