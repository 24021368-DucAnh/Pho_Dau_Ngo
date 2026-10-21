# M0 Economy Review — PHỞ ĐẦU NGÕ

**Status:** Analytical review for owner decision; not a change to approved design.  
**Inputs:** GDD v1.2 economy assumptions. All prices and costs below are game-balancing values, not verified market data.

## Executive finding

The current repayment schedule is arithmetically consistent, but its affordability is fragile. At the current weighted contribution margin of 15,100 VND per bowl, **17 bowls/day is only the mathematical break-even point** for the phở cart in a debt-payment month. It leaves approximately 17,000 VND per 10-day game month before spoilage, labor, unexpected purchases, repairs, or any other omitted costs. That is not a safe operating target.

The existing customer targets say the learning phase is 10–14 bowls/day and stable cart operations are 14–20 bowls/day. Those ranges overlap with loss-making outcomes during debt-payment months. Keep the debt schedule fixed for now, but treat customer progression, working capital, ingredient margin, and payment timing as a blocking M0 balance review.

## 1. Baseline inputs

| Input | Current assumption |
|---|---:|
| Basic bowl selling price | 40,000 VND |
| Extra-meat bowl selling price | 45,000 VND |
| Sales mix | 70% basic / 30% extra-meat |
| Weighted average selling price | 41,500 VND/bowl |
| Weighted direct cost | 26,400 VND/bowl |
| Weighted contribution margin | 15,100 VND/bowl |
| Cash at game start | 2,000,000 VND |
| Opening inventory value | 300,000 VND, tracked separately |
| Room rent + utilities/maintenance | 550,000 VND per 10-day game month |
| Debt installment | 2,000,000 VND at the end of game months 2–10 |
| Shop opening cash requirement | Approximately 3,666,666 VND, plus recommended 1,500,000 VND reserve |

## 2. Cart cash contribution by average bowls sold

Formula used: bowls/day × 10 days × 15,100 VND contribution margin − 550,000 VND fixed cost − debt installment (if due). This is a contribution model, not a full cash-flow simulation.

| Average bowls/day | Monthly contribution | Before debt, after 550k fixed cost | After 2m installment | Interpretation |
|---:|---:|---:|---:|---|
| 10 | 1,510,000 | 960,000 | -1,040,000 | Not sustainable during repayment without a reserve |
| 14 | 2,114,000 | 1,564,000 | -436,000 | Loss-making in a repayment month |
| 17 | 2,567,000 | 2,017,000 | +17,000 | Mathematical break-even only; no meaningful buffer |
| 20 | 3,020,000 | 2,470,000 | +470,000 | Positive but still vulnerable to waste and shocks |
| 25 | 3,775,000 | 3,225,000 | +1,225,000 | More resilient; still excludes unmodeled costs |

## 3. Risks requiring an explicit decision

### R1 — Debt-month volume target conflicts with the current customer curve

The GDD's 10–14 bowls/day learning target and 14–20 bowls/day stable-cart target do not reliably cover a 2,000,000 VND installment. Even 20 bowls/day leaves only 470,000 VND for the entire 10-day game month after the modeled fixed cost and debt payment.

**Recommendation:** keep the nine-payment debt schedule as a story/design rule, but set a playtest acceptance target of at least 20 bowls/day average by the first repayment month, and test 17 bowls/day as a failure/buffer scenario. This target is provisional and must be validated in playtests; do not silently guarantee sales to force repayment.

### R2 — The model omits a safety buffer

The 17-bowl break-even point excludes spoilage, discarded broth, emergency market purchases, repairs, and labor. The GDD already requires a resilience test and recommends a 1,500,000 VND reserve before opening a shop.

**Recommendation:** do not allow shop expansion solely because the player can pay the nominal opening cost. Require the opening cost plus the reserve to remain available after the decision, and test at least one low-sales month and one ingredient-cost shock.

### R3 — Initial working capital and purchase timing are underspecified

The player begins with 2,000,000 VND cash and 300,000 VND inventory. A day at 20 bowls uses about 528,000 VND of direct-cost inventory on average. Since supplier orders arrive the following morning and the initial inventory is not enough for a full day at that volume, the first-day purchase/stock availability and payment timing must be explicit.

**Recommendation:** specify which ingredients are included in the opening 300,000 VND stock, how much stock is needed for the first service day, when the first supplier order can be placed, and whether the player can use same-day emergency market purchases. Add a test that the opening day is playable without a soft-lock.

### R4 — Recurring rent and debt may collide at month-end

The GDD defines rent and installments as month-based transactions, but the precise event order and payment date for recurring rent/utilities are not fully specified. If both are charged at the same boundary, the ledger must charge each exactly once and warn the player before the close.

**Recommendation:** specify a deterministic month-boundary transaction order, show upcoming obligations in advance, and test a player whose available cash is just below the combined obligation.

### R5 — Shop expansion may not be affordable on the intended timeline

The shop requires approximately 3,666,666 VND to open and the GDD recommends an additional 1,500,000 VND reserve. At 20 bowls/day, the simplified model generates only about 470,000 VND after fixed cost and debt in a repayment month; at 25 bowls/day it generates about 1,225,000 VND before omitted costs. Shop expansion should therefore remain optional unless playtesting demonstrates that the target player can save enough without exhausting working capital.

**Recommendation:** keep expansion optional. Before implementing the unlock, simulate cumulative cash across months 1–8 using daily sales variability, replenishment, spoilage, rent timing, and debt payments.

## 4. Required M0 acceptance tests

- [ ] Model 10, 14, 17, 20, and 25 bowls/day for a full 10-day game month.
- [ ] Repeat repayment-month cases with direct ingredient costs +10% and +20%.
- [ ] Include at least one poor-sales day, one spoiled batch, and one emergency purchase.
- [ ] Track cash purchases separately from cost of goods sold so inventory is not expensed twice.
- [ ] Confirm debt principal reduces cash and outstanding principal but is not classified as operating expense.
- [ ] Confirm deposit is locked cash, prepaid rent is paid once, and monthly rent is not charged twice during the prepaid period.
- [ ] Confirm a player cannot become unable to buy any ingredients after an ordinary low-sales day without a warning or recovery path.
- [ ] Simulate the optional shop-opening decision and preserve the 1,500,000 VND reserve.

## 5. Owner decisions requested

1. **Debt schedule:** retain nine 2,000,000 VND installments in game months 2–10? Recommendation: retain; it is already a core story rule.
2. **Repayment-month sales target:** approve a provisional 20 bowls/day target by the first installment month, with 17 bowls/day treated as a stress case? Recommendation: approve for playtesting, not as guaranteed customer behavior.
3. **Shop expansion:** confirm it remains optional and requires opening cost plus 1,500,000 VND reserve? Recommendation: yes.
4. **Initial inventory:** define the exact ingredient quantities contained in the 300,000 VND opening stock and the supplier-order timing before implementing inventory logic.
5. **Recurring payments:** define the order and warning UX for rent/utilities and debt installment at a month boundary.

## Conclusion

Do not change the debt principal or installment schedule silently. The present model indicates that 17 bowls/day is too fragile as an expected operating level during repayment. The next implementation-ready step is to resolve the above parameters and build a small, deterministic economy simulation/test matrix before integrating it with the selected game engine.
