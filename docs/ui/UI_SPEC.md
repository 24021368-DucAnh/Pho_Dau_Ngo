# PHỞ ĐẦU NGÕ — UI Specification v0.1

**Status:** First-pass wireframe specification for owner testing; not final polish.  
**Engine:** Godot 4, selected by owner on 2026-10-22.  
**Figma:** https://www.figma.com/design/feHazau3AOstL7wtSlEIBk

## 1. Product principles
- Vietnamese-first UI; use natural, concise Vietnamese copy with full diacritics.
- First-person immersion is the default. UI appears only when it helps the next action.
- UI presents game state; it never owns authoritative money, inventory, recipe, bowl or order state.
- Use shape, text and icon plus color to convey state; never rely on color alone.
- Prioritize the bowl, station, current order and serving target over decorative UI.
- No full settings, narrative menu system, inventory dashboard or campaign map in the first slice.

## 2. Target and layout assumptions
- Working mock viewport: 1280 × 720, 16:9. Design baseline only, not a locked minimum requirement.
- Safe margins: 32 px from screen edges; reserve the center 20% for first-person focus and interaction.
- Primary input: keyboard + mouse. Core interaction must not require precise UI clicks.
- Typography: Inter is the initial study font from the Visual Bible; verify Vietnamese diacritics, runtime availability and redistribution license before shipping.
- UI color roles: dark charcoal for HUD backplates, old limewash for paper/panels, broth amber for attention/active state, glazed green for valid/success, restrained red for error/shortage.

## 3. Screen A — First-person interaction HUD

### Purpose
Keep the player in the world while communicating what can be interacted with and what happened after an action.

### Hierarchy
1. Center reticle: tiny neutral crosshair; focused target changes shape/contrast.
2. Context prompt below reticle: short action verb and input, e.g. “Nhặt bát · E / Chuột trái”, “Đặt bát · E / Chuột trái”, “Không thể đặt ở đây”.
3. Bottom-left daily status: day number, cash balance and compact ingredient warning only when relevant.
4. Upper-right order ticket when an order exists: customer/order number, dish and state.
5. Short feedback line near lower center: success, rejection or stock warning; errors remain readable long enough.

### States
- Idle: no target; neutral reticle; no action prompt.
- Focused interactable: high-contrast reticle and prompt.
- Valid placement: explicit “Đặt bát tại đây”; placement zone has visual and textual feedback.
- Invalid placement: “Không thể đặt ở đây”; held item remains held and no game state changes.
- Action success: concise confirmation such as “Đã đặt bát”.
- Action failure: readable reason if known; otherwise “Thao tác chưa thực hiện”.
- Order active: one compact ticket with dish and current serving step.
- No active order: hide the ticket rather than show empty decorative UI.

### Interaction contract
- Prompt is derived from the focused target and authoritative player/item state.
- HUD may request an action but must not mutate authoritative state itself.
- Invalid placement feedback must correspond to the interaction controller's rejected result.
- UI scenes subscribe to state changes or read a view-model; avoid unnecessary whole-scene polling each frame.

## 4. Screen B — End-of-day summary / ledger

### Purpose
Close the vertical-slice loop with a readable accounting of the day, show what changed and let the player continue.

### Required data
- Day identifier.
- Opening cash and closing cash.
- Revenue grouped by orders/sales.
- Ingredient purchases/consumption cost, if implemented in the ledger.
- Rent/utilities/debt only when an actual transaction occurred that day.
- Net daily change and a clear explanation of the arithmetic.
- Remaining stock only if stock state is authoritative and implemented.
- Compact event list for completed orders, failed orders and material transactions.

### State behavior
- Loading: “Đang tổng hợp sổ ngày…”; do not show invented zeros as real data.
- Success: show totals derived from ledger entries and provide “Tiếp tục”.
- Empty day: “Hôm nay chưa có giao dịch”; totals remain consistent with the ledger.
- Error: “Chưa thể tổng hợp sổ ngày”; preserve the ledger and allow safe retry/back without duplicate transactions.
- Continue is idempotent; reopening the summary must not create another day or duplicate a payment.

### Accounting rule
The screen is a projection of ledger transactions. It may format or group entries, but must never calculate a separate authoritative balance. Each total must be traceable to ledger entries and covered by deterministic tests.

## 5. Flow through one sample day
1. Enter the stall; HUD shows current day and opening cash.
2. A customer/order becomes active; order ticket appears.
3. Player focuses a station/object; contextual prompt describes the next valid action.
4. Player prepares/serves; feedback confirms the state transition from gameplay.
5. Invalid actions show rejection without mutating the item/order.
6. Day ends; summary is opened from the day controller, not a HUD-only timer.
7. Summary shows ledger-derived opening/closing cash, sales, costs and net change.
8. Player selects “Tiếp tục”; next playable state opens exactly once.

## 6. Accessibility and readability
- Initial text study: 16 px secondary labels, 20–24 px main prompts, 28–36 px major totals at 1280×720; verify in runtime.
- Keep copy short; avoid long instructions during first-person play.
- Focus/error/success states need text and contrast differences, not color alone.
- Avoid text over busy world geometry when a subtle backplate improves legibility.
- UI scale and localization beyond Vietnamese are out of first-slice scope.

## 7. Runtime architecture boundary
- Gameplay systems own item, order, station, cash and ledger state.
- UI scenes subscribe to state changes and send explicit commands to controllers.
- Ledger owns transactions and balance history; summary reads a snapshot/query from ledger.
- No button click may directly edit cash/inventory/order state in a UI script.
- UI-only state can reset without changing gameplay state.

## 8. Open validation points
- Confirm 1280×720 readability and UI scale on the owner's PC during the first runnable Godot build.
- Confirm final font license and packaged font supports Vietnamese.
- Tune prompt placement against actual first-person camera and art pass.
- Validate order-ticket placement after playtest; keep center clear.
- Do not lock final palette, animation durations or performance budgets until runtime test.

## 9. Acceptance checklist
- [ ] Player understands the current interaction without opening a menu.
- [ ] Focus, valid placement, invalid placement, success and failure are visually/textually distinct.
- [ ] Order ticket is hidden when no order is active.
- [ ] End-of-day totals reconcile exactly with ledger test data.
- [ ] Empty/loading/error summary states do not invent financial data.
- [ ] Continue/retry/reopen cannot duplicate ledger transactions or advance the day twice.
- [ ] HUD does not obstruct the center gameplay target.
- [ ] Owner reviews wireframe and visual direction before runtime UI polish.
