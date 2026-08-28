import 'package:get/get.dart';

class AppTexts {
  AppTexts._();

  // App
  static String get appName => 'appName'.tr;

  // Common buttons
  static String get login => 'login'.tr;
  static String get logout => 'logout'.tr;
  static String get submit => 'submit'.tr;
  static String get save => 'save'.tr;
  static String get cancel => 'cancel'.tr;
  static String get confirm => 'confirm'.tr;
  static String get viewAll => 'viewAll'.tr;
  static String get search => 'search'.tr;
  static String get back => 'back'.tr;
  static String get continueLabel => 'continueLabel'.tr;
  static String get done => 'done'.tr;
  static String get retry => 'retry'.tr;

  // Auth
  static String get signIn => 'signIn'.tr;
  static String get signInButton => 'signInButton'.tr;
  static String get switchRole => 'switchRole'.tr;
  static String get phone => 'phone'.tr;
  static String get email => 'email'.tr;
  static String get password => 'password'.tr;
  static String get passwordHint => 'passwordHint'.tr;
  static String get fullName => 'fullName'.tr;
  static String get emailHint => 'emailHint'.tr;
  static String get rememberMe => 'rememberMe'.tr;
  static String get authWelcomeSubtitle => 'authWelcomeSubtitle'.tr;
  static String get signingInAs => 'signingInAs'.tr;
  static String get broughtByPrefix => 'broughtByPrefix'.tr;
  static String get developerName => 'developerName'.tr;
  static String get allRightsReserved => 'allRightsReserved'.tr;
  static String get loginSuccessful => 'loginSuccessful'.tr;
  static String get logoutSuccessful => 'logoutSuccessful'.tr;
  static String get pressBackAgainToExit => 'pressBackAgainToExit'.tr;
  static String get loginCredentialsRequired => 'loginCredentialsRequired'.tr;
  static String get loginFailed => 'loginFailed'.tr;
  static String get moduleUiCompleted => 'moduleUiCompleted'.tr;
  static String get moduleUnderDevelopment => 'moduleUnderDevelopment'.tr;
  static String get selectYourRole => 'selectYourRole'.tr;
  static String get selectRoleBody => 'selectRoleBody'.tr;
  static String get defaultUserName => 'defaultUserName'.tr;
  static String get languageEnglish => 'languageEnglish'.tr;
  static String get languageUrdu => 'languageUrdu'.tr;

  /// Fixed labels for language picker buttons (not locale-dependent).
  static const String languageEnglishButton = 'English';
  static const String languageUrduButton = 'اردو';

  static String get changeLanguage => 'changeLanguage'.tr;
  static String get accountSettings => 'accountSettings'.tr;
  static String get getStarted => 'getStarted'.tr;
  static String get onboardingIntroTitle => 'onboardingIntroTitle'.tr;
  static String get onboardingIntroBody => 'onboardingIntroBody'.tr;
  static String get onboardingLanguageTitle => 'onboardingLanguageTitle'.tr;
  static String get onboardingLanguageBody => 'onboardingLanguageBody'.tr;
  static String get onboardingRoleTitle => 'onboardingRoleTitle'.tr;
  static String get onboardingRoleBody => 'onboardingRoleBody'.tr;

  static String copyright(int year) => 'copyright'.trParams({
    'year': '$year',
    'appName': appName,
    'rights': allRightsReserved,
  });

  static String roleWithLabel(String role) =>
      'roleWithLabel'.trParams({'role': role});

  static String obShopsDistance(int shops, String distanceKm) =>
      'obShopsDistance'.trParams({'shops': '$shops', 'distance': distanceKm});

  static String obShopsCount(int shops) =>
      'obShopsCount'.trParams({'shops': '$shops'});

  static String obVanStockSummary(int count) =>
      'obVanStockSummary'.trParams({'count': '$count'});
  static String dmVanStockSummary(int count) =>
      'dmVanStockSummary'.trParams({'count': '$count'});
  static String dmStockLoadedSummary(int count) =>
      'dmStockLoadedSummary'.trParams({'count': '$count'});
  static String dmStockOnHandSummary(int count) =>
      'dmStockOnHandSummary'.trParams({'count': '$count'});
  static String dmStockLoadedLabel(int count) =>
      'dmStockLoadedLabel'.trParams({'count': '$count'});
  static String dmStockOnHandCount(int count) =>
      'dmStockOnHandCount'.trParams({'count': '$count'});
  static String get dmStockOnHandLabel => 'dmStockOnHandLabel'.tr;
  static String get dmStockOnHandTitle => 'dmStockOnHandTitle'.tr;
  static String get dmOrderIdLabel => 'dmOrderIdLabel'.tr;

  // Splash

  // Navigation
  static String get navDashboard => 'navDashboard'.tr;
  static String get navWeeklySchedule => 'navWeeklySchedule'.tr;
  static String get navTodayTasks => 'navTodayTasks'.tr;
  static String get navShops => 'navShops'.tr;
  static String get navHistory => 'navHistory'.tr;
  static String get navDeliveryHistory => 'navDeliveryHistory'.tr;
  static String get navOrders => 'navOrders'.tr;
  static String get navDeliveries => 'navDeliveries'.tr;
  static String get navCollections => 'navCollections'.tr;
  static String get navHandover => 'navHandover'.tr;
  static String get navAccount => 'navAccount'.tr;

  // Dashboard
  static String homeGreetingHey(String name) =>
      'homeGreetingHey'.trParams({'name': name});

  static String get greetingMorning => 'greetingMorning'.tr;
  static String get greetingAfternoon => 'greetingAfternoon'.tr;
  static String get greetingEvening => 'greetingEvening'.tr;
  static String get greetingNight => 'greetingNight'.tr;
  static String get dashboardTitle => 'dashboardTitle'.tr;
  static String get obDashboardSubtitle => 'obDashboardSubtitle'.tr;
  static String get obTodaysRoute => 'obTodaysRoute'.tr;
  static String get obWeeklyScheduleTitle => 'obWeeklyScheduleTitle'.tr;
  static String get obTargets => 'obTargets'.tr;
  static String get obSnapshotVisited => 'obSnapshotVisited'.tr;
  static String get obSnapshotPending => 'obSnapshotPending'.tr;
  static String get obSnapshotOrders => 'obSnapshotOrders'.tr;

