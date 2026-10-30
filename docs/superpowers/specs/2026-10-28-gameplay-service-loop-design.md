# PHỞ ĐẦU NGÕ — Thiết kế trải nghiệm và gameplay ngày bán phở (ĐÃ DUYỆT G1)

> G1 đã được chủ dự án duyệt ngày 2026-10-28: chọn phương án B và nhịp 3 đơn hướng dẫn → 10 bát → thử 15/20 bát. G2 được duyệt cùng kế hoạch triển khai 8 giai đoạn. Gate G0 (chấp nhận baseline M7 hiện tại) vẫn chờ chủ dự án xem bằng chứng.

**Ngày:** 2026-10-28
**Trạng thái:** G1 thiết kế và G2 kế hoạch đã được chủ dự án duyệt ngày 2026-10-28; G0 baseline M7 vẫn chờ xem xét. Các phần gameplay đã được triển khai từng bước; nghiệm thu chơi trực tiếp vẫn đang chờ.
**Phạm vi:** Godot 4.4.1, PC chơi đơn, góc nhìn thứ nhất, một ngày bán phở chơi được và có thể đo lường.
**Nền tảng:** [GDD v1.2](../../PHO_DAU_NGO_GDD_v1_2_Tieng_Viet.md), [quyết định quy trình phở](../../design/pho-workflow-domain-decision.md), [tiêu chí chấp nhận M7](../../qa/VERTICAL_SLICE_ACCEPTANCE.md).
**Kế hoạch triển khai:** [Gameplay Service Loop Implementation Plan](../plans/2026-10-28-gameplay-service-loop-implementation.md).
**Quy trình đo:** [Gameplay Playtest Protocol](../../qa/GAMEPLAY_PLAYTEST_PROTOCOL.md).

## 1. Quyết định cần đạt

Tạo một trải nghiệm mà người chơi muốn tiếp tục bán thêm một bát vì **cảm giác thao tác làm phở dễ chịu**, **nhìn thấy tác động của việc mình phục vụ hàng xóm**, và **có lựa chọn nhỏ nhưng thật** trong giờ đông khách. Người chơi không cần phản xạ cực nhanh; thành thạo đến từ đọc phiếu, chuẩn bị đúng, sắp thứ tự phục vụ và quản lý nguồn lực.

### Ba hướng đã cân nhắc

| Hướng | Điểm mạnh | Giá phải trả | Khuyến nghị |
| --- | --- | --- | --- |
| A — Arcade chạy đua thời gian, nhiều đơn cùng lúc | Cao trào nhanh, dễ tạo thử thách | Dễ biến Hà Nội đời thường thành chuỗi QTE; rủi ro khó chịu khi chơi một mình | Không chọn làm mặc định |
| B — Cozy Cooking + quản lý quán nhẹ + chuyện hàng xóm | Hợp GDD, tạo nhịp thao tác tay và tình cảm; mở rộng được theo ngày | Cần làm phản hồi hình/âm tốt và cân bằng thời gian chờ | **Đề xuất chọn** |
| C — Quản lý kinh tế và nâng cấp quán là chính | Có chiều sâu chiến lược dài hạn | Dễ biến phần làm phở thành thao tác thứ yếu, đòi hỏi nhiều UI/dữ liệu sớm | Để sau khi chứng minh vòng nấu |

**Quyết định G1:** B là chế độ cốt lõi; chỉ bổ sung lựa chọn áp lực cao sau playtest. Không làm roguelite, multiplayer, thế giới mở, nấu tự động hoặc hệ thống 100 ngày ở giai đoạn này.

### Cơ sở tham khảo và giới hạn suy luận

