import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

/// Screens that show optional quick-note chips (hardcoded EN/UR labels).
enum NotesTagContext {
  obTaskNotes,
  obVisitNotes,
  obEndVisitWithoutOrder,
  dmShopClosed,
  dmWalkIn,
  dmJobNotes,
  dmHandover,
  dmRecordCollection,
  dmOrderDeliveryNotes,
  dmReturn,
}

/// Hardcoded quick-note labels per screen (translated via [AppTexts]).
///
/// OB visit tags are aligned to real field notes (stock available, next time,
/// shop closed, owner unavailable, no demand, etc.).
abstract class NotesTagCatalog {
  NotesTagCatalog._();

  static List<String> labelsFor(NotesTagContext context) {
    return switch (context) {
      NotesTagContext.obTaskNotes => [
        AppTexts.noteTagShopClosed,
        AppTexts.noteTagOwnerUnavailable,
        AppTexts.noteTagStockAvailable,
        AppTexts.noteTagNextTime,
        AppTexts.noteTagNoDemand,
        AppTexts.noteTagNotInterested,
        AppTexts.noteTagNeedCredit,
        AppTexts.noteTagPriceIssue,
      ],
      NotesTagContext.obVisitNotes => [
        AppTexts.noteTagStockAvailable,
        AppTexts.noteTagNextTime,
        AppTexts.noteTagPartialOrder,
        AppTexts.noteTagNeedCredit,
        AppTexts.noteTagPriceIssue,
        AppTexts.noteTagDeliveryRequest,
        AppTexts.noteTagFollowUpNeeded,
        AppTexts.noteTagNoDemand,
      ],
      NotesTagContext.obEndVisitWithoutOrder => [
        AppTexts.noteTagShopClosed,
        AppTexts.noteTagOwnerUnavailable,
        AppTexts.noteTagStockAvailable,
        AppTexts.noteTagNextTime,
        AppTexts.noteTagNoDemand,
        AppTexts.noteTagNotInterested,
        AppTexts.noteTagNeedCredit,
        AppTexts.noteTagPriceIssue,
      ],
      NotesTagContext.dmShopClosed => [
        AppTexts.noteTagShopClosed,
        AppTexts.noteTagOwnerUnavailable,
        AppTexts.noteTagWrongTiming,
        AppTexts.noteTagRetryLater,
        AppTexts.noteTagNextTime,
      ],
      NotesTagContext.dmWalkIn => [
        AppTexts.noteTagCashSale,
        AppTexts.noteTagNewCustomer,
        AppTexts.noteTagSurplusClearance,
        AppTexts.noteTagUrgentNeed,
      ],
      NotesTagContext.dmJobNotes => [
        AppTexts.noteTagReceiverChanged,
        AppTexts.noteTagPartialDelivery,
        AppTexts.noteTagAccessIssue,
        AppTexts.noteTagCustomerRequest,
      ],
      NotesTagContext.dmHandover => [
        AppTexts.noteTagFullCashHandover,
        AppTexts.noteTagChequeIncluded,
        AppTexts.noteTagShortCashExplained,
        AppTexts.noteTagOfficeCounted,
      ],
      NotesTagContext.dmRecordCollection => [
        AppTexts.noteTagPartialPayment,
        AppTexts.noteTagFullSettlement,
        AppTexts.noteTagBillCleared,
        AppTexts.noteTagBillPending,
        AppTexts.noteTagRecoveryReceived,
        AppTexts.noteTagChequeTaken,
        AppTexts.noteTagPromiseToPay,
      ],
      NotesTagContext.dmOrderDeliveryNotes => [
        AppTexts.noteTagDeliveredOk,
        AppTexts.noteTagPartialDelivery,
        AppTexts.noteTagDamagedGoods,
        AppTexts.noteTagCustomerRequest,
      ],
      NotesTagContext.dmReturn => [
        AppTexts.noteTagLeftoverStock,
        AppTexts.noteTagUndeliveredReturn,
        AppTexts.noteTagWarehouseCounted,
        AppTexts.noteTagShortageExplained,
      ],
    };
  }
}