  static String obTargetsProgressPercent(int percent) =>
      'obTargetsProgressPercent'.trParams({'percent': '$percent'});
  static String get obTargetsDashboardSummary => 'obTargetsDashboardSummary'.tr;
  static String get obTargetTypeCollectiveQuantity =>
      'obTargetTypeCollectiveQuantity'.tr;
  static String get obTargetTypeCollectiveWeight =>
      'obTargetTypeCollectiveWeight'.tr;
  static String get obTargetTypeCombinedProduct =>
      'obTargetTypeCombinedProduct'.tr;
  static String get obTargetTypeProductQuantity =>
      'obTargetTypeProductQuantity'.tr;
  static String get obTargetTypeProductWeight => 'obTargetTypeProductWeight'.tr;
  static String get obTargetMeasureWeight => 'obTargetMeasureWeight'.tr;
  static String get obTargetMeasureQuantity => 'obTargetMeasureQuantity'.tr;
  static String get obCombinedTargetHeadlineHint =>
      'obCombinedTargetHeadlineHint'.tr;
  static String get obTargetProductsSection => 'obTargetProductsSection'.tr;
  static String get dmRecoveryTarget => 'dmRecoveryTarget'.tr;
  static String get dmDeliveryTarget => 'dmDeliveryTarget'.tr;
  static String get dmTargets => 'dmTargets'.tr;
  static String get dmDashboardSubtitle => 'dmDashboardSubtitle'.tr;
  static String get dmSnapshotCollected => 'dmSnapshotCollected'.tr;
  static String get dmSnapshotStillDue => 'dmSnapshotStillDue'.tr;
  static String get dmSnapshotCashInBag => 'dmSnapshotCashInBag'.tr;
  static String get dmRecentCollections => 'dmRecentCollections'.tr;
  static String get dmRecentActivity => 'dmRecentActivity'.tr;
  static String get dmNoRecentCollections => 'dmNoRecentCollections'.tr;
  static String get dmNoRecentActivity => 'dmNoRecentActivity'.tr;
  static String dmShopsDueCount(int count) =>
      'dmShopsDueCount'.trParams({'count': '$count'});
  static String dmReceiptsCount(int count) =>
      'dmReceiptsCount'.trParams({'count': '$count'});
  static String dmProgressPercent(int percent) =>
      'dmProgressPercent'.trParams({'percent': '$percent'});
  static String get dmNextPickupSubtitle => 'dmNextPickupSubtitle'.tr;
  static String dmHandoverNudgeSubtitle(String amount, String count) =>
      'dmHandoverNudgeSubtitle'.trParams({'amount': amount, 'count': count});
  static String get dmNextStopDelivery => 'dmNextStopDelivery'.tr;
  static String get dmNextStopCollection => 'dmNextStopCollection'.tr;
  static String get dmTargetsNoneSubtitle => 'dmTargetsNoneSubtitle'.tr;
  static String get dmStockEmptySubtitle => 'dmStockEmptySubtitle'.tr;
  static String get emptyNoStockTitle => 'emptyNoStockTitle'.tr;
  static String get dmTodayShopsTitle => 'dmTodayShopsTitle'.tr;
  static String get dmCollectionHistoryTitle => 'dmCollectionHistoryTitle'.tr;
  static String get dmSearchShopHint => 'dmSearchShopHint'.tr;
  static String get dmFilterHighDue => 'dmFilterHighDue'.tr;
  static String get dmFilterPartial => 'dmFilterPartial'.tr;
  static String get dmNoShopsDue => 'dmNoShopsDue'.tr;
  static String get dmNoShopsMatchSearch => 'dmNoShopsMatchSearch'.tr;
  static String dmInvoicesCount(int count) =>
      'dmInvoicesCount'.trParams({'count': '$count'});
  static String get dmOutstandingLabel => 'dmOutstandingLabel'.tr;
  static String get dmDueStatusLabel => 'dmDueStatusLabel'.tr;
  static String get dmHighDueChip => 'dmHighDueChip'.tr;
  static String get dmPartialChip => 'dmPartialChip'.tr;
  static String get obRecentOrders => 'obRecentOrders'.tr;
  static String get obOpenTodayTasks => 'obOpenTodayTasks'.tr;
  static String get obContinueTodayTasks => 'obContinueTodayTasks'.tr;
  static String get obLowStock => 'obLowStock'.tr;
  static String get obNoRouteAssigned => 'obNoRouteAssigned'.tr;
  static String get obNoRecentOrders => 'obNoRecentOrders'.tr;
  static String get routeStatusNotStarted => 'routeStatusNotStarted'.tr;
  static String get routeStatusInProgress => 'routeStatusInProgress'.tr;
  static String get routeStatusCompleted => 'routeStatusCompleted'.tr;
  static String get taskStatusPending => 'taskStatusPending'.tr;
  static String get taskStatusInVisit => 'taskStatusInVisit'.tr;
  static String get taskStatusCompleted => 'taskStatusCompleted'.tr;

  static String totalCount(int count) =>
      'totalCount'.trParams({'count': '$count'});

  static String userContact(String phone, String email) =>
      'userContact'.trParams({'phone': phone, 'email': email});

