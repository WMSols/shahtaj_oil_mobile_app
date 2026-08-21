import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

enum UserRole { orderBooker, deliveryMan }

enum OrderStatus { draft, submitted, confirmed, delivered, cancelled }

enum DeliveryStatus { pending, pickedUp, inTransit, delivered, returned }

enum CollectionStatus { pending, collected, handedOver }

enum PaymentMethod { cash, cheque, bank }

enum CollectionMode { invoiceWise, batch }

enum HandoverStatus { pending, completed }

enum VisitStatus { checkedIn, checkedOut }

enum VisitOutcome { orderPlaced, endedWithoutOrder }

enum PresenceStatus { online, away, offline }

enum ShopStatus { pending, approved, rejected, active }

enum ShopVisitTag { visited, notVisited }

enum ShopType { cash, credit }

enum RouteStatus { notStarted, inProgress, completed }

enum TaskStatus { pending, inVisit, completed }

enum ObNotesPurpose { taskNotes, endVisitWithoutOrder, visitNotes }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.orderBooker => AppTexts.roleOrderBooker,
    UserRole.deliveryMan => AppTexts.roleDeliveryMan,
  };

  String get imageAsset => switch (this) {
    UserRole.orderBooker => AppImages.selectRoleOrderBooker,
    UserRole.deliveryMan => AppImages.selectRoleDeliveryMan,
  };

  String get subtitle => switch (this) {
    UserRole.orderBooker => AppTexts.roleOrderBookerSubtitle,
    UserRole.deliveryMan => AppTexts.roleDeliveryManSubtitle,
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

  static CollectionStatus fromApi(dynamic value) {
    final raw = value?.toString().trim().toLowerCase() ?? '';
    if (raw == 'handed_over' || raw == 'handover') {
      return CollectionStatus.handedOver;
    }
    return CollectionStatus.values.firstWhere(
      (status) => status.name == raw,
      orElse: () => CollectionStatus.pending,
    );
  }
}

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
    PaymentMethod.cash => AppTexts.dmPaymentCash,
    PaymentMethod.cheque => AppTexts.dmPaymentCheque,
    PaymentMethod.bank => AppTexts.dmPaymentBank,
  };

  Color get chipColor => switch (this) {
    PaymentMethod.cash => AppColors.success,
    PaymentMethod.cheque => AppColors.warning,
    PaymentMethod.bank => AppColors.primary,
  };

  static PaymentMethod fromApi(dynamic value) {
    final raw = value?.toString().trim().toLowerCase() ?? '';
    if (raw == 'bank_transfer' || raw == 'banktransfer' || raw == 'online') {
      return PaymentMethod.bank;
    }
    if (raw == 'check' || raw == 'checke') {
      return PaymentMethod.cheque;
    }
    return PaymentMethod.values.firstWhere(
      (method) => method.name == raw,
      orElse: () => PaymentMethod.cash,
    );
  }
}

extension CollectionModeX on CollectionMode {
  String get label => switch (this) {
    CollectionMode.invoiceWise => AppTexts.dmModeInvoiceWise,
    CollectionMode.batch => AppTexts.dmModeBatch,
  };

  Color get chipColor => switch (this) {
    CollectionMode.invoiceWise => AppColors.primary,
    CollectionMode.batch => AppColors.information,
  };

  static CollectionMode fromApi(dynamic value) {
    final raw = value?.toString().trim().toLowerCase() ?? '';
    if (raw == 'invoice_wise' || raw == 'invoicewise' || raw == 'invoice') {
      return CollectionMode.invoiceWise;
    }
    return CollectionMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => CollectionMode.batch,
    );
  }
}

extension HandoverStatusX on HandoverStatus {
  String get label => switch (this) {
    HandoverStatus.pending => AppTexts.dmHandoverStatusPending,
    HandoverStatus.completed => AppTexts.dmHandoverStatusCompleted,
  };

  Color get chipColor => switch (this) {
    HandoverStatus.pending => AppColors.warning,
    HandoverStatus.completed => AppColors.success,
  };

  static HandoverStatus fromApi(dynamic value) {
    final raw = value?.toString().trim().toLowerCase() ?? '';
    if (raw == 'done' || raw == 'complete') {
      return HandoverStatus.completed;
    }
    return HandoverStatus.values.firstWhere(
      (status) => status.name == raw,
      orElse: () => HandoverStatus.pending,
    );
  }
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

extension VisitOutcomeX on VisitOutcome {
  String get label => switch (this) {
    VisitOutcome.orderPlaced => AppTexts.obVisitOutcomeOrder,
    VisitOutcome.endedWithoutOrder => AppTexts.obVisitOutcomeNoOrder,
  };

  Color get chipColor => switch (this) {
    VisitOutcome.orderPlaced => AppColors.success,
    VisitOutcome.endedWithoutOrder => AppColors.warning,
  };
}

extension PresenceStatusX on PresenceStatus {
  String get label => switch (this) {
    PresenceStatus.online => AppTexts.statusOnline,
    PresenceStatus.away => AppTexts.statusAway,
    PresenceStatus.offline => AppTexts.statusOffline,
  };

  Color get chipColor => switch (this) {
    PresenceStatus.online => AppColors.success,
    PresenceStatus.away => AppColors.warning,
    PresenceStatus.offline => AppColors.textMuted,
  };

  static PresenceStatus fromApi(dynamic value) {
    final raw = value?.toString().trim().toLowerCase() ?? '';
    return PresenceStatus.values.firstWhere(
      (status) => status.name == raw,
      orElse: () => PresenceStatus.away,
    );
  }
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

extension ShopVisitTagX on ShopVisitTag {
  String get label => switch (this) {
    ShopVisitTag.visited => AppTexts.obVisitTagVisited,
    ShopVisitTag.notVisited => AppTexts.obVisitTagNotVisited,
  };

  Color get chipColor => switch (this) {
    ShopVisitTag.visited => AppColors.success,
    ShopVisitTag.notVisited => AppColors.warning,
  };

  static ShopVisitTag fromApi(dynamic value) {
    final raw = value?.toString().trim().toLowerCase() ?? '';
    if (raw == 'not_visited' || raw == 'notvisited') {
      return ShopVisitTag.notVisited;
    }
    return ShopVisitTag.visited;
  }
}

extension ShopTypeX on ShopType {
  String get label => switch (this) {
    ShopType.cash => AppTexts.shopTypeCash,
    ShopType.credit => AppTexts.shopTypeCredit,
  };

  Color get chipColor => switch (this) {
    ShopType.cash => AppColors.success,
    ShopType.credit => AppColors.primary,
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
    TaskStatus.completed => AppTexts.taskStatusCompleted,
  };

  Color get chipColor => switch (this) {
    TaskStatus.pending => AppColors.warning,
    TaskStatus.inVisit => AppColors.primary,
    TaskStatus.completed => AppColors.success,
  };
}
