import 'package:get/get.dart';

/// Shared force/cache load pattern for list-style controllers.
mixin CachedLoadMixin on GetxController {
  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();

  bool _forceRefresh = false;

  /// True while [loadCached] is running with `force: true` (e.g. pull-to-refresh).
  bool get isForceRefresh => _forceRefresh;

  /// Returns true when in-memory data is already available.
  bool get hasCachedData;

  /// Performs the network/disk fetch and assigns controller state.
  Future<void> fetchData();

  /// Fallback message when first load fails and there is no cache.
  String get loadFailedMessage => 'Failed to load';

  Future<void> loadCached({bool force = false}) async {
    final hasCache = hasCachedData;
    if (!force && hasCache) {
      isLoading.value = false;
      return;
    }

    if (!hasCache) {
      isLoading.value = true;
    }

    _forceRefresh = force;
    try {
      await fetchData();
      error.value = null;
    } catch (_) {
      if (!hasCache) {
        error.value = loadFailedMessage;
      }
    } finally {
      _forceRefresh = false;
      isLoading.value = false;
    }
  }
}