  // Order booker screens
  static String get obTodayTasksTitle => 'obTodayTasksTitle'.tr;
  static String get obShopOnboardingTitle => 'obShopOnboardingTitle'.tr;
  static String get obRegisterShopButton => 'obRegisterShopButton'.tr;
  static String get obSectionShopInformation => 'obSectionShopInformation'.tr;
  static String get obSectionOwnerDetails => 'obSectionOwnerDetails'.tr;
  static String get obSectionLocation => 'obSectionLocation'.tr;
  static String get obSectionRouteAssignment => 'obSectionRouteAssignment'.tr;
  static String get obSectionCreditBalance => 'obSectionCreditBalance'.tr;
  static String get obSectionDocumentsPhotos => 'obSectionDocumentsPhotos'.tr;
  static String get obShopNameLabel => 'obShopNameLabel'.tr;
  static String get obShopTypeLabel => 'obShopTypeLabel'.tr;
  static String get obShopTypeHint => 'obShopTypeHint'.tr;
  static String get shopTypeCash => 'shopTypeCash'.tr;
  static String get shopTypeCredit => 'shopTypeCredit'.tr;
  static String get obShopNameHint => 'obShopNameHint'.tr;
  static String get obOwnerNameLabel => 'obOwnerNameLabel'.tr;
  static String get obOwnerNameHint => 'obOwnerNameHint'.tr;
  static String get obOwnerCnicLabel => 'obOwnerCnicLabel'.tr;
  static String get obOwnerCnicHint => 'obOwnerCnicHint'.tr;
  static String get obOwnerPhoneLabel => 'obOwnerPhoneLabel'.tr;
  static String get obOwnerPhoneHint => 'obOwnerPhoneHint'.tr;
  static String get obUseCurrentLocation => 'obUseCurrentLocation'.tr;
  static String get obLocationNotCaptured => 'obLocationNotCaptured'.tr;
  static String get obZoneLabel => 'obZoneLabel'.tr;
  static String get obZoneHint => 'obZoneHint'.tr;
  static String get obRouteLabel => 'obRouteLabel'.tr;
  static String get obRouteHint => 'obRouteHint'.tr;
  static String get obCreditLimitLabel => 'obCreditLimitLabel'.tr;
  static String get obLegacyBalanceLabel => 'obLegacyBalanceLabel'.tr;
  static String get obOutstandingBalanceLabel => 'obOutstandingBalanceLabel'.tr;
  static String get obCreditRemainingLabel => 'obCreditRemainingLabel'.tr;
  static String get obShopCreditSummary => 'obShopCreditSummary'.tr;
  static String get obCreditLimitHint => 'obCreditLimitHint'.tr;
  static String get obLegacyBalanceHint => 'obLegacyBalanceHint'.tr;
  static String get obPickFromCamera => 'obPickFromCamera'.tr;
  static String get obPickFromGallery => 'obPickFromGallery'.tr;
  static String get obCnicFrontTitle => 'obCnicFrontTitle'.tr;
  static String get obCnicBackTitle => 'obCnicBackTitle'.tr;
  static String get obOwnerPhotoTitle => 'obOwnerPhotoTitle'.tr;
  static String get obShopExteriorTitle => 'obShopExteriorTitle'.tr;
  static String get obTakePortrait => 'obTakePortrait'.tr;
  static String get obCaptureShop => 'obCaptureShop'.tr;
  static String get obPhotoUploaded => 'obPhotoUploaded'.tr;
  static String get obLocationDisabled => 'obLocationDisabled'.tr;
  static String get obLocationPermissionDenied =>
      'obLocationPermissionDenied'.tr;
  static String get obLocationFetchFailed => 'obLocationFetchFailed'.tr;
  static String get obShopRegisteredSuccess => 'obShopRegisteredSuccess'.tr;
  static String get obRegisterShopHelpTitle => 'obRegisterShopHelpTitle'.tr;
  static String get obRegisterShopHelpBody => 'obRegisterShopHelpBody'.tr;
  static String get obRegisterShopResetTitle => 'obRegisterShopResetTitle'.tr;
  static String get obRegisterShopResetMessage =>
      'obRegisterShopResetMessage'.tr;
  static String get obMyShopsTitle => 'obMyShopsTitle'.tr;
  static String get obRegisteredShopsTitle => 'obRegisteredShopsTitle'.tr;
  static String get obSearchShopHint => 'obSearchShopHint'.tr;
  static String get obSearchTaskHint => 'obSearchTaskHint'.tr;
  static String get obSearchVisitHint => 'obSearchVisitHint'.tr;
  static String get obShopsFilterAll => 'obShopsFilterAll'.tr;
  static String get obNeedsSetupFilter => 'obNeedsSetupFilter'.tr;
  static String get obShopHighlighted => 'obShopHighlighted'.tr;
  static String get obNoTasksMatchSearch => 'obNoTasksMatchSearch'.tr;
  static String get obNoVisitsMatchSearch => 'obNoVisitsMatchSearch'.tr;
  static String obHistoryTotals(int count, String total) =>
      'obHistoryTotals'.trParams({'count': '$count', 'total': total});
  static String obOrderNumberValue(String number) =>
      'obOrderNumberValue'.trParams({'number': number});
  static String get obAddressLabel => 'obAddressLabel'.tr;
  static String get obVisitTagLabel => 'obVisitTagLabel'.tr;
  static String get obShopSetupLabel => 'obShopSetupLabel'.tr;
  static String get obShopSetupRequired => 'obShopSetupRequired'.tr;
  static String get obShopSetupRequiredBanner => 'obShopSetupRequiredBanner'.tr;
  static String obShopMissingFieldsCount(int count) =>
      'obShopMissingFieldsCount'.trParams({'count': '$count'});
  static String get obShopMapSection => 'obShopMapSection'.tr;
  static String get obScheduleToday => 'obScheduleToday'.tr;
  static String get obTargetAtRisk => 'obTargetAtRisk'.tr;
  static String get obTargetSortProgressLow => 'obTargetSortProgressLow'.tr;
  static String get obTargetSortProgressHigh => 'obTargetSortProgressHigh'.tr;
  static String get obTargetSortDateEnd => 'obTargetSortDateEnd'.tr;
  static String get obTargetSortType => 'obTargetSortType'.tr;
  static String obShopOwner(String name) =>
      'obShopOwner'.trParams({'name': name});
  static String get obNoShopsFound => 'obNoShopsFound'.tr;
  static String get obShopDetailTitle => 'obShopDetailTitle'.tr;
  static String get obShopDetailsSection => 'obShopDetailsSection'.tr;
  static String get obVerificationPhotosSection =>
      'obVerificationPhotosSection'.tr;
  static String get obPhoneNumberLabel => 'obPhoneNumberLabel'.tr;
  static String get obLocationLabel => 'obLocationLabel'.tr;
  static String get obCallOwner => 'obCallOwner'.tr;
  static String get obDirections => 'obDirections'.tr;
  static String get obCreateOrderButton => 'obCreateOrderButton'.tr;
  static String get obCheckInToShop => 'obCheckInToShop'.tr;
  static String get obShopCannotOrderUntilApproved =>
      'obShopCannotOrderUntilApproved'.tr;
  static String get obShopVisitActiveElsewhere =>
      'obShopVisitActiveElsewhere'.tr;
  static String get obShopNotOnRouteToday => 'obShopNotOnRouteToday'.tr;
  static String get obShopCheckInBeforeOrder => 'obShopCheckInBeforeOrder'.tr;
  static String get backOnline => 'backOnline'.tr;
  static String get statusOnline => 'statusOnline'.tr;
  static String get statusAway => 'statusAway'.tr;
  static String get statusOffline => 'statusOffline'.tr;
  static String get obShopNotFound => 'obShopNotFound'.tr;
  static String get obCnicFrontLabel => 'obCnicFrontLabel'.tr;
  static String get obCnicBackLabel => 'obCnicBackLabel'.tr;
  static String get obOwnerPhotoLabel => 'obOwnerPhotoLabel'.tr;
  static String get obShopExteriorLabel => 'obShopExteriorLabel'.tr;
  static String get obCheckInTitle => 'obCheckInTitle'.tr;
  static String get obTasksSection => 'obTasksSection'.tr;
  static String get obTaskCheckIn => 'obTaskCheckIn'.tr;
  static String get obTaskNotes => 'obTaskNotes'.tr;
  static String get obTaskNotesHint => 'obTaskNotesHint'.tr;
  static String obTaskNotePreview(String note) =>
      'obTaskNotePreview'.trParams({'note': note});
  static String get obActiveVisitTitle => 'obActiveVisitTitle'.tr;
  static String get obFieldWorkTitle => 'obFieldWorkTitle'.tr;
  static String get obResumeVisit => 'obResumeVisit'.tr;
  static String get obNoTasksToday => 'obNoTasksToday'.tr;
  static String get obCheckInSuccess => 'obCheckInSuccess'.tr;
  static String get obTaskNotFound => 'obTaskNotFound'.tr;
  static String get obVisitTagVisited => 'obVisitTagVisited'.tr;
  static String get obVisitTagNotVisited => 'obVisitTagNotVisited'.tr;
  static String get obShopVerifyOnSiteContext => 'obShopVerifyOnSiteContext'.tr;
  static String get obShopVerifiedSuccess => 'obShopVerifiedSuccess'.tr;
  static String get obShopExteriorRequired => 'obShopExteriorRequired'.tr;
  static String get obPhotoRequired => 'obPhotoRequired'.tr;