1. *Good Pizza, Great Pizza* mô tả cảm giác trực tiếp chế biến, khách có cá tính, chuyện kể và nâng cấp cửa hàng như các thành phần trải nghiệm. Đây là ví dụ về **cấu trúc gameplay** chứ không phải bằng chứng chúng sẽ tăng retention cho Phở Đầu Ngõ: https://store.steampowered.com/app/770810/
2. *PlateUp!* kết hợp chế biến, bố trí dụng cụ, phục vụ, sự kiên nhẫn của khách và nâng cấp giữa ca. Chỉ học bài học về **quyết định sắp việc/ưu tiên**; không sao chép nhịp gấp hoặc mất quán: https://store.steampowered.com/app/1599600/ ; https://www.plateupgame.com/presskit/
3. *Game Accessibility Guidelines* khuyến nghị tránh bắt bấm lặp hoặc đòi hỏi thao tác đúng thời điểm tuyệt đối; Steamworks gợi ý điều chỉnh độ khó và lưu tiến trình. Đây là hướng thiết kế tiếp cận, chưa phải đánh giá khả năng tiếp cận của bản game hiện tại: https://gameaccessibilityguidelines.com/full-list/ ; https://partner.steamgames.com/doc/accessibility_features
4. Tất cả thời lượng, công suất, tỉ lệ hoàn thành, cảm xúc và mức độ hấp dẫn dưới đây là **giả thuyết thiết kế**, không phải số đo người chơi hay chuẩn ngành.

## 2. Sự thật về bản game ngày 28/10/2026 (đọc mã nguồn, chưa phải kiểm chứng cảm giác chạy)

