import 'package:get/get.dart';

class AppTexts {
  AppTexts._();

  // App
  static String get appName => 'appName'.tr;
  static String get appVersion => 'appVersion'.tr;

  // Common buttons
  static String get login => 'login'.tr;
  static String get logout => 'logout'.tr;
  static String get submit => 'submit'.tr;
  static String get submitting => 'submitting'.tr;
  static String get loading => 'loading'.tr;
  static String get loggingIn => 'loggingIn'.tr;
  static String get save => 'save'.tr;
  static String get cancel => 'cancel'.tr;
  static String get confirm => 'confirm'.tr;
  static String get delete => 'delete'.tr;
  static String get edit => 'edit'.tr;
  static String get create => 'create'.tr;
  static String get update => 'update'.tr;
  static String get viewAll => 'viewAll'.tr;
  static String get loadMore => 'loadMore'.tr;
  static String get markAllRead => 'markAllRead'.tr;
  static String get search => 'search'.tr;
  static String get filter => 'filter'.tr;
  static String get back => 'back'.tr;
  static String get next => 'next'.tr;
  static String get continueLabel => 'continueLabel'.tr;
  static String get done => 'done'.tr;
  static String get add => 'add'.tr;
  static String get retry => 'retry'.tr;
  static String get comingSoon => 'comingSoon'.tr;

  // Auth
  static String get signIn => 'signIn'.tr;
  static String get signInButton => 'signInButton'.tr;
  static String get switchRole => 'switchRole'.tr;
  static String get signUp => 'signUp'.tr;
  static String get createAccount => 'createAccount'.tr;
  static String get register => 'register'.tr;
  static String get registerYourself => 'registerYourself'.tr;
  static String get registerNow => 'registerNow'.tr;
  static String get emailOrPhone => 'emailOrPhone'.tr;
  static String get emailOrPhoneHint => 'emailOrPhoneHint'.tr;
  static String get show => 'show'.tr;
  static String get hide => 'hide'.tr;
  static String get phone => 'phone'.tr;
  static String get email => 'email'.tr;
  static String get password => 'password'.tr;
  static String get currentPassword => 'currentPassword'.tr;
  static String get newPassword => 'newPassword'.tr;
  static String get passwordHint => 'passwordHint'.tr;
  static String get confirmPassword => 'confirmPassword'.tr;
  static String get confirmPasswordHint => 'confirmPasswordHint'.tr;
  static String get fullName => 'fullName'.tr;
  static String get fullNameHint => 'fullNameHint'.tr;
  static String get phoneHint => 'phoneHint'.tr;
  static String get emailHint => 'emailHint'.tr;
  static String get aboutYourselfHint => 'aboutYourselfHint'.tr;
  static String get rememberMe => 'rememberMe'.tr;
  static String get authWelcomeTitle => 'authWelcomeTitle'.tr;
  static String get authWelcomeSubtitle => 'authWelcomeSubtitle'.tr;
  static String get signingInAs => 'signingInAs'.tr;
  static String get authNoAccount => 'authNoAccount'.tr;
  static String get authHaveAccount => 'authHaveAccount'.tr;
  static String get generatePassword => 'generatePassword'.tr;
  static String get yourDetails => 'yourDetails'.tr;
  static String get profilePictures => 'profilePictures'.tr;
  static String get uploadProfilePicture => 'uploadProfilePicture'.tr;
  static String get security => 'security'.tr;
  static String get generatePasswordPrefix => 'generatePasswordPrefix'.tr;
  static String get generatePasswordHere => 'generatePasswordHere'.tr;
  static String get generatePasswordMiddle => 'generatePasswordMiddle'.tr;
  static String get copyrightsPrefix => 'copyrightsPrefix'.tr;
  static String get brandName => 'brandName'.tr;
  static String get broughtByPrefix => 'broughtByPrefix'.tr;
  static String get developerName => 'developerName'.tr;
  static String get allRightsReserved => 'allRightsReserved'.tr;
  static String get loginSuccessful => 'loginSuccessful'.tr;
  static String get accountCreatedSuccess => 'accountCreatedSuccess'.tr;
  static String get loginFailedTitle => 'loginFailedTitle'.tr;
  static String get signUpFailedTitle => 'signUpFailedTitle'.tr;
  static String get selectYourRole => 'selectYourRole'.tr;
  static String get selectRoleBody => 'selectRoleBody'.tr;
  static String get defaultUserName => 'defaultUserName'.tr;
  static String get languageEnglish => 'languageEnglish'.tr;
  static String get languageUrdu => 'languageUrdu'.tr;

