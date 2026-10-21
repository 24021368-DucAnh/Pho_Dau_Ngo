# M0 Economy Review — PHỞ ĐẦU NGÕ

**Status:** Owner-approved provisional economy targets recorded on 2026-10-21; other balance assumptions remain open.  
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

## 2A. Stress-test định lượng — tháng có trả nợ

Đây là mô hình lãi góp đơn giản để kiểm tra sức chịu đựng, không phải dự báo doanh thu hay mô phỏng dòng tiền đầy đủ. Giả định 10 ngày/tháng chơi, tiền mặt sau khi bán hàng trừ chi phí cố định và khoản trả nợ 2.000.000đ; chưa tính tiền mua bổ sung theo thời điểm, tồn kho, hao hụt, sửa chữa, tiền công hoặc biến cố.

**Xe phở:** chi phí cố định 550.000đ/tháng chơi + khoản trả nợ 2.000.000đ.

| Kịch bản giá vốn | 10 bát/ngày | 14 bát/ngày | 17 bát/ngày | 20 bát/ngày | 25 bát/ngày |
|---|---:|---:|---:|---:|---:|
| Cơ sở — lãi góp 15.100đ/bát | -1.040.000đ | -436.000đ | +17.000đ | +470.000đ | +1.225.000đ |
| Toàn bộ giá vốn tăng 10% — lãi góp 12.460đ/bát | -1.304.000đ | -805.600đ | -431.800đ | -58.000đ | +565.000đ |
| Toàn bộ giá vốn tăng 20% — lãi góp 9.820đ/bát | -1.568.000đ | -1.175.200đ | -880.600đ | -586.000đ | -95.000đ |

**Cửa hàng trong khi vẫn thuê phòng:** chi phí cố định 1.383.333đ/tháng chơi + khoản trả nợ 2.000.000đ. Bảng này không bao gồm chi phí mở cửa hàng một lần và quỹ dự phòng.

| Kịch bản giá vốn | 10 bát/ngày | 14 bát/ngày | 17 bát/ngày | 20 bát/ngày | 25 bát/ngày |
|---|---:|---:|---:|---:|---:|
| Cơ sở — lãi góp 15.100đ/bát | -1.873.333đ | -1.269.333đ | -816.333đ | -363.333đ | +391.667đ |
| Toàn bộ giá vốn tăng 10% — lãi góp 12.460đ/bát | -2.137.333đ | -1.638.933đ | -1.265.133đ | -891.333đ | -268.333đ |
| Toàn bộ giá vốn tăng 20% — lãi góp 9.820đ/bát | -2.401.333đ | -2.008.533đ | -1.713.933đ | -1.419.333đ | -928.333đ |

**Diễn giải:** mục tiêu 20 bát/ngày chỉ tạo khoảng 470.000đ dư địa ở kịch bản cơ sở khi vận hành xe phở, và gần như không còn dư địa nếu toàn bộ giá vốn tăng 10%. Nếu vẫn thuê phòng sau khi mở cửa hàng, 20 bát/ngày còn âm khoảng 363.333đ trong kịch bản cơ sở. Vì vậy mục tiêu 20 bát/ngày không tự động chứng minh khả năng mở cửa hàng; phải xét quỹ dự phòng, thời điểm mua hàng và đường cong tiền mặt tích lũy. Kịch bản tăng 20% toàn bộ giá vốn là stress test nghiêm trọng, không được dùng làm sự kiện thường xuyên hoặc tạo phá sản tất yếu.

## 3. Risks requiring an explicit decision

### R1 — Debt-month volume target conflicts with the current customer curve

The GDD's 10–14 bowls/day learning target and 14–20 bowls/day stable-cart target do not reliably cover a 2,000,000 VND installment. Even 20 bowls/day leaves only 470,000 VND for the entire 10-day game month after the modeled fixed cost and debt payment.

**Owner decision (2026-10-21):** retain the nine-payment debt schedule; use 20 bowls/day as a provisional average sales target to test from the first repayment month, and 17 bowls/day as a stress case. This is a playtest target, not guaranteed customer behavior. Do not force or guarantee sales to make the installment affordable. Validate the progression through simulation and playtests.

### R2 — The model omits a safety buffer

The 17-bowl break-even point excludes spoilage, discarded broth, emergency market purchases, repairs, and labor. The GDD already requires a resilience test and recommends a 1,500,000 VND reserve before opening a shop.

**Owner decision (2026-10-21):** shop expansion remains optional and requires the opening cost plus a 1,500,000 VND reserve to remain available after the decision. Before implementation, test at least one low-sales month and one ingredient-cost shock.

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

## 5. Owner decisions recorded and remaining blockers

### Approved provisionally on 2026-10-21

1. Retain the debt principal of 18,000,000 VND and nine installments of 2,000,000 VND at the ends of game months 2–10; do not add automatic interest.
2. Use 20 bowls/day as a provisional average sales target from the first repayment month, with 17 bowls/day as a stress case. This is a test target, not a guaranteed customer curve.
3. Keep shop expansion optional and require the opening cost plus 1,500,000 VND reserve to remain available after opening.

### Still unresolved before implementation

4. Define exact ingredient quantities in the 300,000 VND opening stock, the first-day replenishment, and supplier-order timing.
5. Define the transaction order and warning UX for rent/utilities and debt installment at a month boundary.
6. Run the full cash-flow matrix with 10/14/17/20/25 bowls/day, +10%/+20% direct-cost shocks, waste, and emergency purchases.
7. Validate opening cash, deposits, prepaid rent, cost of goods sold, and stock purchases without double-counting.

## Conclusion

Do not change the debt principal or installment schedule silently. The present model indicates that 17 bowls/day is too fragile as an expected operating level during repayment. The next implementation-ready step is to resolve the above parameters and build a small, deterministic economy simulation/test matrix before integrating it with the selected game engine.