  static String obTasksProgress(int completed, int total) => 'obTasksProgress'
      .trParams({'completed': '$completed', 'total': '$total'});

  static String obActiveVisitAt(String shopName) =>
      'obActiveVisitAt'.trParams({'shop': shopName});

  static String obTaskSequence(int sequence) =>
      'obTaskSequence'.trParams({'sequence': '$sequence'});
  static String get obOrderCreateTitle => 'obOrderCreateTitle'.tr;
  static String get obProductsSection => 'obProductsSection'.tr;
  static String get obCartSection => 'obCartSection'.tr;
  static String get obNoProductsFound => 'obNoProductsFound'.tr;
  static String get obAddProductsToStart => 'obAddProductsToStart'.tr;
  static String get obAddToCart => 'obAddToCart'.tr;
  static String get obAlreadyInCart => 'obAlreadyInCart'.tr;
  static String get obPlaceOrder => 'obPlaceOrder'.tr;
  static String get obPlaceOrderConfirmMessage =>
      'obPlaceOrderConfirmMessage'.tr;
  static String get obEndVisitWithoutOrder => 'obEndVisitWithoutOrder'.tr;

  static String get obEndVisitRequiresEmptyCart =>
      'obEndVisitRequiresEmptyCart'.tr;

  static String get obNoRoutesInZone => 'obNoRoutesInZone'.tr;
  static String get obSaveVisitNotes => 'obSaveVisitNotes'.tr;
  static String get obVisitNotesHint => 'obVisitNotesHint'.tr;
  static String get obEndVisitTitle => 'obEndVisitTitle'.tr;
  static String get obEndVisitNotesHint => 'obEndVisitNotesHint'.tr;
  static String get obActiveVisitMissing => 'obActiveVisitMissing'.tr;
  static String get obOrderPlacedSuccess => 'obOrderPlacedSuccess'.tr;
  static String get obVisitClosedSuccess => 'obVisitClosedSuccess'.tr;
  static String get obLeaveVisitTitle => 'obLeaveVisitTitle'.tr;
  static String get obLeaveVisitMessage => 'obLeaveVisitMessage'.tr;
  static String get obLeaveNotesTitle => 'obLeaveNotesTitle'.tr;
  static String get obLeaveNotesMessage => 'obLeaveNotesMessage'.tr;
  static String get obVisitMismatch => 'obVisitMismatch'.tr;
  static String get obSearchProductHint => 'obSearchProductHint'.tr;
  static String get obSubtotal => 'obSubtotal'.tr;
  static String get obCartQuantityHint => 'obCartQuantityHint'.tr;
  static String obCartQuantityInputHint(String max, String product) =>
      'obCartQuantityInputHint'.trParams({'max': max, 'product': product});
  static String get obCartPriceHint => 'obCartPriceHint'.tr;
  static String get obTotalLabel => 'obTotalLabel'.tr;

  static String obNotEnoughStock(String available) =>
      'obNotEnoughStock'.trParams({'available': available});

  static String obVisitLoadedFor(int visitId) =>
      'obVisitLoadedFor'.trParams({'visitId': '$visitId'});

  static String obQtyBookable(String qty, String unit) =>
      'obQtyBookable'.trParams({'qty': qty, 'unit': unit});

  static String get obOrderDetailTitle => 'obOrderDetailTitle'.tr;
  static String get obVisitDetailTitle => 'obVisitDetailTitle'.tr;
  static String get obNoVisitsFound => 'obNoVisitsFound'.tr;
  static String get obVisitNotFound => 'obVisitNotFound'.tr;
  static String get obVisitsFilterAll => 'obVisitsFilterAll'.tr;
  static String get obVisitFilterDateFrom => 'obVisitFilterDateFrom'.tr;
  static String get obVisitFilterDateTo => 'obVisitFilterDateTo'.tr;
  static String get obVisitClearDates => 'obVisitClearDates'.tr;
  static String get obVisitInfoSection => 'obVisitInfoSection'.tr;
  static String get obVisitLinesSection => 'obVisitLinesSection'.tr;
  static String get obVisitOutcomeLabel => 'obVisitOutcomeLabel'.tr;
  static String get obVisitCheckInAt => 'obVisitCheckInAt'.tr;
  static String get obVisitCheckOutAt => 'obVisitCheckOutAt'.tr;
  static String get obVisitOutcomeOrder => 'obVisitOutcomeOrder'.tr;
  static String get obVisitOutcomeNoOrder => 'obVisitOutcomeNoOrder'.tr;
  static String get obViewOrder => 'obViewOrder'.tr;
  static String get obOrderNumberLabel => 'obOrderNumberLabel'.tr;

