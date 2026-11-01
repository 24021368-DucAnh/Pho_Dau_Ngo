# PHỞ ĐẦU NGÕ Gameplay Service Loop Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]) syntax for tracking.

**Goal:** Biến prototype một bát/một bàn thành một ngày bán phở góc nhìn thứ nhất với ba bàn, khách có phản hồi, hai bát/khay, thanh toán sau ăn, rửa theo mẻ và sổ cuối ngày chính xác.

**Architecture:** Giữ OrderManager, InventoryService, ServingService, Ledger, DayController và InteractiveBowl làm domain có thẩm quyền. Bổ sung dịch vụ nhỏ cho khách, bàn, khay, bữa ăn và rửa mẻ; ShiftCoordinator nối signal với scene/HUD để giảm trách nhiệm của PlayerController. Triển khai theo lát cắt thử được, không đặt các chức năng mới trực tiếp vào một script khổng lồ.

**Tech Stack:** Godot 4.4.1 Standard; GDScript; scene/resource; SceneTree tests; GitHub Actions desktop Windows/Linux. Asset mới dùng proxy có thể đọc được, không bypass các gate art.

**Spec:** docs/superpowers/specs/2026-10-28-gameplay-service-loop-design.md (G1 đã được chủ dự án duyệt ngày 2026-10-28).

**Status:** Bản kế hoạch được chuyển vào checkout ổ D theo yêu cầu chủ dự án; G1/G2 đã được duyệt ngày 2026-10-28. Dùng [kế hoạch lát cắt ổ D](2026-10-28-d-drive-gameplay-next-slice.md) để triển khai Task 0–2 tại đây. G0 nghiệm thu M7 bằng người chơi còn mở. Không tạo commit, PR, push, merge khi chưa có chỉ thị.

## Global Constraints

- Repo triển khai hiện tại: D:/Project_P/Pho_Dau_Ngo; Git root là thư mục Pho_Dau_Ngo, không chạy Git từ D:/Project_P.
- GDD v1.2 là baseline chưa được phê duyệt triển khai đầy đủ; phạm vi plan này là một ngày slice, không phải cả chiến dịch 100 ngày.
- Không reset/clean hoặc ghi đè các file đang modified/untracked, đặc biệt .github/workflows/godot-production.yml, game/tests/test_order_loop_used_bowl.gd, game/README.md, các file art/prototypes và các tài liệu art ngày 28/10.
- D1 dùng 3 bàn × 1 nhóm/1 bát mỗi phiếu; tối đa 3 đơn chờ; khay 2 bát; rack 4 bát. Tất cả con số lưu trong config và là giả thuyết cần playtest.
- Giữ hợp đồng tái và chín khác nguyên liệu; thiếu hàng/thao tác sai không trừ kho; tiền và tồn kho chỉ thay đổi qua domain services.
- Thống nhất ID bất biến (StringName) cho customer, order, table, bowl; chỉ một sở hữu vật lý trên tay/khay/kệ/bàn/rack.
- Mỗi sale:<order_id> xuất hiện tối đa một lần, kể cả nhấn nhanh hoặc retry sau lỗi một phần; không đưa logic thu tiền vào HUD hay NPC.
- Không thay giá 45.000 đ đang được ghi tạm, không mặc định giá GDD 40.000/45.000 đ đã được duyệt; duyệt DUC-49 trước khi mở pricing/catalog.
- Trước khi bắt đầu production: gate M7 hiện có, owner duyệt thiết kế G1, owner duyệt triển khai G2. Gate art 3D G3/G5 vẫn độc lập.
- Điều kiện xác nhận runtime phải là game chạy trong Godot và một bản playtest được lưu bằng chứng. Test/CI thành công không tự xác nhận trải nghiệm người chơi.
- Kiểm tra thay đổi scoped git status và diff trước/sau mỗi task; chỉ stage những file của task nếu được yêu cầu commit.

## Review Focus

