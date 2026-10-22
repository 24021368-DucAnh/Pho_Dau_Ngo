# M2 phở workflow acceptance checklist

## Recipe semantics
- [ ] Phở tái is raw thin-sliced beef finished by hot broth in the bowl, not timed beef blanching.
- [ ] Phở chín requires a pre-cooked/cooked-and-sliced beef state before bowl assembly.
- [ ] Noodles are blanched separately.
- [ ] Broth is the finishing action for both bowl variants.
- [ ] Ingredient identities distinguish beef preparation states; future cut/topping support does not conflate nạm/gầu/gân/sách/bò viên with tai/chin.

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
- [x] CI import/parse and Linux/Windows exports passed on commit `64a755b`; latest test additions on `d37d50e` are pending CI.
- [ ] Manual playtest covers physical interaction, placement and usability before M2 is declared fully accepted.