  // Delivery man screens
  static String get dmPickupTitle => 'dmPickupTitle'.tr;
  static String get dmVanStockTitle => 'dmVanStockTitle'.tr;
  static String get dmVanStockItems => 'dmVanStockItems'.tr;
  static String get dmVanStatusLabel => 'dmVanStatusLabel'.tr;
  static String get dmVanStatusNotLoaded => 'dmVanStatusNotLoaded'.tr;
  static String get dmVanStatusLoaded => 'dmVanStatusLoaded'.tr;
  static String get dmVanStatusUnloaded => 'dmVanStatusUnloaded'.tr;
  static String dmVanExpectedCount(int count) =>
      'dmVanExpectedCount'.trParams({'count': '$count'});
  static String get dmVanLoadAll => 'dmVanLoadAll'.tr;
  static String get dmVanUnloadAll => 'dmVanUnloadAll'.tr;
  static String get dmVanConfirmLoad => 'dmVanConfirmLoad'.tr;
  static String get dmVanConfirmUnload => 'dmVanConfirmUnload'.tr;
  static String get dmVanCloseEmpty => 'dmVanCloseEmpty'.tr;
  static String get dmVanLoadDone => 'dmVanLoadDone'.tr;
  static String get dmVanUnloadDone => 'dmVanUnloadDone'.tr;
  static String get dmVanLoadConfirmed => 'dmVanLoadConfirmed'.tr;
  static String get dmVanUnloadConfirmed => 'dmVanUnloadConfirmed'.tr;
  static String get dmVanNotesHint => 'dmVanNotesHint'.tr;
  static String get dmVanLoadQtyLabel => 'dmVanLoadQtyLabel'.tr;
  static String get dmVanUnloadQtyLabel => 'dmVanUnloadQtyLabel'.tr;
  static String get dmVanUnloadQtyHint => 'dmVanUnloadQtyHint'.tr;
  static String get dmVanHistoryTitle => 'dmVanHistoryTitle'.tr;
  static String get dmVanHistoryLoad => 'dmVanHistoryLoad'.tr;
  static String get dmVanHistoryUnload => 'dmVanHistoryUnload'.tr;
  static String dmVanHistoryQty(int qty, int skus) =>
      'dmVanHistoryQty'.trParams({'qty': '$qty', 'skus': '$skus'});
  static String get dmNextUnloadSubtitle => 'dmNextUnloadSubtitle'.tr;
  static String get dmDeliverTitle => 'dmDeliverTitle'.tr;
  static String get dmDeliveryDetailTitle => 'dmDeliveryDetailTitle'.tr;
  static String get dmReturnTitle => 'dmReturnTitle'.tr;
  static String get dmOrderDetailTitle => 'dmOrderDetailTitle'.tr;
  static String get dmPickupRequired => 'dmPickupRequired'.tr;
  static String get dmPickupDone => 'dmPickupDone'.tr;
  static String get dmGoToPickup => 'dmGoToPickup'.tr;
  static String get dmContinueDeliveries => 'dmContinueDeliveries'.tr;
  static String get dmConfirmPickup => 'dmConfirmPickup'.tr;
  static String get dmNoInTransitOrders => 'dmNoInTransitOrders'.tr;
  static String get dmStartDelivery => 'dmStartDelivery'.tr;
  static String get dmConfirmDelivery => 'dmConfirmDelivery'.tr;
  static String get dmReceiverNameLabel => 'dmReceiverNameLabel'.tr;
  static String get dmReceiverNameHint => 'dmReceiverNameHint'.tr;
  static String get dmDeliveryNotesHint => 'dmDeliveryNotesHint'.tr;
  static String get dmProofPhotoTitle => 'dmProofPhotoTitle'.tr;
  static String get dmProofPhotoSubtitle => 'dmProofPhotoSubtitle'.tr;
  static String get dmProofPhotoRequired => 'dmProofPhotoRequired'.tr;
  static String get dmOrderLinesSection => 'dmOrderLinesSection'.tr;
  static String get dmTimelineSection => 'dmTimelineSection'.tr;
  static String get dmOrderedQty => 'dmOrderedQty'.tr;
  static String get dmLoadedQty => 'dmLoadedQty'.tr;
  static String get dmDeliveredQty => 'dmDeliveredQty'.tr;
  static String get dmRejectedQty => 'dmRejectedQty'.tr;
  static String get dmLeftoverQty => 'dmLeftoverQty'.tr;
  static String get dmLoadedQtyHint => 'dmLoadedQtyHint'.tr;
  static String get dmDeliveredQtyHint => 'dmDeliveredQtyHint'.tr;
  static String get dmInvalidQuantity => 'dmInvalidQuantity'.tr;
  static String get dmPickupBeforeDelivery => 'dmPickupBeforeDelivery'.tr;
  static String get dmDeliverySubmitted => 'dmDeliverySubmitted'.tr;
  static String get dmDeliveryStarted => 'dmDeliveryStarted'.tr;
  static String get dmPickupConfirmed => 'dmPickupConfirmed'.tr;
  static String get dmReturnSubmitted => 'dmReturnSubmitted'.tr;
  static String get dmReturnAlreadySubmitted => 'dmReturnAlreadySubmitted'.tr;
  static String get dmReceiverRequired => 'dmReceiverRequired'.tr;
  static String get dmNoActiveOrdersForReturn => 'dmNoActiveOrdersForReturn'.tr;
  static String get dmLeftoverStock => 'dmLeftoverStock'.tr;
  static String get dmNotesHint => 'dmNotesHint'.tr;
  static String get dmWarehouse => 'dmWarehouse'.tr;
  static String get dmVehicle => 'dmVehicle'.tr;
  static String get dmShiftDate => 'dmShiftDate'.tr;
  static String get dmShopLabel => 'dmShopLabel'.tr;
  static String get dmAddressLabel => 'dmAddressLabel'.tr;
  static String get dmItemsLabel => 'dmItemsLabel'.tr;
  static String get dmAmountLabel => 'dmAmountLabel'.tr;
  static String get dmDateLabel => 'dmDateLabel'.tr;
  static String get dmPickupItems => 'dmPickupItems'.tr;
  static String get dmTodaySummary => 'dmTodaySummary'.tr;
  static String dmItemsCount(int count) =>
      'dmItemsCount'.trParams({'count': '$count'});
  static String dmWarehouseLabel(String warehouse) =>
      'dmWarehouseLabel'.trParams({'warehouse': warehouse});
  static String dmVehicleLabel(String vehicle) =>
      'dmVehicleLabel'.trParams({'vehicle': vehicle});
  static String dmShiftDateLabel(String date) =>
      'dmShiftDateLabel'.trParams({'date': date});

