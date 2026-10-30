# PHỞ ĐẦU NGÕ — Next Gameplay Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ổn định scene trên ổ D, tách điều phối ca khỏi PlayerController, rồi đưa ba bàn và khách gọi món theo kịch bản vào một lát gameplay chơi được.

**Architecture:** Giữ các dịch vụ domain hiện tại làm nguồn dữ liệu có thẩm quyền. ShiftCoordinator quản lý pha ca; TableService giữ quyền sở hữu bàn; CustomerDirector tạo phiếu theo kịch bản. PlayerController chỉ nhận input, chọn mục tiêu và hiển thị phản hồi. Đây là lát cắt đầu của [kế hoạch 8 task đã duyệt](2026-10-28-gameplay-service-loop-implementation.md), không thay đổi quy tắc giá hay art asset gốc.

**Tech Stack:** Godot 4.4.1, GDScript, SceneTree tests, `game/scenes/main.tscn`.

**Spec:** [Thiết kế gameplay B đã duyệt](../specs/2026-10-28-gameplay-service-loop-design.md).

## Global Constraints

- Chỉ làm việc trong `D:/Project_P/Pho_Dau_Ngo`; Git root là thư mục này. Checkout hiện tại: `cleanup/remove-stool-v2`, HEAD `fdb8503e3aaf35c11679b325d9babd1f5f97d0a5` lúc lập kế hoạch.
- Giữ nguyên các sửa đổi đã có tại `game/project.godot`, ba file `CHOPSTICKS_bundle_*.glb.import` và `game/scenes/main.tscn`. Chụp diff trước mỗi lần đụng cùng file; không reset/clean.
- Scene ổ D vừa nhận vùng đặt bát nhỏ hơn và `game/scripts/art/cart_stainless_finish.gd`; chưa có kiểm tra hình ảnh trực tiếp hay toàn bộ suite cho thay đổi này.
- D1: ba bàn, một nhóm và một bát mỗi phiếu; tối đa ba đơn chờ; giá 45.000 đ trong prototype vẫn là tạm thời. Không mở pricing DUC-49.
- Bát, bàn, khách và đơn dùng ID `StringName` ổn định. Một bát chỉ có một chủ sở hữu; doanh thu chỉ được ghi qua ServingService/Ledger.
- Phê duyệt phương án B và kế hoạch triển khai đã có. Chấp nhận M7 bằng người chơi vẫn là kết luận riêng; không ghi PASS từ kết quả headless.
- Không commit, push, tạo PR hoặc merge khi chưa có chỉ thị. Chỉ sửa file thuộc task đang thực hiện.

## Review Focus

1. Vùng đặt bát bị raycast trúng ngoài mặt bàn hoặc bát xuyên/treo: kiểm tra mép bàn, marker và collision ở cả bàn phục vụ lẫn bàn giao.
2. Vật liệu xe đổi nhầm kính hoặc cao su: xác nhận chỉ các surface `Inox` và `InoxDark` nhận override sau khi Godot nhập GLB.
3. Nhấn C khi còn đơn mở: không được xóa đơn âm thầm hoặc cộng doanh thu sai.
4. Khách đến khi ba bàn đã có người hay ca đang đóng: không cấp bàn trùng và không tạo phiếu mới.
5. Món tái/chín giao sai bàn: giữ nguyên order, bát và Ledger; phản hồi cho người chơi biết lỗi.

---

## Task 0: Chốt scene hiện tại trên ổ D

**Files:** `game/scenes/main.tscn`, `game/scripts/art/cart_stainless_finish.gd`; chỉ cập nhật `docs/qa/PLAYTEST_RESULTS.md` nếu có quan sát runtime thật.

**Interfaces:** Giữ `PlacementZone.get_placement_transform()` và raycast interaction layer 2; không đổi gameplay domain.

- [ ] Lưu `git diff -- game/project.godot game/scenes/main.tscn` và trạng thái file trước sửa; đối chiếu với thay đổi có sẵn trên nhánh này.
- [ ] Mở scene trong Godot 4.4.1 từ ổ D. So góc nhìn người chơi: hai vùng đặt bát nằm trên mặt bàn, hitbox không tràn mép, vùng giao/rửa không còn tấm xanh lơ lửng.
- [ ] Kiểm tra `CartMesh` sau nhập GLB: thân xe sáng màu inox có phản xạ mềm; kính vẫn trong, lốp vẫn cao su. Nếu tên material nhập khác `Inox`/`InoxDark`, chỉnh bộ lọc theo surface thực tế.
- [ ] Thử cầm, đặt, giao và rửa một bát trong scene; sửa đúng blocker quan sát được. Chạy `Godot --headless --path game --quit-after 2` để bắt lỗi parse; chạy kiểm tra tương tác hiện có nếu thay đổi hitbox.
- [ ] Ghi ảnh và kết quả thật vào QA; giữ trạng thái M7 manual chưa được chấp nhận cho đến khi có phiên chơi đủ tiêu chí.

