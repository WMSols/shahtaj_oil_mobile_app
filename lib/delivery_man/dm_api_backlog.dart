/// Delivery Man API integration backlog.
///
/// Surfaces without a live DM API are **hidden** from the shell for now.
/// Keep the code until we either wire a new endpoint or delete the feature.
///
/// Hidden (recovery / cash — no APIs yet):
/// - Collections: today shops, history, record, invoices, detail
/// - Handover: list, confirm, detail
///
/// Hidden (delivery UI not backed by current DM API):
/// - Delivery history leaf + detail (no past-day jobs endpoint)
/// - Duplicate Deliver leaf (fold into Today Plan filters)
/// - Receiver name / proof photo (not on `job/deliver`)
/// - Order prices / amounts (jobs are quantity-only)
/// - Client-invented delivery timeline
/// - Van load/unload history documents
/// - Warehouse / vehicle / shift headers (not in `load/today`)
/// - Delivery / recovery targets card
/// - Recent activity feed
/// - Legacy mock Return / Pickup dual-confirm UX (replace with load + van APIs)
library;