  /// Fixed labels for language picker buttons (not locale-dependent).
  static const String languageEnglishButton = 'English';
  static const String languageUrduButton = 'اردو';

  static String get changeLanguage => 'changeLanguage'.tr;
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

  static String obVanStockSummary(int count) =>
      'obVanStockSummary'.trParams({'count': '$count'});
  static String dmVanStockSummary(int count) =>
      'dmVanStockSummary'.trParams({'count': '$count'});

  // Splash
  static String get splashTagline => 'splashTagline'.tr;

  // Navigation
  static String get navDashboard => 'navDashboard'.tr;
  static String get navProfile => 'navProfile'.tr;
  static String get navNotifications => 'navNotifications'.tr;
  static String get navRoutes => 'navRoutes'.tr;
  static String get navTodayTasks => 'navTodayTasks'.tr;
  static String get navShops => 'navShops'.tr;
  static String get navHistory => 'navHistory'.tr;
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
  static String get welcome => 'welcome'.tr;
  static String get obDashboardSubtitle => 'obDashboardSubtitle'.tr;
  static String get obTodaysRoute => 'obTodaysRoute'.tr;
  static String get obTodaysRoutes => 'obTodaysRoutes'.tr;
  static String get obTargets => 'obTargets'.tr;
  static String get obOrdersToday => 'obOrdersToday'.tr;
  static String get obRecoveryTarget => 'obRecoveryTarget'.tr;
  static String get rmRecoveryTarget => 'rmRecoveryTarget'.tr;
  static String get rmTargets => 'rmTargets'.tr;
  static String get obRecentOrders => 'obRecentOrders'.tr;
  static String get dmStockItems => 'dmStockItems'.tr;
  static String get obStockItems => 'obStockItems'.tr;
  static String get obStartRoute => 'obStartRoute'.tr;
  static String get obContinueRoute => 'obContinueRoute'.tr;
  static String get obLowStock => 'obLowStock'.tr;
  static String get obNoRouteAssigned => 'obNoRouteAssigned'.tr;
  static String get obNoRoutesAssigned => 'obNoRoutesAssigned'.tr;
  static String get obNoRecentOrders => 'obNoRecentOrders'.tr;
  static String get routeStatusNotStarted => 'routeStatusNotStarted'.tr;
  static String get routeStatusInProgress => 'routeStatusInProgress'.tr;
  static String get routeStatusCompleted => 'routeStatusCompleted'.tr;
  static String get taskStatusPending => 'taskStatusPending'.tr;
  static String get taskStatusInVisit => 'taskStatusInVisit'.tr;
  static String get taskStatusSkipped => 'taskStatusSkipped'.tr;
  static String get taskStatusCompleted => 'taskStatusCompleted'.tr;

  static String totalCount(int count) =>
      'totalCount'.trParams({'count': '$count'});

  static String userContact(String phone, String email) =>
      'userContact'.trParams({'phone': phone, 'email': email});