  // Recovery screens
  static String get dmShopInvoicesTitle => 'dmShopInvoicesTitle'.tr;
  static String get dmShopOutstandingTitle => 'dmShopOutstandingTitle'.tr;
  static String get dmRecordCollectionTitle => 'dmRecordCollectionTitle'.tr;
  static String get dmHandoverDetailTitle => 'dmHandoverDetailTitle'.tr;
  static String get dmTotalOutstanding => 'dmTotalOutstanding'.tr;
  static String get dmOpenInvoices => 'dmOpenInvoices'.tr;
  static String get dmNoOpenInvoices => 'dmNoOpenInvoices'.tr;
  static String get dmNoOpenInvoicesSubtitle => 'dmNoOpenInvoicesSubtitle'.tr;
  static String get dmCollectSelected => 'dmCollectSelected'.tr;
  static String get dmBatchPayment => 'dmBatchPayment'.tr;
  static String get dmSelectAll => 'dmSelectAll'.tr;
  static String get dmDeselectAll => 'dmDeselectAll'.tr;
  static String get dmSelectInvoicesHint => 'dmSelectInvoicesHint'.tr;
  static String dmSelectedCount(int count) =>
      'dmSelectedCount'.trParams({'count': '$count'});
  static String get dmInvoiceRemaining => 'dmInvoiceRemaining'.tr;
  static String get dmInvoiceOriginal => 'dmInvoiceOriginal'.tr;
  static String get dmCallShop => 'dmCallShop'.tr;
  static String get dmDirections => 'dmDirections'.tr;
  static String get dmNoPhoneToCall => 'dmNoPhoneToCall'.tr;
  static String get dmNoLocationForDirections => 'dmNoLocationForDirections'.tr;
  static String get emptyNoInvoicesTitle => 'emptyNoInvoicesTitle'.tr;
  static String get dmPaymentCash => 'dmPaymentCash'.tr;
  static String get dmPaymentCheque => 'dmPaymentCheque'.tr;
  static String get dmPaymentBank => 'dmPaymentBank'.tr;
  static String get dmModeInvoiceWise => 'dmModeInvoiceWise'.tr;
  static String get dmModeBatch => 'dmModeBatch'.tr;
  static String get dmHandoverStatusPending => 'dmHandoverStatusPending'.tr;
  static String get dmHandoverStatusCompleted => 'dmHandoverStatusCompleted'.tr;
  static String get dmPaymentMethod => 'dmPaymentMethod'.tr;
  static String get dmCollectAmount => 'dmCollectAmount'.tr;
  static String get dmFillRemaining => 'dmFillRemaining'.tr;
  static String get dmBatchAmountHint => 'dmBatchAmountHint'.tr;
  static String get dmAmountRequired => 'dmAmountRequired'.tr;
  static String get dmAmountExceedsRemaining => 'dmAmountExceedsRemaining'.tr;
  static String get dmChequeNumber => 'dmChequeNumber'.tr;
  static String get dmChequeNumberHint => 'dmChequeNumberHint'.tr;
  static String get dmChequeNumberRequired => 'dmChequeNumberRequired'.tr;
  static String get dmBankReference => 'dmBankReference'.tr;
  static String get dmBankReferenceHint => 'dmBankReferenceHint'.tr;
  static String get dmBankReferenceRequired => 'dmBankReferenceRequired'.tr;
  static String get dmBankScreenshotTitle => 'dmBankScreenshotTitle'.tr;
  static String get dmBankScreenshotSubtitle => 'dmBankScreenshotSubtitle'.tr;
  static String get dmCollectionNotes => 'dmCollectionNotes'.tr;
  static String get dmCollectionNotesHint => 'dmCollectionNotesHint'.tr;
  static String get dmConfirmCollection => 'dmConfirmCollection'.tr;
  static String dmConfirmCollectionMessage(
    String shop,
    String amount,
    String method,
  ) => 'dmConfirmCollectionMessage'.trParams({
    'shop': shop,
    'amount': amount,
    'method': method,
  });
  static String dmCollectionRecorded(String receipt) =>
      'dmCollectionRecorded'.trParams({'receipt': receipt});
  static String get dmCollectionFailed => 'dmCollectionFailed'.tr;
  static String get dmCollectionDetailTitle => 'dmCollectionDetailTitle'.tr;
  static String get dmSearchCollectionHint => 'dmSearchCollectionHint'.tr;
  static String get dmNoCollectionsMatchSearch =>
      'dmNoCollectionsMatchSearch'.tr;
  static String get dmCollectionNotFound => 'dmCollectionNotFound'.tr;
  static String dmHistoryTotals(int count, String total) =>
      'dmHistoryTotals'.trParams({'count': '$count', 'total': total});
  static String get dmReceiptNumber => 'dmReceiptNumber'.tr;
  static String get dmCollectedAt => 'dmCollectedAt'.tr;
  static String get dmCollectionStatus => 'dmCollectionStatus'.tr;
  static String get dmCollectionMode => 'dmCollectionMode'.tr;
  static String get dmCollectionAllocations => 'dmCollectionAllocations'.tr;
  static String get dmUnallocatedBatch => 'dmUnallocatedBatch'.tr;
  static String get dmUnallocatedBatchHint => 'dmUnallocatedBatchHint'.tr;
  static String get dmHandoverTitle => 'dmHandoverTitle'.tr;
  static String get dmHandoverConfirmTitle => 'dmHandoverConfirmTitle'.tr;
  static String get dmBagCash => 'dmBagCash'.tr;
  static String get dmBagCheque => 'dmBagCheque'.tr;
  static String get dmBagTotal => 'dmBagTotal'.tr;
  static String get dmPendingHandover => 'dmPendingHandover'.tr;
  static String get dmRecentHandovers => 'dmRecentHandovers'.tr;
  static String get dmNoBagCollections => 'dmNoBagCollections'.tr;
  static String get dmNoBagCollectionsSubtitle =>
      'dmNoBagCollectionsSubtitle'.tr;
  static String get dmNoHandoversYet => 'dmNoHandoversYet'.tr;
  static String get dmHandOverBag => 'dmHandOverBag'.tr;
  static String get dmCountedCash => 'dmCountedCash'.tr;
  static String get dmCountedCashHint => 'dmCountedCashHint'.tr;
  static String get dmCashierName => 'dmCashierName'.tr;
  static String get dmCashierNameHint => 'dmCashierNameHint'.tr;
  static String get dmHandoverNotes => 'dmHandoverNotes'.tr;
  static String get dmHandoverNotesHint => 'dmHandoverNotesHint'.tr;
  static String get dmCashCountMismatch => 'dmCashCountMismatch'.tr;
  static String get dmCashierRequired => 'dmCashierRequired'.tr;
  static String get dmBagEmpty => 'dmBagEmpty'.tr;
  static String get dmConfirmHandover => 'dmConfirmHandover'.tr;
  static String dmConfirmHandoverMessage(String amount, String count) =>
      'dmConfirmHandoverMessage'.trParams({'amount': amount, 'count': count});
  static String dmHandoverRecorded(String reference) =>
      'dmHandoverRecorded'.trParams({'reference': reference});
  static String get dmHandoverFailed => 'dmHandoverFailed'.tr;
  static String get dmHandoverNotFound => 'dmHandoverNotFound'.tr;
  static String get dmHandoverReference => 'dmHandoverReference'.tr;
  static String get dmHandoverAt => 'dmHandoverAt'.tr;
  static String get dmHandoverCollections => 'dmHandoverCollections'.tr;
  static String dmHandoverReceiptsCount(int count) =>
      'dmHandoverReceiptsCount'.trParams({'count': '$count'});
  static String get emptyNoHandoverTitle => 'emptyNoHandoverTitle'.tr;

