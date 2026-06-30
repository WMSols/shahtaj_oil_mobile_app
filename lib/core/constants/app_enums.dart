import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

enum UserRole { orderBooker, deliveryMan, recoveryMan }

enum OrderStatus { draft, submitted, confirmed, delivered, cancelled }

enum DeliveryStatus { pending, pickedUp, inTransit, delivered, returned }

enum CollectionStatus { pending, collected, handedOver }

enum VisitStatus { checkedIn, checkedOut }

enum ShopStatus { pending, approved, rejected, active }

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
}

extension DeliveryStatusX on DeliveryStatus {
  String get label => switch (this) {
    DeliveryStatus.pending => AppTexts.deliveryStatusPending,
    DeliveryStatus.pickedUp => AppTexts.deliveryStatusPickedUp,
    DeliveryStatus.inTransit => AppTexts.deliveryStatusInTransit,
    DeliveryStatus.delivered => AppTexts.deliveryStatusDelivered,
    DeliveryStatus.returned => AppTexts.deliveryStatusReturned,
  };
}

extension CollectionStatusX on CollectionStatus {
  String get label => switch (this) {
    CollectionStatus.pending => AppTexts.collectionStatusPending,
    CollectionStatus.collected => AppTexts.collectionStatusCollected,
    CollectionStatus.handedOver => AppTexts.collectionStatusHandedOver,
  };
}

extension VisitStatusX on VisitStatus {
  String get label => switch (this) {
    VisitStatus.checkedIn => AppTexts.visitStatusCheckedIn,
    VisitStatus.checkedOut => AppTexts.visitStatusCheckedOut,
  };
}

extension ShopStatusX on ShopStatus {
  String get label => switch (this) {
    ShopStatus.pending => AppTexts.shopStatusPending,
    ShopStatus.approved => AppTexts.shopStatusApproved,
    ShopStatus.rejected => AppTexts.shopStatusRejected,
    ShopStatus.active => AppTexts.shopStatusActive,
  };
}
