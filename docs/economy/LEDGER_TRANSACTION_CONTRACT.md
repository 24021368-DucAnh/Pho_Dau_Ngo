# Ledger & Transaction Contract — Vertical Slice

Status: **Design contract / implementation not yet verified**
Scope: one representative shop day; all economy amounts are provisional test data.

## 1. Purpose

Provide one authoritative, append-only record of cash-affecting events for a single day. The ledger is the source of truth for revenue and cash reconciliation. UI, order status, and the day-summary screen must never create money or independently recalculate transactions.

This contract does not implement the full 100-day campaign, debt, rent schedules, supplier simulation, spoilage simulation, or persistence.

## 2. Core invariants

1. Every transaction has a stable unique `transaction_id`, a `day_id`, a typed `kind`, an integer amount in the smallest game currency unit, a source reference, and a creation sequence.
2. Transaction records are append-only. Corrections are represented by a compensating transaction, not by editing or deleting a prior entry.
3. A successful order can create revenue at most once. Repeated serving, repeated close-day calls, or repeated UI confirmation must not create another revenue entry.
4. A failed action creates no cash transaction.
5. Amounts are integers; do not use floating-point values for money.
6. Transaction IDs are idempotency keys. Reusing an ID with identical payload returns the original result without adding an entry; reusing it with a different payload is rejected.
7. All public reads return detached snapshots so callers cannot mutate ledger state.
8. Day close is a read/close-state operation, not a second posting of revenue or expenses.
9. A summary is derived from ledger entries and inventory snapshots, not stored as an independently mutable set of totals.
10. Values used in the prototype must be labeled provisional until the owner approves economy balance.

## 3. Transaction types for the first slice

| Kind | Cash effect | Source | Included now? |
|---|---:|---|---|
| `opening_cash` | positive | day start | Yes, test fixture |
| `sale_revenue` | positive | served order ID | Yes |
| `ingredient_purchase` | negative | purchase/action ID | Yes, minimal test fixture |
| `operating_cost` | negative | explicit test event | Optional; only if configured |
| `waste_loss` | negative | bowl/action ID | Not in first implementation unless separately scoped |
| `refund` | negative | original transaction/order ID | Deferred; no refund loop yet |
| `debt_payment` | negative | debt ID | Out of scope |
| `rent_payment` | negative | rent period ID | Out of scope |

Use one consistent sign convention: positive values increase cash; negative values decrease cash. Do not encode a purchase as a positive amount with a separate hidden subtraction rule.

## 4. Proposed domain API

The exact GDScript signatures may adapt to repository conventions, but the behavior must remain stable.

- `record_transaction(transaction_id, day_id, kind, amount, source_id, metadata = {}) -> Dictionary`
  - Validates non-empty IDs, supported kind, non-zero integer amount where appropriate, and kind/sign compatibility.
  - Returns `{ok, message, transaction}` on success or a clear failure result.
  - Enforces idempotency by transaction ID.
- `get_transaction(transaction_id) -> Dictionary`
  - Returns a deep copy or an empty dictionary if absent.
- `get_transactions(day_id = "") -> Array`
  - Returns detached records in posting order; optional day filter.
- `get_day_totals(day_id) -> Dictionary`
  - Returns opening cash, revenue, purchases, operating costs, net change, closing cash, and transaction count.
- `close_day(day_id) -> Dictionary`
  - Closes a day exactly once and returns a stable snapshot. Repeated calls return the same totals and do not append transactions.
- `is_day_closed(day_id) -> bool`
  - Read-only close state.
- `build_summary(day_id, inventory_snapshot = {}) -> Dictionary`
  - Pure/read-only projection from ledger data and supplied inventory snapshot. Must not mutate ledger or inventory.

If a transaction is rejected, no signal should announce it as posted. Successful posting should emit one signal after the record has been committed to internal state.

## 5. Reconciliation rules

For a day:

- `revenue = sum(sale_revenue amounts)`
- `purchases = sum(abs(ingredient_purchase amounts))`
- `operating_costs = sum(abs(operating_cost amounts))`
- `net_change = sum(all cash-affecting transaction amounts excluding opening_cash)`
- `closing_cash = opening_cash + net_change`

If the slice permits only one opening-cash record per day, duplicate opening cash must be rejected. A day with no opening-cash record must be reported as incomplete rather than silently assuming zero.

Inventory is a separate authoritative service. The ledger records the cash cost of a purchase; it must not itself change stock. The inventory service records physical stock changes. A future purchase coordinator may commit both or fail safely, but this contract does not pretend the two services are already atomic.

## 6. Required tests before implementation is considered complete

### Recording and validation
- Valid opening cash and sale revenue are accepted.
- Empty day/transaction/source IDs are rejected.
- Unsupported transaction kind is rejected.
- Zero amount and incorrect sign for a cash-effect kind are rejected.
- A second opening-cash record for the same day is rejected.
- Invalid transaction does not change count or totals.

### Idempotency and immutability
- Same ID + same payload is accepted as an idempotent replay and does not add a second entry.
- Same ID + different payload is rejected and preserves original entry.
- Mutating a returned transaction, array item, or metadata dictionary cannot mutate internal state.
- Entries are returned in deterministic posting order.

### Day close and summary
- Summary totals reconcile exactly to a known fixture.
- Closing cash equals opening cash plus net change.
- Closing a day twice does not change transaction count or totals.
- New cash-affecting entries after close are rejected.
- Building a summary does not mutate ledger or inventory snapshot.
- Missing opening cash is surfaced as an incomplete day.

### Integration with serving
- Failed serving records no revenue.
- Correctly served order records one revenue transaction with order ID as source.
- Repeated serving/payment signal does not record duplicate revenue.
- Revenue amount comes from a single provisional recipe-price configuration, not UI text or a hard-coded summary calculation.

### Inventory boundary
- Purchase cash transaction and stock addition are distinguishable concepts.
- Recipe ingredient consumption does not silently create a cash transaction.
- Inventory cannot go negative; ledger posting cannot bypass inventory validation.
- Any cross-service failure behavior is explicitly tested before implementing a purchase coordinator.

## 7. Acceptance gate

Implementation is ready for integration only when:
1. The tests above exist and pass in the pinned Godot 4.4.1 runtime.
2. The serving service posts revenue through one authoritative integration path.
3. The summary reconciles with transaction records and inventory snapshot.
4. Day close is idempotent and blocks further postings.
5. The README and QA acceptance matrix describe the real implementation and remaining limitations.

## 8. Current known boundary

At the time this contract was drafted, `ServingService` emits `payment_recorded` and guards duplicate payment within its own instance, but does not yet post to an authoritative ledger. `InventoryService` tracks quantities and exposes a snapshot, but it is not yet reconciled to cash transactions. This document specifies the target contract; it is not evidence that these integrations have been implemented or tested.