  // Order booker screens
  static String get obTodayTasksTitle => 'obTodayTasksTitle'.tr;
  static String get obRouteDetailTitle => 'obRouteDetailTitle'.tr;
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
  static String get obOwnerPhoneLabel => 'obOwnerPhoneLabel'.tr;
  static String get obOwnerPhoneHint => 'obOwnerPhoneHint'.tr;
  static String get obLatitudeLabel => 'obLatitudeLabel'.tr;
  static String get obLongitudeLabel => 'obLongitudeLabel'.tr;
  static String get obUseCurrentLocation => 'obUseCurrentLocation'.tr;
  static String get obLocationNotCaptured => 'obLocationNotCaptured'.tr;
  static String get obCoordinatesLabel => 'obCoordinatesLabel'.tr;
  static String get obMapPreviewBadge => 'obMapPreviewBadge'.tr;
  static String get obMapPreviewLocation => 'obMapPreviewLocation'.tr;
  static String get obZoneLabel => 'obZoneLabel'.tr;
  static String get obZoneHint => 'obZoneHint'.tr;
  static String get obRouteLabel => 'obRouteLabel'.tr;
  static String get obRouteHint => 'obRouteHint'.tr;
  static String get obCreditLimitLabel => 'obCreditLimitLabel'.tr;
  static String get obLegacyBalanceLabel => 'obLegacyBalanceLabel'.tr;
  static String get obLatitudeHint => 'obLatitudeHint'.tr;
  static String get obLongitudeHint => 'obLongitudeHint'.tr;
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
  static String get obRequiredFieldsNote => 'obRequiredFieldsNote'.tr;
  static String get obLocationDisabled => 'obLocationDisabled'.tr;
  static String get obLocationPermissionDenied =>
      'obLocationPermissionDenied'.tr;
  static String get obLocationFetchFailed => 'obLocationFetchFailed'.tr;
  static String get obCoordinateInvalid => 'obCoordinateInvalid'.tr;
  static String get obShopRegisteredSuccess => 'obShopRegisteredSuccess'.tr;
  static String get obRegisterShopHelpTitle => 'obRegisterShopHelpTitle'.tr;
  static String get obRegisterShopHelpBody => 'obRegisterShopHelpBody'.tr;
  static String get obRegisterShopResetTitle => 'obRegisterShopResetTitle'.tr;
  static String get obRegisterShopResetMessage =>
      'obRegisterShopResetMessage'.tr;
  static String get obMyShopsTitle => 'obMyShopsTitle'.tr;
  static String get obRegisteredShopsTitle => 'obRegisteredShopsTitle'.tr;
  static String get obSearchShopHint => 'obSearchShopHint'.tr;
  static String get obShopsFilterAll => 'obShopsFilterAll'.tr;
  static String obShopOwner(String name) =>
      'obShopOwner'.trParams({'name': name});
  static String get obNoShopsFound => 'obNoShopsFound'.tr;
  static String get obShopDetailTitle => 'obShopDetailTitle'.tr;
  static String get obShopDetailsSection => 'obShopDetailsSection'.tr;
  static String get obVerificationPhotosSection =>
      'obVerificationPhotosSection'.tr;
  static String get obPhoneNumberLabel => 'obPhoneNumberLabel'.tr;
  static String get obLocationLabel => 'obLocationLabel'.tr;
  static String get obViewOnMap => 'obViewOnMap'.tr;
  static String get obCallOwner => 'obCallOwner'.tr;
  static String get obDirections => 'obDirections'.tr;
  static String get obEditShop => 'obEditShop'.tr;
  static String get obCreateOrderButton => 'obCreateOrderButton'.tr;
  static String get obCheckInToShop => 'obCheckInToShop'.tr;
  static String get obShopNotFound => 'obShopNotFound'.tr;
  static String get obCnicFrontLabel => 'obCnicFrontLabel'.tr;
  static String get obCnicBackLabel => 'obCnicBackLabel'.tr;
  static String get obOwnerPhotoLabel => 'obOwnerPhotoLabel'.tr;
  static String get obShopExteriorLabel => 'obShopExteriorLabel'.tr;
  static String get obShopEditTitle => 'obShopEditTitle'.tr;
  static String get obCheckInTitle => 'obCheckInTitle'.tr;
  static String get obTasksSection => 'obTasksSection'.tr;
  static String get obTaskCheckIn => 'obTaskCheckIn'.tr;
  static String get obTaskSkip => 'obTaskSkip'.tr;
  static String get obTaskNotes => 'obTaskNotes'.tr;
  static String get obSkipTaskTitle => 'obSkipTaskTitle'.tr;
  static String get obSkipTaskMessage => 'obSkipTaskMessage'.tr;
  static String get obTaskNotesHint => 'obTaskNotesHint'.tr;
  static String get obActiveVisitTitle => 'obActiveVisitTitle'.tr;
  static String get obResumeVisit => 'obResumeVisit'.tr;
  static String get obNoTasksToday => 'obNoTasksToday'.tr;
  static String get obCheckInSuccess => 'obCheckInSuccess'.tr;
  static String get obTaskNotFound => 'obTaskNotFound'.tr;
  static String get obCheckInShopContext => 'obCheckInShopContext'.tr;

