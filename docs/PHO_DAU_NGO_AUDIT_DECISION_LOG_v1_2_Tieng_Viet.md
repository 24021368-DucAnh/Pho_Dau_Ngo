# PHỞ ĐẦU NGÕ — BÁO CÁO KIỂM TRA VÀ NHẬT KÝ QUYẾT ĐỊNH

**Phiên bản:** 1.2  
**Ngày:** 21/10/2026  
**Trạng thái:** Bản hợp nhất chờ chủ dự án duyệt; chưa phải phê duyệt triển khai.

## 1. Kết luận điều hành

Bản 1.2 cập nhật ba quyết định quan trọng: (1) một tháng trong game bằng 10 ngày chơi; (2) Minh trả đủ 18 triệu đồng tiền gốc trong 10 tháng chơi, với tháng 1 ân hạn và tháng 2–10 trả 2 triệu đồng vào cuối mỗi tháng; (3) biến cố đầu tháng 2 giải thích hợp lý vì sao ông Năm can thiệp và vì sao ông Lâm đã tin tưởng cho Minh mượn xe, truyền nghề từ trước đó.

Bản GDD này là tài liệu hợp nhất được tạo trong phiên làm việc hiện tại. Kho GitHub `codenobug09/pho-dau-ngo` đã được xác minh là tồn tại nhưng tài khoản kết nối chỉ có quyền đọc, không có quyền đẩy thay đổi. Vì vậy, tài liệu chưa được ghi trực tiếp vào kho GitHub. Các tệp Markdown được cung cấp riêng để chủ dự án xem xét và đưa vào kho sau khi duyệt.

## 2. Những quyết định đã chốt

| Mục | Quyết định hiện hành | Hệ quả cần phản ánh |
|---|---|---|
| Lịch game | 1 tháng = 10 ngày chơi; tổng chiến dịch nợ 10 tháng = 100 ngày chơi | Tiền thuê và chi phí định kỳ phải dùng cùng đơn vị tháng chơi 10 ngày. Thứ trong tuần chạy liên tục. |
| Khoản nợ | Nợ gốc 18.000.000 đồng | Con số 36 triệu chỉ là khoản bị ép buộc trước dàn xếp, không phải dư nợ thực tế sau dàn xếp. |
| Lịch trả nợ | Tháng 1 ân hạn; tháng 2–10 trả 2.000.000 đồng vào cuối mỗi tháng chơi | 9 lần × 2 triệu = 18 triệu; lần đầu cuối ngày 20, lần cuối cuối ngày 100. Không cộng lãi. |
| Biến cố | Giang hồ phá quán vào đầu tháng 2; ông Năm can thiệp | Cần thể hiện thiệt hại nhìn thấy được nhưng không làm mất tiến trình chơi vĩnh viễn. |
| Ông Năm | Hàng xóm bán trà, từng có vị thế trong giới giang hồ và đã rời bỏ cuộc sống đó | Giúp bằng uy tín, lời chứng của hàng xóm và buộc thương lượng lại khoản nợ; không trả nợ thay Minh, không cứu liên tục. |
| Ông Lâm | Truyền nghề sau khi Minh chứng minh sự kiên trì và trung thực trong việc phụ quán | Không có sự kiện “gặp ngẫu nhiên rồi được cho xe” mà thiếu nguyên nhân. Xe và dụng cụ là tài sản cho mượn. |
| Minh | Từng sa vào cờ bạc, phải chịu trách nhiệm cho lựa chọn của mình | Việc bị hành hung là bất công nhưng không xóa nghĩa vụ trả khoản nợ gốc. |
| Cô Hường | Người bán ô mai có khó khăn riêng; có thể chuyển đi/đóng cửa | Không viết thành phản diện hoặc chỉ là công cụ mở khóa cửa hàng cho Minh. |
| Vòng chơi | Người chơi trực tiếp nấu, bưng đúng bàn, thanh toán đúng một lần, thu bát và rửa theo mẻ | Không tự động hóa phần việc cốt lõi. |
| Kinh tế | Giá món 40.000/45.000; giá vốn 25.500/28.500; lãi góp bình quân 15.100 đồng/bát theo tỷ trọng 70/30 | Các số là giả định thiết kế, phải kiểm thử bằng bản mẫu. |
| Vốn ban đầu | 2.000.000 đồng tiền mặt + 300.000 đồng hàng tồn | Không phải tiền gia đình hay ông Năm cho. |
| Nhà cung cấp | Ba nhóm; báo giá qua tin nhắn; xác nhận khóa giá; giao ngày hôm sau | Giữ giao diện đơn giản, không làm thành sàn mua sắm. |
| Tồn kho | Theo dõi lô, hạn dùng, giá vốn, hao hụt và mẻ nước dùng | Không thay đổi giá vốn của lô cũ khi giá thị trường đổi; không tính trùng chi phí. |