## Task 1: ShiftCoordinator giữ pha ca

**Files:** Tạo `game/scripts/gameplay/shift_coordinator.gd`, `game/tests/test_shift_coordinator.gd`; sửa `game/scripts/player_controller.gd` và `game/scenes/main.tscn`.

**Interfaces:** `configure(orders: OrderManager, serving: ServingService, day: DayController, inventory: InventoryService) -> Dictionary`; `open_shift(day_id: StringName, opening_cash: int) -> Dictionary`; `request_close() -> Dictionary`; `finish_close() -> Dictionary`; `can_accept_arrivals() -> bool`. Signal `shift_phase_changed(phase: int)` và `shift_summary_ready(summary: Dictionary)`. Pha `PRE_OPEN`, `OPEN`, `CLOSING`, `CLOSED`.

- [ ] Viết test cho mở ca một lần, từ chối mở lặp, chặn đơn mới ở CLOSING, đóng lặp trả cùng summary và không ghi thêm Ledger; chạy test riêng để thấy lỗi chức năng còn thiếu.
- [ ] Cài ShiftCoordinator với DayController hiện tại. `request_close` chuyển sang CLOSING, báo số đơn mở; `can_accept_arrivals()` chỉ đúng ở OPEN. `finish_close` đóng Ledger và phát summary một lần.
- [ ] Chuyển mở/đóng ca trong PlayerController sang coordinator, giữ WASD/chuột/E/Q/V/C và HUD hiện tại. Khi còn đơn mở, lần bấm C đầu hiện cảnh báo, lần bấm C tiếp xác nhận đóng sớm; sau khi CLOSED, bấm C trả lại cùng summary. Nối node vào `main.tscn`.
- [ ] Chạy test mới, các suite hiện có và mở scene; xem thao tác C khi đang có đơn không làm mất đơn. Ghi diff riêng của task.

## Task 2: Ba bàn có ID và khách gọi món

**Files:** Tạo `game/scripts/tables/table_service.gd`, `game/scripts/customers/customer_director.gd`, fixture `game/data/day01_customers.tres` và `game/tests/test_customer_tables.gd`; sửa `game/scripts/orders/order_manager.gd`, `game/scripts/player_controller.gd`, `game/scenes/main.tscn`.

**Interfaces:** `TableService.reserve_table(customer_id: StringName) -> Dictionary`, `release_table(table_id: StringName) -> Dictionary`, `can_deliver(table_id: StringName, order_id: StringName) -> bool`; `CustomerDirector.configure(tables: TableService, orders: OrderManager, scenario: Resource) -> Dictionary`, `start_shift() -> void`, `stop_arrivals() -> void`. Giữ `OrderManager.create_order(order_id, recipe_id, table_id)` tương thích ba đối số.

- [ ] Viết test cho ba bàn không trùng chủ, mỗi bàn tối đa một đơn mở, thứ tự khách theo kịch bản và không sinh khách ở CLOSING; chạy để thấy lỗi chức năng còn thiếu.
- [ ] Gắn table ID rõ vào ba bàn đang có. Thêm vùng đặt bát đúng mặt từng bàn; dùng proxy khách cho đến khi art NPC được duyệt.
- [ ] Chuyển sinh phiếu sau rửa bát sang CustomerDirector; ba phiếu có `table_id` riêng và không phụ thuộc một bát duy nhất.
- [ ] Từ chối giao sai bàn và hiển thị lý do. Chạy test mới, suite cũ, rồi thao tác trong scene với hai đơn tái/chín xen kẽ.

## Handoff sau lát cắt

Sau Task 2, rà diff toàn nhánh và sửa lỗi quan trọng quan sát được. Tiếp tục Task 3 của [kế hoạch gốc](2026-10-28-gameplay-service-loop-implementation.md): gắn bát vào phiếu và khay hai slot. Báo chính xác phần đã chơi thử, phần chỉ qua test, và phần còn chờ art/owner review.