- Godot 4.4.1, mã nguồn chính trong **game/**; scene chạy chính **game/scenes/main.tscn**.
- **player_controller.gd** nhận WASD, chuột, E/click, Q hủy bát, V chọn tái/chín giữa hai đơn, C đóng ngày; điều phối trực tiếp quá nhiều hệ thống.
- **recipe_data.gd** có hai nhánh công thức: bánh phở → thịt tái sống thái mỏng hoặc thịt chín sơ chế → nước dùng. Trụng bánh phở và sơ chế thịt mới được mô tả bằng dữ liệu, chưa có thao tác thời gian/animation thực sự.
- **kitchen_station.gd** kiểm tra bước đúng và tồn kho rồi trừ nguyên liệu đúng một lần, hoàn kho nếu ghi bước lên bát không thành công.
- **interactive_bowl.gd** phân biệt CLEAN / IN_PROGRESS / READY_TO_SERVE / DIRTY và AVAILABLE / HELD / PLACED. Hiện một bát; sau phục vụ phải cầm bát bẩn và rửa trực tiếp.
- **order_manager.gd** có ACCEPTED → PREPARING → READY → SERVED hoặc CANCELLED; hỗ trợ nhiều bản ghi nhưng trong scene chỉ tạo đơn kế tiếp sau khi rửa, cùng **table-1**.
- **serving_service.gd** dùng ID giao dịch sale:<order_id> và **Ledger** để chống ghi thu trùng. Hiện thu tiền ngay khi giao và đánh dấu bát bẩn ngay; chưa có thời gian ăn/thanh toán sau bữa.
- **day_controller.gd** chốt ngày và lấy tồn kho + số tiền từ nguồn gốc. Mức mở ngày 100.000 đ và giá 45.000 đ trong controller là **tạm tính**, không phải danh mục giá đã duyệt.
- Các mẫu bàn vật lý không đồng nghĩa với hệ thống nhiều bàn. Chưa có khách NPC, đi ăn, xếp hàng, khay 2 bát, rửa theo mẻ, lưu game, nhà cung cấp, chiến dịch hay bảng playtest có kết quả.
- CI trên commit b35701a có bằng chứng headless/export theo vòng trước; **chưa thay thế** kiểm thử first-person thủ công. Cần hoàn tất M7 hiện hành trước khi khẳng định playable.

## 3. Những gì người chơi thấy và làm

### Vòng 20 giây, vòng một khách, vòng một ngày

**Vi mô — bát phở:** nhìn phiếu đúng bàn/món → cầm bát sạch → trụng bánh phở → thêm thịt phù hợp → chan nước dùng → nhìn bát thành hình, nghe tiếng chan và hơi nóng → đặt lên kệ/khay. Phản hồi cho từng bước phải nhận ra được bằng hình, tiếng và dòng chữ ngắn; mỗi lần nhấn chỉ kích hoạt một bước.

**Một khách:** khách tới và ngồi/được sắp bàn → phiếu hiện ở bảng → chế biến → bưng đến đúng bàn → khách ăn, phản ứng → trả tiền một lần → thu bát → khu rửa. Người chơi được lựa chọn làm đơn nào trước khi hai bàn gọi khác nhau.

**Một ngày:** đọc mục tiêu và dự kiến hàng → mở quán → 1–3 đơn hướng dẫn → nhịp đều → một đợt đông khách nhẹ (chỉ khi đủ khả năng) → tự quyết đóng khi hết ca hoặc sớm hơn → sổ cuối ngày → một lời thoại/khoảnh khắc hàng xóm → muốn bán ngày tiếp theo.

**Vòng dài (CHƯA xây ở slice):** tích lũy uy tín → dụng cụ gọn hơn và công thức phong phú hơn → giao dịch, chi phí, nợ và câu chuyện Minh. Giữ cấu trúc GDD: **100 ngày / 10 tháng, 10 ngày/tháng; nợ gốc 18 triệu, trả 2 triệu cuối tháng 2–10**. Không tự thực thi nợ bằng hệ thống giá/thu nhập chưa duyệt.

### Onboarding D1 — luồng theo thời điểm, không khóa cứng thời gian

| Bước | Người chơi | Phản hồi / mục tiêu học | Nếu sai |
| --- | --- | --- | --- |
| Mở cảnh (tối đa ~45s mục tiêu) | Lâm chỉ chiếc xe, Minh cầm phiếu đầu tiên | Nhìn rõ phở tái/chín, số bàn và trạm | Có nút bỏ qua thoại; không mất tiến độ |
| Bát #1 | Cầm bát, làm ba bước với điểm nhấn đơn giản | Nghe và thấy bánh phở, thịt, nước; ghi nhớ E | Trạm sai nêu bước đúng; không trừ kho |
| Phục vụ #1 | Đặt khay/bát tới bàn sáng rõ | Khách nói cảm ơn; phiếu chuyển trạng thái | Sai bàn giữ món, không thu tiền |
| Bát #2 | Phiếu khác loại thịt | Học phân biệt thịt tái và thịt chín đã sơ chế | Nhìn sổ công thức bất kỳ lúc nào |
| Bát #3 | Hai bàn có thể gọi gần nhau | Học chọn thứ tự, khay 2 bát nếu đã mở khóa | Không có đếm ngược thất bại |
| Khép ngày | Tập kết bát, khởi động rửa mẻ, đóng sổ | Doanh thu, tồn, hao hụt, tiền cuối ca khớp Ledger | Hệ thống giải thích nếu còn đơn chưa xử lý |

**Nguyên tắc nhịp:** không bắt hoàn thành bước trong giây cố định; tutorial hiện theo **hành động đã thành công**, không theo việc hết giờ. Tooltip thu nhỏ sau ba lần thành thạo, có thể mở lại.

## 4. Thiết kế cơ chế, hợp đồng và xử lý lỗi

### 4.1 Khách, bàn, phiếu, hàng chờ

Phạm vi slice kế tiếp: tối đa **3 bàn hoạt động**, mỗi bàn có **1 nhóm khách / 1 phiếu đang mở**; một phiếu chỉ yêu cầu **1 bát** trước khi làm nhóm nhiều bát. Sinh khách theo kịch bản D1 (dễ tái hiện), sau đó mới thêm seed ngẫu nhiên. Mỗi khách có: customer_id, archetype, table_id, recipe_id, arrival_sequence, state, dialogue_key. Định danh bất biến.

Luồng khách: SCHEDULED → ARRIVING → SEATED → ORDERING → WAITING_FOOD → EATING → PAYMENT_PENDING → LEAVING → EXITED. Người chơi không cần click từng NPC để biết món; khách gọi khi đến bàn. Không ngồi được hoặc bàn đang bận thì khách đợi/có thể quay lại theo quy tắc mềm; không chiếm trùng ghế.

Luồng phiếu dùng **OrderManager** hiện có làm nguồn sự thật. Trong slice tạm giữ enum ACCEPTED / PREPARING / READY / SERVED / CANCELLED. Để phục vụ và thanh toán khác thời điểm, cần **bổ sung trạng thái SETTLED hoặc trạng thái payment độc lập** theo kế hoạch sau khi duyệt, tuyệt đối không tự nhận SERVED đồng nghĩa đã thu tiền. Mỗi order_id trỏ một recipe_id, table_id, customer_id, bowl_id và một transaction_id; các trường bổ sung phải có đường tương thích cho test hiện hành.

Năng lực đề xuất: tối đa **3 đơn chờ chế biến** cùng lúc, khách thứ 4 xuất hiện sau khi có chỗ, không nhồi thông báo. Thời gian đợi kéo dài chỉ làm đổi nét mặt/lời thoại/tiền tip (tip chưa triển khai), **không tự biến đơn thành thất bại**. Điều chỉnh nhịp dần theo năng lực người chơi; ngừng tạo đơn khi đóng ca.

### 4.2 Làm phở chân thực nhưng không thành thao tác vụn

| Bước | Yêu cầu hệ thống | Cảm giác/UX | Bảo toàn dữ liệu |
| --- | --- | --- | --- |
| Bánh phở | Chọn trạm trụng, nhấn E một lần; diễn hoạt ngắn/tiến trình có thể hủy an toàn | Nước sôi, bánh phở nhấc lên/ráo | Chỉ tiêu thụ 1 đơn vị **noodles** khi bước thành công; tránh nhấn lặp |
| Thịt tái | Lấy **raw_sliced_beef**, xếp lên bánh phở | Thịt lát mỏng trước nước dùng | Không gọi chung thao tác trụng bò |
| Thịt chín | Lấy **cooked_sliced_beef** đã xử lý trước | Màu/chất liệu khác tái | Tồn kho riêng |
| Nước dùng | Chan sau cùng; phản hồi hơi nóng, ánh sáng/âm thanh | Bát hoàn thiện rõ nhìn | Trừ **broth** một lần, READY_TO_SERVE |
| Hủy giữa chừng | Q chỉ khi đang chế biến | Thông báo hao hụt, lựa chọn xác nhận nếu được phát hiện nhấn nhầm trong playtest | Không hoàn nguyên số nguyên liệu đã dùng, không mất đơn |

Chỉ có bát sạch mới được nấu. Không có trạng thái âm lượng/kho âm; renderer đọc state, không quyết định cooking state. Bước sai, thiếu nguyên liệu, click quá nhanh hoặc click vào vật biến mất **không thay đổi** inventory, recipe_step_index hay ledger. Bát hoàn chỉnh phải được gắn chính xác vào một order_id; không đổi món sau khi đã bắt đầu bát.

Các thao tác trụng/thêm/chan phải có 2 chế độ hiệu ứng: **đầy đủ** và **rút gọn** (không xóa quyết định nguyên liệu). Không bắt bấm liên tục. Quy tắc trụng/nấu trong game chỉ là trừu tượng gameplay, không phải hướng dẫn an toàn thực phẩm.

### 4.3 Khay hai bát, bàn, giao món

Chọn **khay ban đầu tối đa 2 bát** để đúng GDD; cho phép bưng 1 bát nếu chưa học khay. Khay sở hữu hai slot xác định, mỗi slot có tối đa một bowl_id. Thêm/rút bát là thao tác atomic; không mất bát khi quay/chạy/đặt sai. Dùng đúng table_id từ vùng giao món thực tế; **không lấy current_table_id từ người chơi làm giá trị mặc định khi giao**. Giao sai bàn giữ nguyên trạng thái, không phát doanh thu.

Giao một bát thành công: order chuyển SERVED, bát chuyển sang vị trí bàn/khách ăn; **chưa đánh dấu bẩn, chưa ghi tiền** trong chế độ thanh toán sau ăn. Khi bữa ăn kết thúc, customer chuyển PAYMENT_PENDING và hoàn tất tiền bằng một giao dịch sale:<order_id>, một lần duy nhất; sau đó bát DIRTY để thu gom. Hiện mã legacy thu ngay khi giao; việc chuyển luồng là một thay đổi có kiểm thử tương thích riêng, không sửa nóng API một cách phá vỡ test.

Nếu NPC bị xóa hoặc animation lỗi: bộ điều phối vẫn có thể phát sự kiện hoàn tất bữa dựa trên state; tránh thất thoát tiền hoặc kẹt bát. Không xóa vật thể đang giữ khi đóng cửa.

### 4.4 Rửa theo mẻ

Khách ăn xong để lại bát DIRTY; bát dơ được chuyển vào **DirtyRack** (tối đa 4 bát theo giả thuyết đầu tiên). Người chơi tương tác một lần để khởi động batch. Tại thời điểm bắt đầu mẻ, hệ thống chuyển toàn bộ bowl_id hợp lệ từ QUEUED_DIRTY → WASHING → CLEAN_AVAILABLE sau khoảng thời gian thử nghiệm (4–8 giây game, **chưa chốt**), vẫn cho phép nấu trong lúc chờ.

Không có mini-game cho từng bát; không auto tạo order khi rửa xong. Đóng ngày giải quyết bát tồn theo quy tắc dọn sau ca, ghi rõ trạng thái; không mất tiền, không xóa đơn. Mẻ đang rửa ngừng tiến triển khi game pause. Khởi động lần hai khi đang chạy không nhân đôi bát sạch.

### 4.5 Áp lực dễ chịu và phản hồi

- D1 theo kịch bản 10–14 bát/ngày của GDD là **mục tiêu cân bằng giai đoạn sau**, **không ép người mới phải bán đủ 10 bát**. Trước tiên kiểm tra trải nghiệm 3 đơn hướng dẫn, rồi run 10, 15, 20 đơn.
- Mở đầu cho người chơi nhận một đơn, sau đó tối đa 2 đơn song song; đợt cao điểm chỉ mở khi người chơi đã phục vụ thành công. Khách phản ứng bằng lời, nét mặt và hành động, không hiện thanh đếm ngược đỏ mặc định.
- Mỗi lúc không quá 3 việc cần chú ý cùng nổi trên HUD. Phiếu ưu tiên theo thời gian nhận, song người chơi được tự chọn đơn.
- Điểm vui cần hiện hình: hơi nóng nhấc khỏi bát, mặt phở thay đổi, âm thanh vá chạm nồi, ghế kéo, tiếng khu ngõ; phản hồi phải chạy được với asset tạm nếu asset cuối chưa duyệt.
- Chế độ tiếp cận: điều chỉnh thời gian khách chờ/không phạt chậm, giảm rung và âm lượng tiếng sôi, kích thước chữ, hiển thị thao tác bằng chữ, tạm dừng khi đọc sổ; bàn phím + chuột vẫn dùng một hành động chính.

### 4.6 Lời thoại và tiến triển đời thường

Mốc ngày đầu: ông Lâm hướng dẫn; ông Năm ghé mua một bát hoặc bình luận; cô Hường quan sát cảnh buổi sáng. Một NPC chỉ có 1–2 đoạn thoại ngắn có điều kiện (lần đầu phục vụ / lần phục vụ sai đã sửa / chốt ngày). Đối thoại có nút bỏ qua và không chặn ca. Không phát thưởng tiền/cứu nợ ngoài Ledger. Không làm toàn bộ tuyến truyện 10 tháng trong slice.

### 4.7 Kết ca, tài chính và tồn kho

Đề xuất trạng thái ngày: PRE_OPEN → OPEN → CLOSING → CLOSED. CLOSING chặn khách mới, cho xử lý các đơn đang phục vụ hoặc lựa chọn **đóng sớm có xác nhận** với thống kê đơn chưa phục vụ. Bảng cuối ngày dùng độc nhất DayController / Ledger / Inventory; bao gồm số bát đã bán, tổng doanh thu, hàng bị hủy, tồn, tiền đầu và cuối, giao dịch, lý do sai khác nếu có. Tổng thực thu = tổng sale:<order_id> duy nhất; thu khi thanh toán, không cộng lúc giao thêm lần nữa. Mọi thanh toán phải ghi trước khi chốt Ledger hoặc được xử lý chính xác theo quy tắc đóng sớm.

Giá 40.000 đ bát cơ bản, 45.000 đ thêm thịt trong GDD là **định hướng chưa phê duyệt**; hiện prototype dùng 45.000 đ cho mọi lần giao. Dự án đang có cuộc duyệt kinh tế DUC-49: **không âm thầm thay số liệu, không giả định có tip/khoản chi**. Không nạp campaign save/loan/thuê nhà vào slice khi chưa định nghĩa sự kiện giao dịch, thời gian chơi và dữ liệu lưu.

## 5. Hợp đồng kỹ thuật dự kiến (chưa phải API hiện có)

Phần này là **giao diện dự kiến để triển khai**, không được nói là đang tồn tại.

| Thành phần | Trách nhiệm duy nhất | Giao diện/biến cố đề xuất |
| --- | --- | --- |
| CustomerDirector (Node) | Lịch khách, cột mốc tutorial, giới hạn khách/bàn | configure(seed, scenarios), start_shift(), stop_arrivals(); signal customer_arrived(customer_id), customer_left(customer_id) |
| TableService (Node) | Quyền chiếm bàn, zone giao, xác định bàn hợp lệ | reserve_table(customer_id) → Dictionary; can_deliver(table_id, order_id) → bool; release_table(table_id) |
| OrderManager (mở rộng) | Đơn theo nhiều bàn, bất biến ID | create_order hiện tại giữ tương thích; bổ sung payment state/set_paid(order_id) và order_changed |
| CookingCoordinator (Node) | Kết nối thao tác nấu với order_id/bowl_id, không giữ tiền | bind_bowl_to_order(bowl_id, order_id) → Dictionary; can_finish_bowl |
| TrayController (Node) | 2 slot bát có chủ sở hữu | try_insert(bowl_id, slot) → Dictionary; try_remove(slot) → Dictionary |
| MealService (Node) | Ăn và kích hoạt thanh toán sau ăn | start_meal(order_id, customer_id) → Dictionary; signal meal_finished(order_id) |
| ServingService (mở rộng) | Kiểm tra giao, thanh toán duy nhất, tránh replay | serve_order legacy giữ test; chế độ mới deliver_order(...), settle_order(order_id, amount) |
| WashBatchService (Node) | DirtyRack và mẻ rửa | enqueue(bowl_id) → Dictionary; start_batch() → Dictionary; signal batch_finished(bowl_ids) |
| ShiftCoordinator (Node) | Cảnh một ngày, mở/đóng, orchestration | open_shift(day_id), begin_close(), finish_close() |
| GameplayHUD (Control) | Hiển thị state có sẵn, không sửa game state | Bắt các signal order_changed, stock_changed, day_closed |
| GameplayTelemetry (Node hoặc logger file cục bộ) | Ghi sự kiện playtest có opt-in | record(event_name, payload); không chứa thông tin cá nhân |

**Không lập singleton toàn cục cho mọi thứ.** Các Node domain nối signal tại Main/ShiftCoordinator. Godot 4.4 hỗ trợ signal tự định nghĩa và connect để giảm phụ thuộc giữa scene: https://docs.godotengine.org/en/4.4/tutorials/scripting/instancing_with_signals.html và https://docs.godotengine.org/en/4.4/tutorials/best_practices/scene_organization.html. Tương tác 3D dùng RayCast3D.force_raycast_update và Area3D có collision layer/mask tường minh; danh sách overlap chỉ cập nhật theo physics tick: https://docs.godotengine.org/en/4.4/classes/class_raycast3d.html và https://docs.godotengine.org/en/4.4/classes/class_area3d.html.

### Bất biến kiểm thử bắt buộc

1. Mỗi order_id tạo tối đa **một** sale:<order_id>; thử gọi giao/thanh toán nhiều lần không tăng số giao dịch.
2. Bát chỉ ở một chỗ/slot/bàn/trên tay tại một thời điểm; không nhân bản khi di chuyển, đổi scene hoặc spam tương tác.
3. Thao tác sai/thiếu hàng/không đúng phiên bản nguyên liệu **không trừ tồn**; hủy dở ghi hao hụt đúng lượng đã dùng và chỉ một lần.
4. Bàn sai hoặc công thức sai không SERVED, không thanh toán; NPC/âm thanh lỗi không làm sai domain.
5. Khay tối đa hai bát, rack tối đa bốn; lỗi đầy phải dễ hiểu và không mất bát.
6. Rửa mẻ không thể đổi READY_TO_SERVE → CLEAN; chỉ DIRTY mới được enqueue.
7. Khi paused, customer/meal/washing clock dừng; HUD và menu vẫn có thể mở.
8. Đóng ngày lặp lại giữ nguyên Ledger và tồn; không sinh thêm đơn sau CLOSING.
9. Giá/chi phí tạm tính có nhãn; kiểm tra sổ theo giao dịch gốc, không lấy dữ liệu hiển thị làm sổ thật.

## 6. Kịch bản khả dụng và nghiệm thu

**Bài kiểm tra ngắn:** Bát tái #1 phục vụ table-1; phở chín #2 table-2; bát tái #3 table-3. Người chơi có thể đổi thứ tự #2/#3, bưng tối đa 2 bát trên khay, gặp sai bàn và tự sửa; khách ăn, thanh toán đúng một lần; thu ba bát bẩn, chạy một mẻ rửa, chốt ngày. Có nhắc hướng dẫn nhưng không cần developer console.

**Điều kiện kiểm chứng máy:** test cho customer/table occupancy, transition order/payment, tray, wash, replay Ledger, pause/close, thiếu nguyên liệu, game import. Chạy test SceneTree trong Godot 4.4.1 (ví dụ --headless --path game --script res://tests/test_....gd); kiểm tra export sau khi có thay đổi.

**Điều kiện kiểm chứng bằng người:** ít nhất một đoạn chơi 10 bát và một đoạn 15/20 bát, video/ảnh thấy đúng góc nhìn thực, câu hỏi đánh giá cảm giác nấu và mong muốn tiếp tục; không tự tuyên bố “cuốn hút” nếu chưa có người chơi thử. Dẫn chứng và bảng đo ở tài liệu playtest.

## 7. Khác biệt GDD ↔ bản game ↔ lựa chọn cần duyệt

| Chủ đề | GDD v1.2 | Mã hiện tại | Đề xuất / quyết định chủ dự án |
| --- | --- | --- | --- |
| Cảm giác nấu | Trụng riêng, thịt đúng trạng thái, chan nước; 15–20s mục tiêu | 3 lượt nhấn trạm, chưa có tương tác có thời lượng | Thêm hiệu ứng/động tác cô đọng; thời lượng thử nghiệm, không ép minigame |
| Món ăn | Cơ bản 40k, thêm thịt 45k, nhiều biến thể về sau | Hai công thức tái/chín, mọi đơn 45k | Tách **kiểu thịt** khỏi **phân hạng giá** khi được duyệt DUC-49; chưa tự thêm món |
| Số bàn | Nhiều bàn/khách | Một table-1 cho mọi đơn | Ba bàn ID ổn định, phiếu theo bàn |
| Khay | Bắt đầu 2 bát | Một bát trên tay | Khay 2 bát |
| Thanh toán | Sau khách ăn | Ngay khi giao | Chuyển có migration/test sang sau ăn |
| Rửa | Theo mẻ, chạy nền; không mini-game từng bát | Rửa trực tiếp từng bát; rửa sinh đơn kế | Rack + wash batch; sinh đơn độc lập |
| Áp lực | Không đồng hồ đỏ; khách giảm thiện cảm mềm | Không NPC, không nhịp khách | Kịch bản trước, tăng dần sau đo |
| Một ngày | 15–25 phút thường; 10/15/20 bát để đo | Chốt ngày C, không game-day đầy đủ | Đo thật trước khi cố định |
| Story/save/debt | 100 ngày; nợ 18 triệu | Chưa có | Hoãn đến sau slice |

## 8. Gate và quyết định mở

**Gate G0 — kiểm tra M7 hiện tại:** đóng checklist 10 vòng, soát HUD/độ nhìn/va chạm, export/CI, ghi playtest. Không nhập kết quả cũ làm kết quả mới.

**Gate G1 — duyệt thiết kế:** chủ dự án đã chọn B và duyệt 5 điểm: ba bàn/một bát mỗi phiếu; khay hai bát; thanh toán sau ăn; rửa mẻ; khách chờ mềm (2026-10-28).

**Gate G2 — duyệt kế hoạch triển khai:** chủ dự án đã duyệt kế hoạch 8 giai đoạn (2026-10-28). Cần hoàn tất G0 baseline M7 trước production code; gate art G3/G5 vẫn độc lập.

**Gate G3 — chất lượng playable:** bài kiểm thử tự động đạt và người thật hoàn thành, phát hiện sai lệch Ledger = 0, lỗi kẹt tiến trình = 0 trong phiên test, owner xem video/góc nhìn trước khi mở rộng. **Không lẫn gate này với G3/G5 art hiện hành.**

Quyết định đã chốt: chọn **B** và **3 đơn tutorial → 10 bát → thử 15/20 bát**; giữ nguyên lịch tài chính 100 ngày và tạm hoãn các quy tắc giá chưa phê duyệt.