## 3. Quy đổi thời gian và kinh tế

### 3.1 Mâu thuẫn cũ

Các tài liệu cũ dùng lẫn ba quy ước: tháng chơi 7 ngày, tháng chơi 10 ngày và tháng chơi 30 ngày. GDD trước đó dùng chu kỳ tài chính 10 ngày nhưng lại định nghĩa một tháng là 30 ngày, khiến lịch trả nợ và tiền thuê không đồng bộ. Quy ước mới là một tháng chơi = 10 ngày chơi; vì vậy toàn bộ các khoản định kỳ phải được chuẩn hóa lại.

### 3.2 Cách quy đổi dùng trong GDD 1.2

Để không làm tăng gấp ba chi phí theo ngày chơi chỉ vì rút tháng chơi từ 30 ngày xuống 10 ngày, GDD 1.2 **quy đổi tỷ lệ** các giả định tiền thuê trước đây:

| Hạng mục | Mô hình cũ theo 30 ngày chơi | Mô hình mới theo 10 ngày chơi | Ghi chú |
|---|---:|---:|---|
| Tiền phòng | 1.500.000 đồng/30 ngày | 500.000 đồng/tháng chơi | Giữ nguyên mức 50.000 đồng/ngày chơi trong mô hình. |
| Điện nước/bảo trì | 150.000 đồng/30 ngày | 50.000 đồng/tháng chơi | Giữ nguyên mức 5.000 đồng/ngày chơi. |
| Tiền thuê cửa hàng | 2.500.000 đồng/30 ngày | Khoảng 833.333 đồng/tháng chơi | Giả định thiết kế, không phải giá thuê thị trường đã xác minh. |
| Chi phí mở cửa hàng | 7.000.000 đồng | Khoảng 3.666.666 đồng | 833.333 đặt cọc + 833.333 thuê trước + 2 triệu sửa chữa/dụng cụ. |

Đây là quy đổi cân bằng trò chơi, không khẳng định rằng tiền thuê ngoài đời chỉ có giá trị đó. Nếu chủ dự án muốn mỗi tháng chơi 10 ngày phải chịu nguyên tiền thuê danh nghĩa 1,5 triệu/2,5 triệu, cần duyệt lại toàn bộ đường cong kinh tế vì điểm hòa vốn sẽ tăng mạnh.

### 3.3 Điểm hòa vốn sau khi chốt trả nợ

Lãi góp bình quân giả định: 15.100 đồng/bát. Một tháng chơi có 10 ngày.

| Kịch bản | Chi phí cố định/tháng chơi | Trả nợ/tháng chơi | Điểm hòa vốn ước tính |
|---|---:|---:|---:|
| Xe phở, tháng ân hạn | 550.000 | 0 | 4 bát/ngày |
| Xe phở, tháng trả nợ | 550.000 | 2.000.000 | 17 bát/ngày |
| Cửa hàng và vẫn thuê phòng | 1.383.333 | 2.000.000 | 23 bát/ngày |
| Cửa hàng, không còn thuê phòng riêng | 883.333 | 2.000.000 | 20 bát/ngày |

Đây là điểm hòa vốn theo lãi góp, chưa bao gồm đầy đủ thay đổi tồn kho, tiền mua hàng, hao hụt, tiền công và các sự kiện bất lợi. Nếu người chơi không thể đạt khoảng 17 bát/ngày sau khi bắt đầu trả nợ, cần kiểm thử tiền dự phòng tháng đầu và điều chỉnh các tham số cân bằng khác trước khi sửa lịch nợ đã chốt.

### 3.4 Kiểm tra giá vốn tăng