  // Common labels
  static String get or => 'or'.tr;
  static String get view => 'view'.tr;
  static String get tapToUploadImages => 'tapToUploadImages'.tr;
  static String get userId => 'userId'.tr;
  static String get name => 'name'.tr;

  static String filesTotal(int count) =>
      'filesTotal'.trParams({'count': '$count'});

  static String fileLabel(int index, String name) =>
      'fileLabel'.trParams({'index': '$index', 'name': name});

  static String keyValue(String key, String value) =>
      'keyValue'.trParams({'key': key, 'value': value});

  static String descriptionLine(String description) =>
      'descriptionLine'.trParams({'description': description});

  static String fileSizeMb(String sizeMb) =>
      'fileSizeMb'.trParams({'sizeMb': sizeMb});

  static String minsAgo(int minutes) =>
      'minsAgo'.trParams({'minutes': '$minutes'});

  static String hrsAgo(int hours) => 'hrsAgo'.trParams({'hours': '$hours'});

  static String daysAgo(int days) => 'daysAgo'.trParams({'days': '$days'});

  // Notifications

  // Profile
  static String get accountDetails => 'accountDetails'.tr;
  static String get role => 'role'.tr;
  static String get reportProblemTitle => 'reportProblemTitle'.tr;
  static String get reportProblemWhatWrong => 'reportProblemWhatWrong'.tr;
  static String get reportProblemDetailsHint => 'reportProblemDetailsHint'.tr;
  static String get reportProblemNeedChipOrText =>
      'reportProblemNeedChipOrText'.tr;
  static String get reportProblemOtherNeedText =>
      'reportProblemOtherNeedText'.tr;
  static String get reportProblemSent => 'reportProblemSent'.tr;
  static String get reportProblemChipRoadClosed =>
      'reportProblemChipRoadClosed'.tr;
  static String get reportProblemChipWrongRoute =>
      'reportProblemChipWrongRoute'.tr;
  static String get reportProblemChipShopClosed =>
      'reportProblemChipShopClosed'.tr;
  static String get reportProblemChipShopLocationWrong =>
      'reportProblemChipShopLocationWrong'.tr;
  static String get reportProblemChipAppNotWorking =>
      'reportProblemChipAppNotWorking'.tr;
  static String get reportProblemChipOther => 'reportProblemChipOther'.tr;
  static String get reportProblemChipNoOrder => 'reportProblemChipNoOrder'.tr;
  static String get reportProblemChipShopSaidNo =>
      'reportProblemChipShopSaidNo'.tr;
  static String get reportProblemChipShopInfoWrong =>
      'reportProblemChipShopInfoWrong'.tr;
  static String get reportProblemChipProductProblem =>
      'reportProblemChipProductProblem'.tr;
  static String get reportProblemChipStockShort =>
      'reportProblemChipStockShort'.tr;
  static String get reportProblemChipStockDamaged =>
      'reportProblemChipStockDamaged'.tr;
  static String get reportProblemChipWrongStock =>
      'reportProblemChipWrongStock'.tr;
  static String get reportProblemChipVehicleProblem =>
      'reportProblemChipVehicleProblem'.tr;
  static String get reportProblemChipShopRefusedDelivery =>
      'reportProblemChipShopRefusedDelivery'.tr;
  static String get reportProblemChipCollectionProblem =>
      'reportProblemChipCollectionProblem'.tr;
  static String get reportProblemChipHandoverProblem =>
      'reportProblemChipHandoverProblem'.tr;

  // Roles
  static String get roleOrderBooker => 'roleOrderBooker'.tr;
  static String get roleOrderBookerSubtitle => 'roleOrderBookerSubtitle'.tr;
  static String get roleDeliveryMan => 'roleDeliveryMan'.tr;
  static String get roleDeliveryManSubtitle => 'roleDeliveryManSubtitle'.tr;

  // Date/time
  static String get selectDateTime => 'selectDateTime'.tr;
  static String get selectDate => 'selectDate'.tr;
  static String get selectTime => 'selectTime'.tr;

  // Month names
  static String get monthJanuary => 'monthJanuary'.tr;
  static String get monthFebruary => 'monthFebruary'.tr;
  static String get monthMarch => 'monthMarch'.tr;
  static String get monthApril => 'monthApril'.tr;
  static String get monthMay => 'monthMay'.tr;
  static String get monthJune => 'monthJune'.tr;
  static String get monthJuly => 'monthJuly'.tr;
  static String get monthAugust => 'monthAugust'.tr;
  static String get monthSeptember => 'monthSeptember'.tr;
  static String get monthOctober => 'monthOctober'.tr;
  static String get monthNovember => 'monthNovember'.tr;
  static String get monthDecember => 'monthDecember'.tr;

