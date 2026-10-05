# Shahtaj Oil

Field operations mobile app for Shahtaj Oil teams. Order Bookers and Delivery Men run daily routes, visits, deliveries, recoveries, and targets from one place — in English or Urdu — on Android and iOS.

## Roles

| Role | Status |
| --- | --- |
| **Order Booker** | Available |
| **Delivery Man** | Available |

You pick a role during onboarding and sign in with the account linked to that role.

## Getting started

1. Open the app and walk through onboarding (intro, language, role).
2. Sign in with your Order Booker or Delivery Man credentials.
3. Use the drawer to move between dashboard, day work, shops or deliveries, collections, performance, and account.

Language (English / Urdu) can be chosen during onboarding and changed later from Account. Layout and menus update with the selected language.

## Shared features

- **Onboarding** — Short intro, language choice, and role selection before first login.
- **Sign in** — Email and password, with remember-me. The app shows which role you are signing in as.
- **Account** — Profile details, role, language toggle, online/offline status, and logout.
- **Report a problem** — Create and review field reports with subject, description, tags, and optional screenshot.
- **Location** — Device location is required for check-in, placing orders, deliveries, and walk-in sales. The app guides you if location is off or permission is missing.
- **Connectivity** — Online / offline presence is visible on the account screen. Order Bookers can queue offline work and sync when back online.

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

Pull down to refresh. At the start of the day, wait for day data download to finish when online.

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

- Shop information (name, license, type: cash or credit)
- Owner details (name, CNIC, phone with Pakistan format)
- GPS location (use current location)
- Zone and route assignment
- Credit limit and legacy / outstanding balance
- Documents and photos: CNIC front and back, owner photo, shop exterior (camera or gallery)

Validation, help text, and a reset option are included before submit.

#### My shops

Search and browse registered shops (shop, owner, phone, zone, or route). Filters include all shops, needs setup, and priority. Open a shop for full detail, or start a new registration from here.

#### Shop detail

- Shop and owner details, phone, address, zone/route
- Credit summary (limit, outstanding, remaining, credit-limit warnings)
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

- See the active visit id for the shop
- Browse sellable products and search by name
- Add products to a visit cart (quantity and proposed rate)
- See app rate vs proposed rate, bookable stock, and low-stock warnings
- Review credit impact, subtotal, and total
- Place the order (completes the visit)
- Or end the visit without an order (reason required; cart must be empty)

Leaving mid-visit keeps the visit active; unsaved cart edits may be discarded after confirmation. Offline work (check-in, verify, register, place order) can be queued and synced when back online.

#### Visit notes

Add or update notes for the current shop visit and save them separately from the order.

#### Order detail

View order number, shop, lines, quantities, amounts, and approval status.

#### Visit detail

View check-in / check-out times, outcome (order placed or no order), notes, and order lines. Open the related order when one was placed. History shows cancelled and rejected statuses correctly when the order is cancelled or rejected.

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
- Filter by outcome, approval status, and date range
- Totals (visit count and value)
- Open any visit for full detail

#### Sync Center

Review queued offline work, pending or failed sync items, and retry when the connection is back.

---

## Delivery Man

### Dashboard

Day overview for load, plan, van, and collections:

- Personalized greeting and next recommended action (load, depart, deliver, recover, return, or end day)
- Counts for pending, in transit, and delivered jobs
- Van stock snapshot
- Wallet / collected-today summary
- Jump into pickup, today’s plan, recover, or wallet from the next-action card

Pull down to refresh. Day data is warmed on open when online.

### Deliveries

#### Today Load (Pickup)

Confirm today’s warehouse pick before departing:

- See lines that still need pick
- Confirm quantities to load onto the van
- Hide zero-pick lines so only actionable stock is shown
- Depart only after pick is done (otherwise open Today Plan)

#### Today Plan

Today’s delivery jobs:

- Search and filter jobs
- Open a job for delivery detail (lines, GPS distance, receiver, proof)
- Mark shop closed or mark failed when needed
- Complete delivery with GPS and camera proof
- History-style views dedupe duplicate order cards

#### Walk-in delivery

Sell surplus van stock to a walk-in customer:

- Customer name and Pakistan phone format
- Deliver quantities with available-on-van limits and field validation
- Receiver name and camera-only delivery proof
- Cash or cheque payment (cheque number and image when cheque)
- On success, return to the dashboard

#### Van stock

See what is on the van, including available surplus for walk-in.

### Collections

#### Recover

Recover cash from today’s plan shops (Shahtaj shops only; walk-in shops are excluded):

- Search by shop name or order
- See unpaid / paid invoice counts and outstanding
- Open a shop for invoice list, payment status on invoices, and record collection
- High-due / credit warnings when applicable

#### Wallet

View wallet balance, collected today, and related collection totals.

#### Collection history

Browse past collections and open a collection for detail.

### Account

Same shared account screen as Order Booker: profile, language, presence, logout, and report a problem.

---

## Platforms

Android and iOS.
