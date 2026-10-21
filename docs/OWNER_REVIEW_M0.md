# M0 Owner Review — PHỞ ĐẦU NGÕ

**Mục đích:** Xin duyệt baseline sản phẩm để các bước kỹ thuật tiếp theo không phải dựa trên suy đoán. Đây không phải phê duyệt bắt đầu code.

## 1. Phạm vi đề nghị duyệt làm baseline

- Game mô phỏng quán phở Việt Nam quy mô nhỏ tại ngõ/khu tập thể cũ ở Hà Nội.
- Góc nhìn thứ nhất, 3D, mục tiêu PC/Steam.
- Vòng chơi dọc: chuẩn bị → nhận đơn → nấu/lắp bát → bưng đúng bàn → thanh toán đúng một lần → thu bát bẩn/rửa theo mẻ → chốt sổ ngày.
- Trọng tâm là thao tác thủ công có hỗ trợ, hạch toán nhất quán và câu chuyện Minh gây dựng lại cuộc sống.
- Một tháng game = 10 ngày chơi; chiến dịch 100 ngày.
- Nợ gốc 18.000.000đ; trả 2.000.000đ cuối tháng chơi 2–10; không cộng lãi tự động. Lịch này đã được chủ dự án xác nhận ngày 21/10/2026.
- Nhân viên bưng bê không nằm trong vertical slice đầu tiên.

## 2. Quyết định kinh tế đã được chủ dự án duyệt tạm thời

- Mục tiêu kiểm thử trung bình 20 bát/ngày từ tháng trả nợ đầu tiên; 17 bát/ngày là kịch bản stress. Đây không phải doanh số được bảo đảm.
- Mở cửa hàng là lựa chọn tự nguyện; chỉ được mở nếu sau khi trả chi phí mở cửa vẫn giữ được quỹ dự phòng 1.500.000đ.
- Ma trận lãi góp cơ sở / giá vốn +10% / giá vốn +20% đã được tính. Mô phỏng dòng tiền theo từng ngày vẫn chưa hoàn tất.

## 3. Những giá trị tiếp tục là giả định, không khóa vào code

- Giá bán 40.000đ/45.000đ và giá vốn 25.500đ/28.500đ mỗi bát.
- Tiền phòng 500.000đ/tháng chơi; điện nước/vệ sinh/bảo trì 50.000đ/tháng chơi.
- Tiền thuê cửa hàng khoảng 833.333đ/tháng chơi; chi phí mở cửa khoảng 3.666.666đ.
- Thời lượng ngày bình thường 15–25 phút; ngày sự kiện 20–30 phút.
- Đường cong khách 10–14 bát/ngày lúc học chơi, 14–20 khi ổn định, 18–25 khi phát triển.
- Tồn kho ban đầu trị giá 300.000đ nhưng thành phần nguyên liệu cụ thể và thời điểm nhập bổ sung chưa xác định.

Những số này cần được kiểm thử bằng mô hình kinh tế và bản mẫu. Không được ép lượng khách để bảo đảm trả nợ, không được tự động thay lịch nợ nếu mô hình thất bại.

## 4. Đề nghị giữ mở trước khi triển khai

1. Thành phần tồn kho ban đầu, lượng bán an toàn ngày đầu và thời điểm đặt/nhận đơn nhà cung cấp.
2. Thứ tự giao dịch cuối tháng giữa tiền phòng, điện nước/bảo trì và trả nợ; cảnh báo khi tiền mặt không đủ.
3. Kịch bản dòng tiền theo từng ngày có nhập hàng, hao hụt, mua gấp và số dư tiền mặt.
4. Engine và kiến trúc tương tác/lưu game.

## 5. Cổng kỹ thuật tiếp theo

Khuyến nghị đánh giá Godot 4 trước như ứng viên spike nhỏ, nhưng chưa chọn engine. Đánh giá sơ bộ và tiêu chí spike được ghi trong [TECHNICAL_DIRECTION_REVIEW_M0.md](TECHNICAL_DIRECTION_REVIEW_M0.md). Chỉ chạy spike sau khi chủ dự án duyệt câu hỏi và tiêu chí nghiệm thu; sau đó mới viết kế hoạch triển khai theo file và xin duyệt kế hoạch.

## 6. Quyết định cần chủ dự án đưa ra

**Đề nghị:** duyệt GDD v1.2 làm *working baseline* cho phạm vi, vòng chơi, bối cảnh/cốt truyện và lịch chiến dịch; giữ mọi con số ở mục 3 dưới nhãn giả định để tiếp tục kiểm thử, không coi chúng là thông số khóa. Engine và code vẫn chưa được duyệt.

Trạng thái hiện tại: **chờ chủ dự án xác nhận hoặc yêu cầu sửa baseline**.