1. Spam serve/settle và Ledger thất bại giữa chừng: có đúng một sale transaction, order paid đúng và có thể retry không?
2. Một bát cùng lúc trên tay/khay/bàn khi đổi mục tiêu, raycast trượt, scene mất node hoặc spam E có bị nhân bản/mất không?
3. Một khách rời bàn hoặc người chơi đóng sớm khi chưa giao/đang ăn: order, tiền và bát có thể đi tới trạng thái cuối hợp lệ không?
4. Đầy khay/rack hoặc rửa ngay khi bát vừa trả: có giữ số lượng, đánh dấu dirty đúng và tránh wash hoàn thành hai lần không?
5. Có hai bàn gọi phở tái/chín xen kẽ, món làm sai/đặt sai bàn: không thu tiền, không tự đổi công thức và có gợi ý xử lý không?
6. Bật pause/đóng menu và chạm đúng thời điểm timer hết: timer không chạy nền, GUI đọc được trên PC và không sinh đơn khi closing.

---

## Task 0: Xác lập M7 trước khi mở rộng

**Files:** Chỉ đọc game/scripts/*, game/scenes/main.tscn, game/tests/*; cập nhật kết quả thực tế vào docs/qa/PLAYTEST_RESULTS.md và docs/qa/VERTICAL_SLICE_ACCEPTANCE.md **chỉ khi đã quan sát trực tiếp**, giữ nguyên các thay đổi sẵn có.

**Interfaces:** Lấy OrderManager.create_order(...), transition_order(...), ServingService.serve_order(...), InteractiveBowl.wash(), DayController.close_day() làm baseline. Không đổi API.

- [ ] Chụp git status trong repo ổ D, xác minh HEAD và ghi nhận các file dirty trước khi triển khai tiếp.
- [ ] Chạy Godot 4.4.1 và các SceneTree suites hiện có trong project `game/` của ổ D; kết quả ở checkout cũ không thay cho lần chạy này.
- [ ] Chạy 10 lượt tái/chín đúng quy trình, rửa bát, giao một lần, thử sai trạm/thiếu hàng/nhấn lặp, C đóng ngày 2 lần; ghi PASS/FAIL, ảnh/video, SHA/OS/engine.
- [ ] Kiểm tra 3D props và hud phiếu, collision và reachability tại góc nhìn đứng. Ghi lỗi theo checklist M7; giải quyết blocker trước khi thêm NPC.
- [ ] **Gate G0:** Chủ dự án xem bằng chứng, quyết định M7 được chấp nhận hoặc nêu lỗi phải sửa; chưa tự đánh dấu accepted.

## Task 1: Tách điều phối ca khỏi điều khiển di chuyển

**Files:** Tạo game/scripts/gameplay/shift_coordinator.gd; chỉnh game/scripts/player_controller.gd và game/scenes/main.tscn; tạo game/tests/test_shift_coordinator.gd.

**Interfaces:**
- ShiftCoordinator.configure(order_manager: OrderManager, serving: ServingService, day: DayController, inventory: InventoryService) -> Dictionary.
- ShiftCoordinator.open_shift(day_id: StringName, opening_cash: int) -> Dictionary.
- ShiftCoordinator.request_close() -> Dictionary; ShiftCoordinator.finish_close() -> Dictionary.
- Signal shift_phase_changed(phase: int), shift_summary_ready(summary: Dictionary).
- Giữ DayController.start_day() và close_day() hiện có; giữ toàn bộ điều khiển WASD/chuột/E/Q/V/C, không phá test M7.

- [ ] Viết test trước: OPEN khi đã cấu hình, từ chối mở hai lần, CLOSING dừng sinh order, gọi close hai lần có cùng kết quả.
- [ ] Chạy test riêng để kiểm tra nó fail vì chưa có coordinator (không phải lỗi import bất ngờ).
- [ ] Triển khai state PRE_OPEN / OPEN / CLOSING / CLOSED, chuyển dây nối với DayController; controller chỉ gửi yêu cầu và hiển thị phản hồi.
- [ ] Chạy test mới, toàn bộ suite hiện có, mở scene; kiểm tra rằng cả 10 vòng cũ chưa đổi.
- [ ] Review việc đóng ngày khi có order mở: hiển thị một lựa chọn rõ, không xóa đơn âm thầm; chỉ xác nhận task nếu snapshot Ledger vẫn đúng.

## Task 2: Bàn có ID thật và khách gọi món theo kịch bản

**Files:** Tạo game/scripts/customers/customer_director.gd, game/scripts/tables/table_service.gd; tạo game/data/day01_customers.tres hoặc scene/resource fixture đã thống nhất; chỉnh game/scripts/orders/order_manager.gd, game/scenes/main.tscn; test game/tests/test_customer_tables.gd.

**Interfaces:**
- TableService.reserve_table(customer_id: StringName) -> Dictionary với table_id, ok; release_table(table_id: StringName) -> Dictionary; can_deliver(table_id: StringName, order_id: StringName) -> bool.
- CustomerDirector.configure(tables: TableService, orders: OrderManager, scenario: Resource) -> Dictionary; start_shift() -> void; stop_arrivals() -> void.
- Giữ OrderManager.create_order(order_id, recipe_id, table_id); nếu thêm customer_id, dùng đối số mặc định ở cuối hoặc method attach_customer(), không phá 3 đối số cũ.
- Sự kiện order_changed(order_id, snapshot) vẫn phát mỗi khi transition.

- [ ] Test fail trước: reserve không trùng bàn, release chỉ đúng người/ID, ba phiếu ba table_id, tối đa một đơn mở cho mỗi bàn, thứ tự sinh theo seed.
- [ ] Tạo ba vị trí bàn table-1/table-2/table-3 với bảng ID rõ; dùng placeholder khách có dáng đi/đứng nếu asset NPC chưa được duyệt.
- [ ] Đổi tạo phiếu khỏi logic _create_next_order sau wash; CustomerDirector sinh phiếu theo khách đã ngồi, không phụ thuộc một bát duy nhất.
- [ ] Chạy test riêng và suite cũ, kiểm tra serve sai bàn bị từ chối; quan sát tại scene raycast nhận zone table_id thật.
- [ ] Review: khách vào không chặn đường; UI hiển thị hàng đợi đúng, không làm tăng tốc quá mức tại D1.

## Task 3: Gắn bát vào phiếu và khay hai slot

**Files:** Tạo game/scripts/serving/tray_controller.gd và game/scripts/gameplay/cooking_coordinator.gd; chỉnh game/scripts/interactive_bowl.gd, game/scripts/placement_zone.gd, game/scripts/player_controller.gd, game/scenes/main.tscn; test game/tests/test_tray_and_order_binding.gd.

**Interfaces:**
- CookingCoordinator.bind_bowl_to_order(bowl_id: StringName, order_id: StringName) -> Dictionary, reject nếu bát/đơn đã có owner; lookup_bowl_order(bowl_id) -> StringName.
- TrayController.try_insert(bowl_id: StringName, slot_index: int) -> Dictionary; try_remove(slot_index: int) -> Dictionary; get_slots() -> Array.
- Bowl giữ các method hiện tại set_held(), try_place(), apply_recipe_step(), cancel_preparation(); thêm ID và owner state phù hợp, không đổi enum số hiện có (chỉ thêm cuối).

- [ ] Test fail: cầm bát rồi đặt slot 0/1, đầy 2 slot, trùng ID, sai slot, đổi vị trí liên tục, không sinh bát/stock/tiền.
- [ ] Thêm bowl_id bất biến và một state owner (AVAILABLE / PLAYER / TRAY / TABLE / RACK); chế biến chỉ trên bát hợp lệ, không cho một bát đã giao gắn đơn mới.
- [ ] Thêm khay proxy với hai Marker3D, vùng gắp/đặt đủ rộng; không yêu cầu vật lý chuyển động mô phỏng từng bát.
- [ ] Nối raycast/Area3D (collide_with_areas, collision mask), hiển thị bàn và món ở phiếu cho mỗi bowl.
- [ ] Chạy test mới + test cũ; thử đứng và bưng khay qua ba bàn; không cho phép giao bát từ slot trống.

## Task 4: Khách ăn rồi mới thu tiền, với migration an toàn

**Files:** Tạo game/scripts/customers/meal_service.gd, test game/tests/test_meal_and_payment.gd; sửa game/scripts/serving/serving_service.gd, game/scripts/orders/order_manager.gd, game/scripts/interactive_bowl.gd, game/scripts/gameplay/shift_coordinator.gd, game/scenes/main.tscn.

**Interfaces:**
- Giữ phục vụ cũ ServingService.serve_order(bowl, order_manager, order_id, table_id, sale_amount=-1) để suite legacy vẫn chạy trong giai đoạn chuyển; không gọi nó từ tuyến gameplay NPC mới.
- Thêm ServingService.deliver_order(bowl: InteractiveBowl, orders: OrderManager, order_id: StringName, table_id: StringName) -> Dictionary: chuyển order SERVED nhưng chưa ghi tiền.
- Thêm ServingService.settle_order(orders: OrderManager, order_id: StringName, sale_amount: int) -> Dictionary: xác nhận đang PAYMENT_PENDING, ghi Ledger với transaction_id sale:<order_id>, sau đó set paid và phát payment_recorded **một lần**.
- MealService.start_meal(order_id: StringName, customer_id: StringName) -> Dictionary và signal meal_finished(order_id: StringName). OrderManager bổ sung trạng thái payment độc lập, không chen giá trị vào giữa enum hiện có.
- InteractiveBowl thêm mark_in_service() và finish_consumption(); mark_served_dirty() legacy không bị đổi hành vi.

- [ ] Viết test fail: giao đúng bàn không tăng Ledger; ăn xong settle đúng một lần; settle sớm/sai bàn/sai món từ chối; transaction lỗi không set paid.
- [ ] Test retry sau bước Ledger thành công nhưng chưa set paid (tái dùng cùng transaction ID/payload) sẽ hoàn tất trạng thái, không ghi trùng.
- [ ] Thực hiện phương thức mới, nối sự kiện MealService vào ServingService; không tính doanh thu từ animation hay UI.
- [ ] Test timer khi pause; nếu NPC biến mất, MealService vẫn giải phóng được order qua state; không treo close.
- [ ] Chạy suite test cũ và mới, mô phỏng ba bàn; kiểm tra giao một đơn rồi bấm serve/settle liên tục.
- [ ] Review chuyển đổi gameplay: test cũ phục vụ ngay vẫn chứng minh hành vi legacy; test mới chứng minh luồng sau ăn, sau khi đổi scene thì bỏ đường thu ngay khỏi production gameplay.

## Task 5: Rửa theo mẻ và tách sinh khách khỏi rửa

**Files:** Tạo game/scripts/washing/wash_batch_service.gd; chỉnh game/scripts/interactive_bowl.gd, game/scripts/player_controller.gd, game/scenes/main.tscn; test game/tests/test_wash_batch.gd. Giữ test_order_loop_used_bowl.gd bản cũ đang dirty; nếu phải đổi test, review diff riêng.

**Interfaces:**
- WashBatchService.enqueue(bowl_id: StringName) -> Dictionary; start_batch() -> Dictionary; get_state() -> Dictionary.
- Signals wash_started(bowl_ids: Array), wash_finished(bowl_ids: Array). Rack capacity mặc định 4; batch_seconds cấu hình mặc định 6.0 (giả thuyết).
- Chỉ bowl DIRTY mới enqueue; CLEAN_AVAILABLE trở lại sau đủ thời gian; tạo order không phụ thuộc rửa.

- [ ] Test fail: đưa 3 bát bẩn vào rack, bắt đầu rửa, tạm dừng timer, chạy đủ bước thì chính xác 3 bát sạch; start lại không tạo thêm.
- [ ] Test từ chối bát đang nấu/đang ăn, rack đầy, ID không tồn tại, enqueue trùng; mỗi lỗi để nguyên state.
- [ ] Triển khai rack + giao diện một nút khởi động; có tiếng nước/animation proxy tùy chọn, không mini-game từng bát.
- [ ] Gỡ phụ thuộc wash() → _create_next_order() của controller khi toàn scene đã có CustomerDirector; giữ đường legacy đủ lâu để test cũ chạy, rồi bỏ khi migration đã có test thay thế.
- [ ] Chạy tất cả suite và manual trên scene; chốt close với rack còn bát theo quy tắc trong spec.

## Task 6: Phản hồi thời gian phục vụ, hướng dẫn và nhân vật đời thường

**Files:** Tạo game/scripts/ui/gameplay_hud.gd, game/scripts/gameplay/day01_tutorial.gd, game/scripts/customers/customer_feedback.gd; tạo scene UI và proxy NPC tương ứng trong game/scenes/; chỉnh game/scenes/main.tscn, game/scripts/player_controller.gd; test game/tests/test_tutorial_and_feedback.gd.

**Interfaces:**
- Day01Tutorial.advance_on_event(event_name: StringName, payload: Dictionary) -> void, get_current_hint() -> String.
- CustomerFeedback.evaluate(wait_seconds: float, order_correct: bool) -> Dictionary với reaction_key và level, không tự ghi tiền.
- GameplayHUD theo dõi order_changed/stock_changed/day_closed; phương thức display_state(snapshot: Dictionary) -> void chỉ đọc.

- [ ] Test fail: ba đơn tutorial đi theo **hành động thành công**; spam E không bỏ bước; phản hồi khách chờ lâu không làm mất đơn; pause chặn timer.
- [ ] Xây màn hình đọc phiếu 1–3 đơn, nhận diện bàn/món; hiển thị hướng dẫn ngắn dưới 3 dòng, màu kèm icon/chữ (không lệ thuộc màu).
- [ ] Tạo ba đoạn thoại ngắn của Lâm/Năm/Hường theo mốc sự kiện; cho bỏ qua, không đẩy dòng tiền và không khóa hoạt động bán hàng.
- [ ] Thêm tùy chọn giảm chuyển động, tốc độ chờ, tắt phạt chậm, pause khi mở sổ; xác minh cả bàn phím/chuột.
- [ ] Chạy suite, thực hiện smoke test ba bàn và đánh giá đọc phiếu từ khoảng cách chơi thực; làm art/UI final chỉ sau gate art riêng.

## Task 7: Tổng kết ngày, đo playtest, và nghiệm thu slice

**Files:** Tạo game/scripts/analytics/gameplay_telemetry.gd (ghi log opt-in, mặc định OFF nếu chưa có UI consent), test game/tests/test_shift_reconciliation.gd; chỉnh game/scripts/day_controller.gd và game/scripts/gameplay/shift_coordinator.gd nếu thực sự cần; cập nhật docs/qa/GAMEPLAY_PLAYTEST_PROTOCOL.md và docs/qa/PLAYTEST_RESULTS.md bằng số đo thật.

**Interfaces:** GameplayTelemetry.record(event_name: StringName, payload: Dictionary) -> void. Log JSONL chỉ dùng mã phiên ngẫu nhiên, không lưu tên/địa chỉ/giọng nói. Summary lấy duy nhất Ledger.get_day_totals(day_id), Inventory.snapshot(), OrderManager/telemetry có event key chính xác.

- [ ] Test fail: tổng sale revenue đúng bằng tổng unique sale transactions, retry settle không tăng tiền, bát bẩn/có đơn chưa xử lý ở closing được quyết định rõ.
- [ ] Instrument và kiểm tra event: shift_started, order_created, bowl_started, step_rejected, bowl_ready, order_delivered, meal_finished, payment_settled, wash_batch_finished, shift_closed, shift_abandoned.
- [ ] Test đơn hết hàng, hủy một phần, đóng sớm và đóng ngày hai lần; bảng tổng kết giải thích tồn/hủy và đúng tiền.
- [ ] Chạy import + tất cả test trong môi trường Godot 4.4.1, chạy export Windows/Linux trên cùng SHA. Ví dụ: godot --headless --path game --import; godot --headless --path game --script res://tests/test_shift_reconciliation.gd. Xác định vị trí binary trước khi gọi.
- [ ] Chạy manual playtest vòng 3 → 10 → 15/20 bát, ghi FPS trên phần cứng thử, video phiếu/bàn và bằng chứng thực tế; tính KPI theo denominators trong playtest protocol.
- [ ] **Gate G3 gameplay:** Owner review kết quả, chấp nhận hoặc tạo defect có bước tái hiện; nếu chưa đạt, ưu tiên sửa điểm gây bực/không đọc được trước khi thêm tính năng.

---

## Trình tự phụ thuộc và điều kiện dừng

G0 + G1 + G2 → Task 1 → Task 2 → Task 3 → Task 4 → Task 5 → Task 6 → Task 7 → G3. Có thể chuẩn bị UI proxy song song Task 2–3 **chỉ sau khi phê duyệt**, nhưng không chạy ghép scene đồng thời trên các file xung đột.

**Nguyên tắc review từng task:** phải có diff scoped chỉ chứa thay đổi liên quan, test mới thực sự bắt được lỗi trước khi sửa, toàn bộ test liên quan pass sau sửa, ghi rõ command/exit code và nếu chưa chạy thủ công thì đánh dấu pending. Nếu task làm hỏng invariant ở spec, dừng và sửa nguyên nhân trước khi làm tiếp.

**Chưa nằm trong plan:** cơ chế nhập hàng và lô/hạn, món thêm thịt/pricing chính thức, thuật toán tip, nâng cấp trang trí, lưu/load, nợ theo 100 ngày, ngày sự kiện, thuê nhân viên, toàn bộ mô hình NPC final, phát hành Steam. Sau slice sẽ mở từng spec/plan riêng dựa trên playtest.