| Kịch bản | Lãi góp/bát | Hòa vốn xe phở có trả nợ | Hòa vốn cửa hàng, vẫn thuê phòng |
|---|---:|---:|---:|
| Cơ sở | 15.100 | 17 bát/ngày | 23 bát/ngày |
| Giá vốn tăng 10% | 12.460 | 21 bát/ngày | 28 bát/ngày |
| Giá vốn tăng 20% | 9.820 | 26 bát/ngày | 35 bát/ngày |

Biến động lớn phải hiếm, chỉ tác động đến nguyên liệu liên quan và phải cho người chơi đủ lựa chọn để phản ứng. Không được dùng sự kiện giá tăng để tạo phá sản tất yếu.

## 4. Những điểm đã sửa trong cốt truyện

1. Minh bị hành hung khi nhóm đòi nợ ép cậu chấp nhận 36 triệu đồng; sau khi chạy thoát, ông Năm giúp sơ cứu và tiếp cận hỗ trợ y tế. Cách này khiến lần gặp đầu tiên có nguyên nhân tự nhiên.
2. Minh chủ động quay lại cảm ơn ông Năm và gặp ông Lâm tại xe phở cũ. Ông Lâm chỉ cho Minh phụ việc trước, rồi mới truyền nghề sau khi cậu chứng minh sự kiên trì và trung thực.
3. Xe phở được cho mượn theo thỏa thuận có điều kiện, không phải quà tặng vô lý. Minh tự mua nguyên liệu bằng khoản tiền ít ỏi còn lại và tự vận hành.
4. Tháng 1 tạo được nhóm khách quen và hiểu vòng chơi. Đầu tháng 2, giang hồ phá quán; ông Năm can thiệp bằng uy tín cũ và sự chứng kiến của hàng xóm, chốt khoản nợ ở 18 triệu tiền gốc.
5. Tháng 2–10 có chín khoản trả 2 triệu đồng. Ông Năm không trả tiền thay, không cứu liên tục; ông Lâm không trở thành nhà tài trợ toàn năng.
6. Cô Hường được viết như một người có sinh kế riêng, không phải nhân vật phản diện. Việc thuê lại mặt bằng là lựa chọn có rủi ro tài chính.
7. Tháng 9 có thử thách về cơ hội kiếm tiền nhanh để kiểm tra sự thay đổi của Minh; tháng 10 kết thúc bằng việc trả xong nợ và đạt sự tự chủ, không phải giàu lên đột ngột.

## 5. Các mâu thuẫn cũ đã bị thay thế

| Nội dung cũ | Trạng thái hiện tại |
|---|---|
| Một tháng = 30 ngày chơi | Đã thay bằng 10 ngày chơi. |
| Hai chu kỳ ân hạn rồi trả 900.000 đồng × 20 lần | Đã thay bằng tháng 1 ân hạn, tháng 2–10 trả 2.000.000 đồng/tháng. |
| Trả xong ngày 220 | Đã thay bằng cuối ngày chơi thứ 100. |
| Tiền phòng 1,5 triệu/30 ngày, tiền thuê cửa hàng 2,5 triệu/30 ngày | Được quy đổi tỷ lệ cho tháng chơi 10 ngày trong GDD 1.2; đây là giả định cân bằng, cần chủ dự án xác nhận. |
| Mở cửa hàng cần 7 triệu | Được quy đổi thành khoảng 3,67 triệu tiền mở cửa + ít nhất 1,5 triệu quỹ dự phòng. |
| Cốt truyện chỉ nói Minh bị đánh rồi sau đó có xe phở | Đã thêm bước được ông Năm giúp sơ cứu, Minh quay lại cảm ơn, phụ việc và chứng minh sự trung thực trước khi ông Lâm cho mượn xe/dạy nghề. |

## 6. Rủi ro và phần cần kiểm chứng

### Ưu tiên cao — trước khi triển khai