  static String obTasksProgress(int completed, int total) => 'obTasksProgress'
      .trParams({'completed': '$completed', 'total': '$total'});

  static String obActiveVisitAt(String shopName) =>
      'obActiveVisitAt'.trParams({'shop': shopName});

  static String obTaskSequence(int sequence) =>
      'obTaskSequence'.trParams({'sequence': '$sequence'});
  static String get obOrderCreateTitle => 'obOrderCreateTitle'.tr;
  static String get obOrderDetailTitle => 'obOrderDetailTitle'.tr;
  static String get obVisitDetailTitle => 'obVisitDetailTitle'.tr;

  // Delivery man screens
  static String get dmPickupTitle => 'dmPickupTitle'.tr;
  static String get dmDeliverTitle => 'dmDeliverTitle'.tr;
  static String get dmDeliveryDetailTitle => 'dmDeliveryDetailTitle'.tr;
  static String get dmReturnTitle => 'dmReturnTitle'.tr;
  static String get dmOrderDetailTitle => 'dmOrderDetailTitle'.tr;

  // Recovery man screens
  static String get rmShopInvoicesTitle => 'rmShopInvoicesTitle'.tr;
  static String get rmRecordCollectionTitle => 'rmRecordCollectionTitle'.tr;
  static String get rmHandoverDetailTitle => 'rmHandoverDetailTitle'.tr;

  // Common labels
  static String get or => 'or'.tr;
  static String get addNew => 'addNew'.tr;
  static String get markComplete => 'markComplete'.tr;
  static String get view => 'view'.tr;
  static String get approved => 'approved'.tr;
  static String get personalDetail => 'personalDetail'.tr;
  static String get uploadImages => 'uploadImages'.tr;
  static String get uploadImage => 'uploadImage'.tr;
  static String get uploadDocuments => 'uploadDocuments'.tr;
  static String get tapToUploadImages => 'tapToUploadImages'.tr;
  static String get tapToUploadDocuments => 'tapToUploadDocuments'.tr;
  static String get updateProfile => 'updateProfile'.tr;
  static String get createdBy => 'createdBy'.tr;
  static String get userId => 'userId'.tr;
  static String get name => 'name'.tr;
  static String get desc => 'desc'.tr;
  static String get createdAtLabel => 'createdAtLabel'.tr;
  static String get updatedAtLabel => 'updatedAtLabel'.tr;
  static String get created => 'created'.tr;
  static String get id => 'id'.tr;
  static String get notApplicable => 'notApplicable'.tr;
  static String get today => 'today'.tr;
  static String get yesterday => 'yesterday'.tr;

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
  static String get notifications => 'notifications'.tr;
  static String get unread => 'unread'.tr;
  static String get read => 'read'.tr;
  static String get noNotifications => 'noNotifications'.tr;

  // Profile
  static String get myProfile => 'myProfile'.tr;
  static String get editProfile => 'editProfile'.tr;
  static String get role => 'role'.tr;
  static String get memberSince => 'memberSince'.tr;
  static String get profileUpdated => 'profileUpdated'.tr;

  // Roles
  static String get roleOrderBooker => 'roleOrderBooker'.tr;
  static String get roleOrderBookerSubtitle => 'roleOrderBookerSubtitle'.tr;
  static String get roleDeliveryMan => 'roleDeliveryMan'.tr;
  static String get roleDeliveryManSubtitle => 'roleDeliveryManSubtitle'.tr;
  static String get roleRecoveryMan => 'roleRecoveryMan'.tr;
  static String get roleRecoveryManSubtitle => 'roleRecoveryManSubtitle'.tr;

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
  static String get statusPending => 'statusPending'.tr;
  static String get statusPaid => 'statusPaid'.tr;
  static String get statusOverdue => 'statusOverdue'.tr;

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
  static String get success => 'success'.tr;
  static String get noInternet => 'noInternet'.tr;
  static String get noInternetDescription => 'noInternetDescription'.tr;

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
  static String get phoneLength => 'phoneLength'.tr;
}
