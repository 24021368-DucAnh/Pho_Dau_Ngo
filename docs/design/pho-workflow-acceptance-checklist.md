# M2 phở workflow acceptance checklist

## Recipe semantics
- [x] Phở tái is raw thin-sliced beef finished by hot broth in the bowl, not timed beef blanching.
- [x] Phở chín requires pre-cooked/cooked-and-sliced beef before bowl assembly (currently represented as prepared stock, not an interactive prep station).
- [x] Noodles are a separate first recipe step; interactive blanching timing is not implemented.
- [x] Broth is the finishing action for both bowl variants.
- [x] Ingredient identities distinguish raw sliced beef from cooked sliced beef; additional cuts/toppings remain out of scope.

## Domain invariants
- [x] Invalid order leaves inventory and bowl state unchanged (automated regression test).
- [x] Each successful step consumes exactly once (automated regression test).
- [x] Missing stock cannot go negative (automated regression test).
- [x] Cancellation records consumed ingredients as waste once and resets bowl state (automated regression test). No active station timer exists in the current model.
- [x] Recipe cannot be switched after bowl preparation begins (player-level and station-level regression tests).
- [x] Ownership remains singular across pickup/place/re-pickup; cancellation state reset is covered separately.
- [x] An incomplete bowl cannot be served; a completed bowl must also be placed before delivery (automated order/serving regression tests).

## Verification
- [x] Automated recipe tests cover both workflows, invalid order, repeated activation, recipe locking, cancellation and missing stock.
- [ ] CI import/parse, tests and Linux/Windows exports pass on the latest branch head (previous commit `64a755b` passed; latest run is pending).
- [ ] Manual playtest covers physical interaction, placement and usability before M2 is declared fully accepted.


## M3 order and serving service checkpoint
- [x] Orders have stable IDs, recipe IDs, destination table IDs and explicit lifecycle states.
- [x] Duplicate order IDs and illegal state transitions are rejected without mutating order state.
- [x] Incomplete bowls, unplaced bowls, recipe mismatches and wrong-table deliveries are rejected without payment.
- [x] Correct delivery transitions the order from READY to SERVED and records exactly one payment event.
- [x] The production scene owns one OrderManager and one ServingService.
- [x] A single deterministic starter order is created and shown in the player HUD; status follows ACCEPTED → PREPARING → READY → SERVED.
- [x] Delivery interaction calls ServingService against the current order and destination table; successful service updates the ticket and payment count.
- [ ] Customer spawning/behavior and multi-order/day flow remain unimplemented; the current scene uses a static stool/customer-side delivery zone.
- [ ] Manual playtest remains required; automated CI does not prove visual usability or input feel.
