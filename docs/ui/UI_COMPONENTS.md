# PHỞ ĐẦU NGÕ — UI Components v0.1

**Status:** Initial reusable component contract for the first vertical slice.  
**Figma:** https://www.figma.com/design/feHazau3AOstL7wtSlEIBk

## 1. Design tokens (provisional)

| Token | Value / rule | Use |
|---|---|---|
| ui/bg | #242622 | Dark HUD backplate |
| ui/surface | #D8CCB5 | Paper and ledger panels |
| ui/surface-raised | #EEE5D3 | Cards and important rows |
| ui/text-primary | #282722 on paper; #F4EBDD on dark | Main copy |
| ui/text-muted | #777064 on paper; #C8C1B5 on dark | Secondary labels |
| ui/accent-active | #B97A2B | Current order / attention |
| ui/state-success | #4D6658 | Valid action / completed |
| ui/state-error | #9C443C | Rejection / shortage |
| ui/border | #898579 | Quiet separators |
| radius/panel | 8 px | Panel corners |
| space/base | 8 px | Base spacing unit |
| space/panel-padding | 20–24 px | Main panels |
| type/prompt | 20–24 px, semibold | Context prompt |
| type/body | 16–18 px, regular | Body and action labels |
| type/caption | 13–14 px, regular | Secondary metadata |
| type/total | 32–40 px, semibold | Closing cash/net change |

These values are provisional. Recheck contrast, diacritics and readability in Godot at the agreed runtime viewport.

## 2. Components

### UI/Reticle
- States: idle, focused, valid-target, invalid-target.
- Centered on screen; no click target semantics.
- Focus uses shape/weight plus color/contrast.
- Must not communicate success until the action result is confirmed.

### UI/ContextPrompt
- Fields: primary_text, input_hint, state.
- States: hidden, neutral, actionable, valid, rejected, disabled.
- One or two short lines maximum.
- Examples: “Nhặt bát”, “Đặt bát tại đây”, “Không thể đặt ở đây”.

### UI/FeedbackToast
- Fields: message, severity, optional reason.
- Severity: info, success, warning, error.
- Avoid stacking many toasts.
- Errors remain visible until acknowledged or a conservative minimum display time expires.

### UI/OrderTicket
- Fields: order_number, dish_name, current_step, optional time_hint.
- States: hidden, active, served, blocked.
- Hidden when no active order.
- Must not imply an order is served until the order controller confirms it.

### UI/DayStatus
- Fields: day_index, cash_display, optional stock_warning.
- Small persistent status; never authoritative.
- Cash is formatted from the economy/ledger source of truth.
- Warnings appear only when backed by actual inventory/economy state.

### UI/Panel
- Variants: paper, dark HUD, raised card.
- Shared spacing, border, title and content slots.
- No decorative texture that reduces legibility.

### UI/PrimaryButton
- States: normal, hover/focus, pressed, disabled, loading.
- One main action per screen.
- Disabled/loading states explain why or show progress where useful.
- Continue/retry actions must be idempotent at the controller boundary.

### UI/TransactionRow
- Fields: label, detail, signed amount, category.
- Categories: sales, ingredients, rent, utilities, debt, other.
- Sign and label communicate effect; color is supplementary.
- Row amounts sum to ledger-derived totals; UI never owns arithmetic.

### UI/MetricCard
- Fields: label, value, optional explanation.
- Used for opening cash, revenue, costs, closing cash and net change.
- Emphasize closing cash and net change without obscuring derivation.

## 3. Interaction states

| State | Visual behavior | Input behavior |
|---|---|---|
| Normal | Base contrast | Accept valid action |
| Hover / focus | Clear border or fill change | Keyboard focus remains visible |
| Pressed | Short, clear pressed state | Prevent accidental repeated activation |
| Disabled | Lower emphasis + reason when useful | Ignore action |
| Loading | Progress text / spinner if needed | Disable duplicate submission |
| Success | Green/positive accent + confirmation text | Return to stable state |
| Error | Red/negative accent + reason | Preserve authoritative state; retry only if safe |

## 4. Naming and scene mapping (Godot)
Proposed reusable scenes:
- res://ui/components/context_prompt.tscn
- res://ui/components/feedback_toast.tscn
- res://ui/components/order_ticket.tscn
- res://ui/components/day_status.tscn
- res://ui/components/primary_button.tscn
- res://ui/components/transaction_row.tscn
- res://ui/screens/day_summary.tscn

Use scripts for presentation and signals, not for owning game rules. Use typed data objects/resources or controller-provided snapshots for component inputs.

## 5. QA rules
- Check every state at 1280×720 before scaling to other resolutions.
- Test Vietnamese accents in packaged fonts, not only in Figma.
- Keyboard/mouse input and focus indication must be visible.
- Never use green/red as the only state signal.
- Test empty, loading, success, error, disabled and repeated-click states.
- For ledger totals, use known fixtures and assert exact reconciliation in automated tests.
