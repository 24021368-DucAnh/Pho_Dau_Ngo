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
- [ ] An incomplete bowl cannot be served.

## Verification
- [x] Automated recipe tests cover both workflows, invalid order, repeated activation, recipe locking, cancellation and missing stock.
- [ ] CI import/parse, tests and Linux/Windows exports pass on the latest branch head (previous commit `64a755b` passed; latest run is pending).
- [ ] Manual playtest covers physical interaction, placement and usability before M2 is declared fully accepted.
