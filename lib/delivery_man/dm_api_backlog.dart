/// Delivery Man API integration backlog.
///
/// Phases **0–7** (delivery ops) + **Recovery / Wallet** + **API revisions**
/// (GPS criteria, delivery proof, recovery payment method) are wired on
/// `mubeen_wip`.
///
/// Live drawer:
/// - Dashboard
/// - Deliveries: Today Load · Today Plan · Free deliver · Van
/// - Collections: Recover (plan shops + shops/search) · Wallet · History
/// - Account
///
/// Recovery shop entry uses **Today Plan jobs** and **`shops/search`** — there
/// is no separate “today shops due” list API.
///
/// Field deliver / free deliver / recovery collect stay **online-only**.
/// GPS `max_m` comes from `dm/auth/login` and `dm/plan/today` (saved offline).
/// Deliver requires `receiver_name` + `delivery_proof_image`. Collect supports
/// cash / cheque (+ cheque image).
///
/// Still hidden (no API):
/// - Handover / office cash settlement UI (`settled_total` is read-only)
/// - Delivery history leaf + detail
/// - Duplicate Deliver / Return leaves
/// - Order prices on jobs
/// - Van load/unload history documents
/// - Delivery / recovery targets
/// - Recent activity feed
///
/// Deferred cleanup:
/// - Legacy mock delivery + collection-store / handover services and keys
library;
