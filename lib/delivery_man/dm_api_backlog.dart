/// Delivery Man API integration backlog.
///
/// Phases **0–7** (delivery ops) + **Recovery / Wallet** + **API revisions**
/// (GPS criteria, delivery proof, recovery payment method) are wired on
/// `mubeen_wip`.
///
/// Live drawer:
/// - Dashboard
/// - Deliveries: Today Load · Today Plan · Walk-in Delivery · Van
/// - Collections: Recover (plan shops) · Wallet · History
/// - Account
///
/// Walk-in Delivery sells surplus van stock (`qty_free` API field) to an
/// unregistered customer via `dm/deliver/walk-in` (creates contact, SO,
/// invoice, wallet collection). Recover shop entry uses **Today Plan jobs**
/// only (local filter).
///
/// Field deliver / walk-in / recovery collect stay **online-only**.
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