1. **Dòng tiền và mức trả nợ:** 2 triệu đồng mỗi tháng chơi là khoản lớn so với lãi góp. Bản mẫu phải chứng minh người chơi có thể đi từ tháng 1 sang tháng 2 với quỹ tiền mặt đủ an toàn và đạt khoảng 17 bát/ngày trong giai đoạn trả nợ.
2. **Chi phí mở cửa hàng:** kiểm thử kịch bản 15/18/20/23/25 bát/ngày, giá vốn tăng 10%, ngày mưa và mẻ nước dùng hỏng. Không mở khóa thuê nếu người chơi không có quỹ dự phòng.
3. **Thời lượng ngày:** thử 10, 15 và 20 bát/ngày, đo thời gian nấu, di chuyển, phục vụ và dọn dẹp. Khoảng 15–25 phút/ngày vẫn là mục tiêu thử nghiệm.
4. **Hạch toán:** kiểm thử tiền mặt, tồn kho theo lô, giá vốn, hao hụt, tiền thuê trả trước, đặt cọc, trả nợ và doanh thu cuối ngày để tránh tính trùng.
5. **Tổn thất khi bị phá quán:** sự kiện phải tạo cảm xúc và hậu quả có thể thấy, nhưng không làm mất tài sản hoặc nguyên liệu đến mức khiến người chơi không thể tiếp tục chiến dịch.
6. **Ông Năm và yếu tố giang hồ:** không mô tả chiến thuật tội phạm hoặc tô hồng bạo lực; trọng tâm là chấm dứt ép buộc và giúp Minh có thỏa thuận trả nợ rõ ràng.

### Ưu tiên tiếp theo — trong bản mẫu

7. Nhân viên bưng bê vẫn là đề xuất chưa được chốt. Chưa đưa vào bản mẫu đầu tiên.
8. Công cụ phát triển, kiến trúc tương tác, hệ thống lưu và yêu cầu cấu hình chưa được quyết định.
9. Các con số khẩu phần, giá vốn, giá thuê, nhu cầu khách và độ dài ngày cần được xác minh bằng bản mẫu và nghiên cứu thực tế.
10. Quy tắc an toàn thực phẩm phải được kiểm tra với nguồn chuyên môn đáng tin cậy trước khi đưa tuyên bố định lượng vào trò chơi.

## 7. Cổng nghiệm thu cho bản mẫu lát cắt dọc

- **Cổng 1 — Vòng phục vụ:** nhận đơn, nấu, bưng đúng bàn, thanh toán đúng một lần, thu bát và đóng ngày không mắc kẹt trạng thái.
- **Cổng 2 — Thao tác:** nấu thủ công có ý nghĩa nhưng không rườm rà; đo thời gian thay vì mặc định thời lượng là đúng.
- **Cổng 3 — Hạch toán:** tiền mặt, tồn kho, giá vốn, hao hụt, tiền thuê, trả nợ và đặt cọc đối soát được.
- **Cổng 4 — Lịch:** một tháng đúng 10 ngày; trả nợ 2 triệu cuối tháng 2–10; tổng đúng 18 triệu và không có lãi sau dàn xếp.
- **Cổng 5 — Khả năng phục hồi:** một ngày bán kém hoặc một mẻ hỏng không dẫn đến chuỗi phá sản tất yếu.
- **Cổng 6 — Phạm vi:** bản mẫu chạy được mà chưa cần nhân viên, mở rộng cửa hàng, sự kiện phức tạp hoặc đồ họa hoàn thiện.

## 8. Bước tiếp theo theo quy trình Superpowers

Bản GDD 1.2 và nhật ký quyết định 1.2 cần được chủ dự án đọc và duyệt trước. Sau khi chủ dự án xác nhận đặc tả bằng văn bản, bước kế tiếp là lập kế hoạch triển khai riêng cho **bản mẫu lát cắt dọc**, theo các hệ thống nhỏ, có giao diện rõ ràng và kiểm thử được. Chưa bắt đầu viết mã sản phẩm hoặc tạo tài sản đồ họa trước cổng duyệt này.

## 9. Giới hạn nguồn và bằng chứng

- Bảng tính cũ `pho_calendar_10_vs_14_economy_v09.xlsx` dùng tham số cũ (giá bán 47.000 đồng, vốn ban đầu 800.000 đồng, tiền thuê 3,2 triệu/tháng và lịch trả nợ khác). Chỉ giữ làm tư liệu lịch sử, không dùng làm nguồn chuẩn cho GDD 1.2.
- Mức giá món, giá vốn, tiền thuê đã quy đổi, lượng khách, tiền công và độ dài ngày là giả định thiết kế, chưa phải kết quả đo trong trò chơi.
- Kho GitHub đã được kiểm tra tồn tại; kết nối hiện tại có quyền đọc nhưng không có quyền đẩy thay đổi. Hai tài liệu mới vì vậy được tạo thành tệp Markdown riêng, chưa được ghi vào kho dự án.