# M2 phở workflow acceptance checklist

## Recipe semantics
- [ ] Phở tái is raw thin-sliced beef finished by hot broth in the bowl, not timed beef blanching.
- [ ] Phở chín requires a pre-cooked/cooked-and-sliced beef state before bowl assembly.
- [ ] Noodles are blanched separately.
- [ ] Broth is the finishing action for both bowl variants.
- [ ] Ingredient identities distinguish beef preparation states; future cut/topping support does not conflate nạm/gầu/gân/sách/bò viên with tai/chin.

## Domain invariants
- [ ] Invalid order leaves inventory and bowl state unchanged.
- [ ] Each successful step consumes exactly once.
- [ ] Missing stock cannot go negative.
- [ ] Cancellation clears active timers and records waste once.
- [ ] Recipe cannot be switched after bowl preparation begins.
- [ ] Ownership remains singular across pickup/place/cancel.
- [ ] An incomplete bowl cannot be served.

## Verification
- [ ] Automated recipe tests cover both workflows and invalid transitions.
- [ ] CI import/parse and Linux/Windows exports pass.
- [ ] Manual playtest covers physical interaction, placement and usability before M2 is declared fully accepted.