  static String get monJan => 'monJan'.tr;
  static String get monFeb => 'monFeb'.tr;
  static String get monMar => 'monMar'.tr;
  static String get monApr => 'monApr'.tr;
  static String get monMay => 'monMay'.tr;
  static String get monJun => 'monJun'.tr;
  static String get monJul => 'monJul'.tr;
  static String get monAug => 'monAug'.tr;
  static String get monSep => 'monSep'.tr;
  static String get monOct => 'monOct'.tr;
  static String get monNov => 'monNov'.tr;
  static String get monDec => 'monDec'.tr;

  static String get dayMonday => 'dayMonday'.tr;
  static String get dayTuesday => 'dayTuesday'.tr;
  static String get dayWednesday => 'dayWednesday'.tr;
  static String get dayThursday => 'dayThursday'.tr;
  static String get dayFriday => 'dayFriday'.tr;
  static String get daySaturday => 'daySaturday'.tr;
  static String get daySunday => 'daySunday'.tr;

  static String get dayMon => 'dayMon'.tr;
  static String get dayTue => 'dayTue'.tr;
  static String get dayWed => 'dayWed'.tr;
  static String get dayThu => 'dayThu'.tr;
  static String get dayFri => 'dayFri'.tr;
  static String get daySat => 'daySat'.tr;
  static String get daySun => 'daySun'.tr;

  static String get periodAm => 'periodAm'.tr;
  static String get periodPm => 'periodPm'.tr;

  // Status labels

  // Order statuses
  static String get orderStatusDraft => 'orderStatusDraft'.tr;
  static String get orderStatusSubmitted => 'orderStatusSubmitted'.tr;
  static String get orderStatusConfirmed => 'orderStatusConfirmed'.tr;
  static String get orderStatusDelivered => 'orderStatusDelivered'.tr;
  static String get orderStatusCancelled => 'orderStatusCancelled'.tr;

  // Delivery statuses
  static String get deliveryStatusPending => 'deliveryStatusPending'.tr;
  static String get deliveryStatusPickedUp => 'deliveryStatusPickedUp'.tr;
  static String get deliveryStatusInTransit => 'deliveryStatusInTransit'.tr;
  static String get deliveryStatusDelivered => 'deliveryStatusDelivered'.tr;
  static String get deliveryStatusReturned => 'deliveryStatusReturned'.tr;

  // Collection statuses
  static String get collectionStatusPending => 'collectionStatusPending'.tr;
  static String get collectionStatusCollected => 'collectionStatusCollected'.tr;
  static String get collectionStatusHandedOver =>
      'collectionStatusHandedOver'.tr;

  // Visit statuses
  static String get visitStatusCheckedIn => 'visitStatusCheckedIn'.tr;
  static String get visitStatusCheckedOut => 'visitStatusCheckedOut'.tr;

  // Shop statuses
  static String get shopStatusPending => 'shopStatusPending'.tr;
  static String get shopStatusApproved => 'shopStatusApproved'.tr;
  static String get shopStatusRejected => 'shopStatusRejected'.tr;
  static String get shopStatusActive => 'shopStatusActive'.tr;

  // Empty / errors
  static String get noDataYet => 'noDataYet'.tr;
  static String get notAvailable => 'notAvailable'.tr;
  static String get error => 'error'.tr;
  static String get noInternet => 'noInternet'.tr;
  static String get locationServicesOff => 'locationServicesOff'.tr;
  static String get locationServicesOn => 'locationServicesOn'.tr;
  static String get formInvalid => 'formInvalid'.tr;
  static String get locationEnableTitle => 'locationEnableTitle'.tr;
  static String get locationEnableMessage => 'locationEnableMessage'.tr;
  static String get locationPermissionTitle => 'locationPermissionTitle'.tr;
  static String get locationPermissionMessage => 'locationPermissionMessage'.tr;
  static String get locationEnableSteps => 'locationEnableSteps'.tr;
  static String get locationOpenSettings => 'locationOpenSettings'.tr;
  static String get locationOpenAppSettings => 'locationOpenAppSettings'.tr;

  static String get emptyLoadFailedTitle => 'emptyLoadFailedTitle'.tr;
  static String get emptyLoadFailedSubtitle => 'emptyLoadFailedSubtitle'.tr;
  static String get emptyNoRouteTitle => 'emptyNoRouteTitle'.tr;
  static String get emptyNoOrdersTitle => 'emptyNoOrdersTitle'.tr;
  static String get emptyNoCollectionsTitle => 'emptyNoCollectionsTitle'.tr;
  static String get emptyNoTasksTitle => 'emptyNoTasksTitle'.tr;
  static String get emptyNoShopsTitle => 'emptyNoShopsTitle'.tr;
  static String get emptyNoVisitsTitle => 'emptyNoVisitsTitle'.tr;
  static String get emptyNoTargetsTitle => 'emptyNoTargetsTitle'.tr;
  static String get emptyNoScheduleTitle => 'emptyNoScheduleTitle'.tr;
  static String get emptyNoProductsTitle => 'emptyNoProductsTitle'.tr;
  static String get emptyCartTitle => 'emptyCartTitle'.tr;
  static String get emptyNoActiveVisitTitle => 'emptyNoActiveVisitTitle'.tr;
  static String get emptyNotFoundTitle => 'emptyNotFoundTitle'.tr;
  static String get emptyComingSoonTitle => 'emptyComingSoonTitle'.tr;
  static String get emptyProfileTitle => 'emptyProfileTitle'.tr;

  // Validation messages
  static String get emailRequired => 'emailRequired'.tr;
  static String get emailInvalid => 'emailInvalid'.tr;
  static String get passwordRequired => 'passwordRequired'.tr;
  static String get passwordsDoNotMatch => 'passwordsDoNotMatch'.tr;
  static String get fieldRequired => 'fieldRequired'.tr;
  static String get amountInvalid => 'amountInvalid'.tr;
  static String get percentageInvalid => 'percentageInvalid'.tr;
  static String get passwordMinLength => 'passwordMinLength'.tr;
  static String get passwordNoSpaces => 'passwordNoSpaces'.tr;
  static String get phoneRequired => 'phoneRequired'.tr;
  static String get phoneInvalid => 'phoneInvalid'.tr;
  static String get obPhoneLength => 'obPhoneLength'.tr;
  static String get cnicInvalid => 'cnicInvalid'.tr;
  static String get phoneLength => 'phoneLength'.tr;
}
