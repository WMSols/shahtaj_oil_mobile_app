# Shahtaj Oil

Field operations mobile app for Shahtaj Oil teams. Order Bookers manage daily routes, shop visits, orders, and targets from one place — in English or Urdu — on Android and iOS.

## Roles

| Role | Status |
| --- | --- |
| **Order Booker** | Available |
| **Delivery Man** | Under development |
| **Recovery Man** | Under development |

You pick a role during onboarding and sign in with the account linked to that role. Delivery Man and Recovery Man are listed so teams can see what is coming; those modules are not ready for field use yet.

## Getting started

1. Open the app and walk through onboarding (intro, language, role).
2. Sign in with your Order Booker credentials.
3. Use the drawer to move between Dashboard, field work, shops, performance, and account.

Language (English / Urdu) can be chosen during onboarding and changed later from Account. Layout and menus update with the selected language.

## Shared features

- **Onboarding** — Short intro, language choice, and role selection before first login.
- **Sign in** — Email and password, with remember-me. The app shows which role you are signing in as.
- **Account** — Profile details, role, language toggle, online/offline status, and logout.
- **Location** — Device location is required for check-in and placing orders. The app guides you if location is off or permission is missing.
- **Connectivity** — Online / offline presence is visible on the account screen.

---

## Order Booker

### Dashboard

A daily overview of field work:

- Personalized greeting and day-at-a-glance subtitle
- Snapshot of visited shops, pending visits, and today’s orders (tap a tile to jump to that list)
- Today’s assigned route with status (not started, in progress, completed) and shop count
- Sales targets progress
- Recent orders
- Banner to resume an active visit if one is already in progress

Pull down to refresh.

### Field work

#### Weekly schedule

See the week’s assigned routes and shop stops. Open a day to review that route and continue into today’s visits when it is the current day.

#### Today’s visits

The day’s route, stop by stop:

- Search visits by shop or owner
- Filter by status (all, pending, in progress, completed)
- Check in at a shop to start a visit
- See sequence (stop number), visit tag, and progress (completed of total)
- Resume an active visit
- Add or edit visit notes
- Continue into order creation after check-in

Only one visit can be active at a time. Check-in from today’s route; shops that are not on today’s route cannot be started from elsewhere.

### Shops

#### Register shop

Onboard a new shop with:

- Shop information (name, type: cash or credit)
- Owner details (name, CNIC, phone)
- GPS location (use current location)
- Zone and route assignment
- Credit limit and legacy / outstanding balance
- Documents and photos: CNIC front and back, owner photo, shop exterior (camera or gallery)

Validation, help text, and a reset option are included before submit.

#### My shops

Search and browse registered shops (shop, owner, phone, zone, or route). Filters include all shops, needs setup, and priority. Open a shop for full detail, or start a new registration from here.

#### Shop detail

- Shop and owner details, phone, address, zone/route
- Credit summary (limit, outstanding, remaining)
- Verification photos
- Map / location
- Call owner and directions
- Check in (when the shop is on today’s route)
- Create order after check-in, for approved or active shops

Shops that still need on-site verification show a setup banner until required fields and photos are complete.

#### On-site verification

If a shop is missing required setup, complete the remaining details and photos on site before the visit can start.

### Visits and orders

#### Create order

During an active visit:

- Browse sellable products and search by name
- Add products to a visit cart (quantity and unit price)
- See bookable stock and low-stock warnings
- Review subtotal and total
- Place the order (completes the visit)
- Or end the visit without an order (reason required; cart must be empty)

Leaving mid-visit keeps the visit active; unsaved cart edits may be discarded after confirmation.

#### Visit notes

Add or update notes for the current shop visit and save them separately from the order.

#### Order detail

View order number, shop, lines, quantities, amounts, and status.

#### Visit detail

View check-in / check-out times, outcome (order placed or no order), notes, and order lines. Open the related order when one was placed.

### Performance

#### Targets

Track assigned targets by type, including:

- Collective quantity or weight
- Combined product targets
- Individual product quantity or weight

See progress percentage, at-risk items, and product-level breakdown. Sort by progress, ending soon, or type.

#### History

Past visits for a period:

- Search by shop, owner, or order number
- Filter by outcome and date range
- Totals (visit count and value)
- Open any visit for full detail

---

## Delivery Man

**Under development.** Pickup, delivery, and stock-return workflows are planned for a later release.

## Recovery Man

**Under development.** Collections and handover workflows are planned for a later release.

---

## Platforms

Android and iOS.
