# PHỞ ĐẦU NGÕ — TÀI LIỆU THIẾT KẾ TRÒ CHƠI

**Phiên bản:** 1.2 — bản hợp nhất sau khi chốt cốt truyện và lịch 10 ngày/tháng  
**Ngày:** 21/10/2026  
**Trạng thái:** Bản đặc tả hợp nhất để chủ dự án duyệt; **chưa được duyệt để triển khai**.  
**Phạm vi:** Máy tính cá nhân/Steam, chơi đơn, góc nhìn thứ nhất, đồ họa 3D, mô phỏng quán phở Việt Nam.

> Tài liệu này hợp nhất các quyết định đã thống nhất trong trao đổi và nghiên cứu thiết kế hiện có. Phiên bản 1.2 cập nhật cốt truyện mở đầu, lịch trả nợ 10 tháng và quy đổi các khoản định kỳ theo quy ước một tháng trong game bằng 10 ngày chơi. Tài liệu chưa được ghi đè vào kho mã nguồn của dự án: trong không gian làm việc có thể truy cập, chưa tìm thấy bản tài liệu thiết kế trò chơi gốc (GDD) có quyền chỉnh sửa. Những con số được ghi là **mục tiêu thử nghiệm** hoặc **giả định thiết kế** phải được kiểm chứng bằng một bản mẫu có thể chơi.

## 1. Định nghĩa trò chơi

**PHỞ ĐẦU NGÕ** là trò chơi mô phỏng quán phở Việt Nam quy mô nhỏ, góc nhìn thứ nhất, đặt tại một ngã ba hình chữ T trong khu tập thể cũ ở Hà Nội. Người chơi trực tiếp làm từng bát phở, phục vụ hàng xóm, quản lý nguyên liệu và tiền mặt, đồng thời từng bước gây dựng lại cuộc sống của Minh thông qua câu chuyện đời thường trong khu phố.

### Năm trụ cột thiết kế

1. **Tự tay bán phở:** người chơi trực tiếp nấu và bưng bát; không tự động hóa mất phần việc cốt lõi.
2. **Ngõ Hà Nội có sức sống:** hàng xóm quen mặt, học sinh qua lại, thời tiết và những nếp sinh hoạt nhỏ; không biến khu phố thành thế giới mở rộng lớn.
3. **Bận rộn vừa đủ, không trừng phạt:** giờ đông khách tạo ra lựa chọn và áp lực, nhưng một ngày bán kém không được kéo theo chuỗi thất bại không thể cứu vãn.
4. **Tiền bạc có ý nghĩa:** tồn kho, tiền mặt, giá vốn, hao hụt, tiền thuê, nợ và tiền đặt cọc phải được hạch toán nhất quán, không tính trùng.
5. **Câu chuyện làm lại cuộc đời ở quy mô con người:** Minh phải tự lao động trả nợ; hàng xóm có thể giúp đỡ nhưng không giải quyết mọi vấn đề thay cậu.

### Những nội dung không thuộc bản phát hành đầu tiên

- Khám phá thế giới mở hoặc vòng lặp đi ngủ/di chuyển sang nơi khác.
- Chiến đấu, bạo lực lặp lại hoặc mô phỏng hoạt động tội phạm.
- Tự động hoàn toàn việc nấu, phục vụ, mua hàng hay quản lý nhà hàng.
- Trò chơi rửa từng chiếc bát riêng biệt.
- Hàng chục nhà cung cấp, nhiều vị trí nhân viên hoặc màn hình quản lý phức tạp trước khi vòng chơi cốt lõi được chứng minh là thú vị.

## 2. Bối cảnh và cốt truyện đã thống nhất

### 2.1 Tiền đề

Minh, 24 tuổi, từng có công việc giao hàng và một cuộc sống tương đối bình thường. Sau một thời gian sa vào cờ bạc, Minh liên tục vay tiền với hy vọng gỡ lại những khoản đã mất. Càng thua, cậu càng vay thêm; càng vay thêm, cậu càng giấu gia đình và nói dối những người muốn giúp mình. Khi gia đình biết chuyện, bố mẹ không còn đồng ý trả nợ thay. Họ vẫn thương Minh, nhưng đã nhiều lần cứu cậu và không muốn tiếp tục biến việc trả nợ thành cách giúp Minh trốn tránh hậu quả.

Minh mang khoản nợ gốc 18.000.000 đồng. Sau khi bán chiếc xe máy để xoay xở, cậu vẫn không đủ tiền trả nợ. Một tối, nhóm đòi nợ chặn Minh ở con ngõ gần khu tập thể cũ, ép cậu chấp nhận khoản phải trả đã bị đẩy lên 36.000.000 đồng do lãi và phí chồng chất. Minh không có tiền và cũng không còn ai để gọi. Cậu bị đánh, điện thoại rơi vỡ, người đầy thương tích; sau khi chạy thoát, cậu ngã xuống gần một hàng trà đang chuẩn bị dọn hàng buổi sớm.

### 2.2 Gặp ông Năm và ông Lâm

Người đầu tiên nhìn thấy Minh là ông Năm, khoảng 70 tuổi, người sống lâu năm trong khu tập thể. Ông không hỏi dồn và không hứa sẽ giải quyết món nợ. Ông đưa Minh vào chỗ an toàn, gọi người hỗ trợ sơ cứu và giúp cậu đến cơ sở y tế. Khi Minh hỏi vì sao ông giúp một người xa lạ, ông chỉ nói: “Người ta có thể làm mày ngã một lần. Còn nằm mãi dưới đất hay đứng dậy, cái đấy mày phải tự quyết.”

Vài ngày sau, Minh quay lại cảm ơn ông Năm. Tại đó, cậu gặp ông Lâm — người từng bán phở nhiều năm, nay nghỉ vì sức khỏe không còn cho phép đứng bếp từ sáng sớm. Chiếc xe phở cũ của ông Lâm cần được dọn dẹp, sửa những chỗ đơn giản và chăm sóc. Ông Năm giới thiệu hai người với nhau, nhưng không yêu cầu ông Lâm phải cưu mang Minh.

Minh xin làm phụ việc để kiếm sống. Ông Lâm không lập tức nhận cậu làm học trò. Ông giao những việc nhỏ trước: cọ nồi, nhặt rau, rửa bát, bê đồ, dọn xe và ghi lại lượng nguyên liệu đã dùng. Minh làm chậm, đôi lúc cáu gắt khi bị nhắc, nhưng vẫn quay lại vào sáng hôm sau. Một lần, Minh phát hiện mình ghi thiếu nguyên liệu và có thể khiến ông Lâm tính sai tiền hàng. Cậu chủ động nhận lỗi, sửa sổ và chấp nhận bị trừ tiền công của buổi đó thay vì im lặng.

Với ông Lâm, đây là dấu hiệu đầu tiên cho thấy Minh có thể học cách làm ăn tử tế. Ông bắt đầu dạy cậu chọn thịt, chuẩn bị bánh phở, ninh và nêm nước dùng, chia khẩu phần, giữ vệ sinh, tính giá vốn và ghi sổ. Ông không trao ngay toàn bộ bí quyết; Minh phải tự làm, tự nếm và sửa lỗi qua từng buổi.

### 2.3 Thỏa thuận mượn xe và ngày đầu tiên

Ông Lâm cho Minh mượn xe phở và dụng cụ để bắt đầu bán hàng, nhưng không tặng cậu tiền vốn và không nhận trả nợ thay. Thỏa thuận được nói rõ: xe và dụng cụ vẫn thuộc ông Lâm; Minh tự quản lý tiền hàng, mua nguyên liệu bằng khoản tiền ít ỏi còn lại, ghi sổ trung thực và chịu trách nhiệm về vận hành. Nếu Minh quay lại cờ bạc hoặc dùng tiền hàng sai mục đích, ông Lâm có quyền lấy lại xe.

Minh bắt đầu bán ngay trước cửa hàng ô mai của cô Hường. Không có lễ khai trương hay nhà tài trợ: chỉ có chiếc xe cũ, vài chiếc ghế nhựa đỏ, nồi nước dùng chưa ổn định và một người trẻ đang học cách sống bằng sức lao động của mình. Đây là ngày đầu tiên người chơi điều khiển Minh.

### 2.4 Biến cố đầu tháng 2: giang hồ phá quán

Trong tháng đầu, Minh học được vòng phục vụ cơ bản và bắt đầu có một nhóm khách quen. Ông Lâm vẫn kiểm tra món ăn và sổ sách; ông Năm mở hàng trà bên cạnh, bán trà đá và nhân trần. Minh chưa giàu, nhưng đã có công việc và bắt đầu hiểu tiền hàng phải được giữ riêng với tiền cá nhân.

Đầu tháng thứ hai, nhóm đòi nợ quay lại. Chúng yêu cầu Minh trả 36.000.000 đồng và cho rằng cậu đang cố tình trì hoãn. Minh giải thích rằng mình mới bắt đầu làm ăn nhưng không có khả năng trả ngay số tiền đó. Nhóm đòi nợ đẩy đổ bàn ghế, đá văng ghế nhựa và làm nguyên liệu rơi xuống đất. Minh cố ngăn chúng nhưng bị xô ngã. Đây là biến cố cốt truyện đầu tiên người chơi phải trực tiếp chứng kiến; nó gây thiệt hại có thể nhìn thấy nhưng không được làm mất vĩnh viễn tiến trình chơi.

Ông Năm bước từ hàng trà sang và yêu cầu chúng dừng tay. Khi một tên chế giễu ông già xen vào chuyện người khác, ông Năm gọi đúng tên người đứng đầu. Thái độ của cả nhóm thay đổi. Minh mới nhận ra ông Năm từng là người có vị thế lớn trong giới giang hồ. Những hình xăm lộ ra khi ông cởi lớp áo khoác có thể được dàn dựng hơi cường điệu, tạo sắc thái hài hước kiểu phim, nhưng không được biến thành hướng dẫn phạm tội hay tôn vinh bạo lực.

Ông Năm không đánh thay Minh và không rút tiền trả nợ. Ông buộc cuộc nói chuyện quay lại khoản tiền Minh thực sự vay, nêu rõ rằng nhóm kia không thể lấy việc đe dọa và phá hoại làm cách ép Minh chấp nhận khoản tăng vô lý. Ông cũng nhắc rằng người trong khu tập thể đã chứng kiến việc phá quán và Minh có thể trình báo hành vi đe dọa, hành hung, phá hoại tài sản. Nhờ uy tín cũ và sự chứng kiến của hàng xóm, nhóm đòi nợ chấp nhận dàn xếp: **xóa phần lãi và phí bị ép buộc, chỉ giữ khoản nợ gốc 18.000.000 đồng**.

Ông Năm giúp Minh có một thỏa thuận trả nợ rõ ràng, không trả tiền thay cậu. Minh phải trả 2.000.000 đồng vào cuối mỗi tháng chơi từ tháng 2 đến hết tháng 10 — tổng cộng chín lần, đủ 18.000.000 đồng. Sau dàn xếp, sổ nợ không cộng thêm lãi. Nếu Minh không trả đúng lịch, có thể phát sinh một biến cố gây áp lực hoặc thương lượng lại thời hạn, nhưng số dư nợ không tự động tăng bằng một công thức tùy tiện.

Sau khi nhóm kia rời đi, ông Năm giúp dựng lại ghế và nhặt những thứ còn dùng được. Ông nói với Minh: “Tao giúp mày giữ cái quán. Tao không thể sống thay mày được. Từ giờ, tiền kiếm được là tiền mày làm ra. Nợ của mày thì mày phải trả.” Ông sẽ không liên tục ra mặt cứu Minh nếu cậu quay lại cờ bạc hay dùng lòng tốt của người khác để trốn tránh trách nhiệm.

### 2.5 Tuyến truyện từ tháng 3 đến tháng 10

- **Tháng 1 — Học cách bắt đầu:** Minh làm quen với thao tác nấu, phục vụ và ghi sổ. Mục tiêu câu chuyện là tạo được nhịp bán hàng và khiến người chơi hiểu vì sao ông Lâm chấp nhận truyền nghề.
- **Tháng 2 — Quán bị phá và khoản nợ được chốt:** biến cố giang hồ xảy ra vào đầu tháng. Ông Năm can thiệp, lãi và phí bị ép buộc được loại bỏ. Minh bắt đầu lịch trả 2 triệu đồng/tháng vào cuối tháng.
- **Tháng 3–4 — Tự đứng vững:** Minh phục hồi khách quen, bù đắp thiệt hại, giảm lãng phí và tự quyết định nhiều hơn. Ông Lâm bắt đầu đánh giá Minh bằng sự ổn định và trung thực chứ không bằng lời hứa.
- **Tháng 5–6 — Lựa chọn của cô Hường:** cửa hàng ô mai của cô Hường gặp khó khăn vì các nguyên nhân riêng. Cô có thể chuyển đi hoặc đóng cửa; Minh được quyền cân nhắc thuê lại mặt bằng, nhưng không bắt buộc. Cô Hường được kể như một người đang cố giữ sinh kế, không phải nhân vật phản diện hay vật cản nâng cấp.
- **Tháng 7–8 — Niềm tin của khu phố:** hàng xóm bắt đầu giới thiệu khách mới; Minh có thể hợp tác bán đồ uống với ông Năm theo cách đối soát công bằng. Quán đông hơn cũng làm tăng yêu cầu quản lý. Mở rộng không tự động bảo đảm lợi nhuận.
- **Tháng 9 — Thử thách cũ quay lại:** Minh gặp cơ hội kiếm tiền nhanh gợi nhớ thói quen cờ bạc. Người chơi quyết định có đánh đổi thành quả đã gây dựng hay không. Ông Lâm và ông Năm không quyết định thay Minh.
- **Tháng 10 — Hoàn tất khoản nợ:** nếu người chơi giữ được quán và tuân thủ lịch trả, Minh trả 2 triệu đồng cuối cùng vào cuối tháng 10. Kết thúc nhấn vào sự tự chủ, uy tín và quan hệ với khu phố — không phải giàu lên đột ngột.

### 2.6 Nguyên tắc viết nhân vật

- **Minh** phải chịu trách nhiệm cho việc sa vào cờ bạc và nói dối; việc bị hành hung là bất công nhưng không xóa trách nhiệm trả khoản tiền đã vay. Sự thay đổi phải thể hiện qua hành động hằng ngày.
- **Ông Lâm** là người truyền nghề có giới hạn và nguyên tắc, không phải nhà tài trợ. Ông có thể thất vọng và yêu cầu Minh tự sửa sai.
- **Ông Năm** là hàng xóm từng có vị thế trong giới giang hồ, đã rời bỏ cuộc sống đó. Ông dùng uy tín để chặn sự chèn ép một lần, không trở thành nhân vật giải quyết mọi vấn đề bằng quyền lực.
- **Cô Hường** có hoàn cảnh và lựa chọn riêng; khó khăn của cô không chỉ tồn tại để mở khóa mặt bằng cho Minh.
- Chủ đề xuyên suốt: làm lại cuộc đời không phải xóa sạch sai lầm mà là ngừng trốn tránh và sửa chữa chúng từng ngày.

## 3. Vòng chơi cốt lõi

1. Chuẩn bị xe phở và kiểm tra lượng hàng.
2. Mở bán; khách đến tùy nhu cầu, thời điểm, thời tiết, lịch học, danh tiếng và mức giá phù hợp.
3. Nhận món; bảng gọi món ghi rõ món khách yêu cầu và bàn cần phục vụ.
4. Tự tay làm từng bát bằng bánh phở, nước dùng, thịt, rau và gia vị.
5. Đặt bát hoàn thành lên kệ chờ, sau đó tự bưng đến đúng khách/đúng bàn. Khay ban đầu mang được **hai bát**.
6. Khách ăn và thanh toán; doanh thu được cộng vào tiền mặt ngay khi nhận tiền.
7. Thu bát bẩn và chuyển đến khu tập kết bát bẩn.
8. Rửa theo mẻ; quá trình rửa tiếp tục chạy nền.
9. Đóng quán khi người chơi sẵn sàng. Bảng tổng kết cuối ngày đối soát doanh thu, chi phí, hàng tồn, đồ bỏ đi, tiền mặt và nợ. Doanh thu không được cộng lần thứ hai.

### Các khu vực thao tác nấu phở

- Nồi nước dùng để chan, hiển thị số lít còn lại và số bát ước tính.
- Nồi trụng bánh phở riêng.
- Khay thịt và thao tác chia khẩu phần.
- Rau thơm, hành, gia vị, mì chính và đồ nêm.
- Kho bát sạch.
- Bảng gọi món và kệ chờ bát.
- Khu tập kết bát bẩn và thao tác rửa theo mẻ.

### Nguyên tắc thao tác nấu

- Bản đầu dùng cơ chế **nấu thủ công có hỗ trợ thao tác**: người chơi đưa ra lựa chọn quan trọng và thực hiện trình tự chính, nhưng các thao tác lặp lại đòi hỏi độ chính xác cao cần có độ dễ chịu, không quá vụn vặt.
- Giới hạn ban đầu được đề xuất là tối đa ba đơn/bát đang xử lý cùng lúc; cần kiểm chứng bằng bản mẫu.
- Mục tiêu lắp ráp một bát là **15–20 giây sau khi đã chuẩn bị nguyên liệu**. Đây mới là giả thuyết cân bằng, chưa phải kết quả đo. Một lượt phục vụ hoàn chỉnh còn gồm đọc đơn, di chuyển, bưng bát, thanh toán và dọn bàn.
- Không dùng đồng hồ đếm ngược nổi bật. Sự sốt ruột thể hiện qua lời thoại, tư thế và cử chỉ; phục vụ chậm làm giảm thiện cảm thay vì khiến đơn thất bại ngay lập tức.
- Người chơi vẫn có thể tự bưng bát khi đã thuê nhân viên.

### Dọn rửa

Không có trò chơi nhỏ riêng cho từng bát. Người chơi gom nhiều bát, đặt vào khu tập kết rồi bắt đầu một lượt rửa theo mẻ. Khi chọn kết thúc ngày, hệ thống tự xử lý phần dọn dẹp còn lại; người chơi không bị mắc kẹt vì bắt buộc rửa sạch mọi bát.

## 4. Món ăn, công thức, nước dùng và tồn kho

### Thực đơn ban đầu

- Phở cơ bản: **40.000 đồng**.
- Phở thêm thịt/phở thập cẩm: **45.000 đồng**.
- Đây là mức giá thiết kế trong trò chơi, không phải tuyên bố về giá trung bình của toàn Hà Nội.
- Công thức giả định ban đầu cho một bát cơ bản: 150g bánh phở, 50g thịt bò sử dụng được và 380ml nước dùng. Bát thêm thịt dùng khoảng 60g thịt bò. Khẩu phần chính xác là tham số cân bằng và phải được thử nghiệm.
- Phong cách Hà Nội làm chuẩn: nước dùng trong, vị đậm đà; bánh phở dẹt; thịt bò; hành lá/rau mùi; có thể dùng giấm tỏi, ớt, chanh và quẩy. Không mặc định dùng giá đỗ, húng quế và tương đen theo phong cách miền Nam.
- Về sau có thể thêm các loại thịt như tái/chín, nạm, gầu, gân, bắp bò; mỗi loại có tồn kho, tỷ lệ thu hồi sau sơ chế, cách chuẩn bị và giá vốn riêng.

### Sổ công thức và phản hồi khách

Minh có thể lưu và điều chỉnh món trong **Sổ công thức của Minh**. Người chơi khám phá công thức bằng thử nghiệm có chủ đích và phản hồi của khách. Không có một công thức hoàn hảo với mọi người; mì chính cũng không phải nút tăng độ ngon vô hạn. Phần nêm vào nồi nước dùng và phần nêm riêng từng bát phải được ghi thành hai đầu vào riêng, rõ ràng để tránh tính trùng.

### Lô hàng tồn kho

Hệ thống nội bộ theo dõi từng lô gồm: nguyên liệu, số lượng, giá mua, ngày nhận, hạn dùng, tình trạng bảo quản, lượng đã dùng và lượng đã bỏ. Người chơi nhìn thấy số lượng, tình trạng tươi/sắp hỏng/không dùng được, giá của lô gần nhất và ước tính lượng món có thể làm — không cần thấy các trường dữ liệu kiểu cơ sở dữ liệu.

- Hàng tươi/dễ hỏng như thịt bò, bánh phở, rau: ưu tiên dùng lô còn hợp lệ có hạn dùng gần nhất.
- Hàng khô như gia vị, muối, đường: cộng dồn tồn kho, tránh liên tục làm phiền bằng cảnh báo hạn dùng.
- Thành phẩm chuẩn bị theo mẻ như nước dùng, thịt sơ chế: theo dõi lượng còn lại, ngày chế biến và điều kiện bảo quản.
- Giá nhà cung cấp mới chỉ áp dụng cho lô mua mới, không sửa lại giá vốn của hàng đã mua.
- Phải phân bổ đúng hao hụt khi sơ chế. Ví dụ: 1kg thịt bò sống chỉ thu được 900g thịt dùng được thì giá vốn mỗi gam thịt dùng được phải chia cho 900g, không phải 1.000g.

### Quy tắc nấu nước dùng theo mẻ

- Nước dùng được nấu theo mẻ, không nhất thiết ngày nào cũng nấu. Khi tương tác với nồi, giao diện hiển thị số lít còn lại và số bát ước tính theo lượng nước dùng mỗi vá hiện tại; không tự động bảo người chơi nấu thêm hoặc dự báo nhu cầu ngày mai.
- Giá thành một mẻ gồm nguyên liệu thực tế, gia vị và nhiên liệu, mỗi khoản chỉ tính một lần. Chia tổng chi phí cho lượng nước dùng thực tế sau lọc, sau đó trừ đúng lượng múc ra cho mỗi bát.
- Nước dùng còn lại và được bảo quản an toàn tiếp tục nằm trong tồn kho. Nếu làm nguội/bảo quản không an toàn, cả mẻ không được bán và phải ghi nhận loại bỏ đúng một lần. Đun lại hoặc ngửi thử không phải cách xử lý an toàn thần kỳ.
- Ví dụ minh họa: mẻ 297.000 đồng, sau lọc còn 16 lít, tương đương 18.562,5 đồng/lít và khoảng 7.054 đồng cho một khẩu phần 380ml. Đây chỉ là ví dụ tính toán, không phải giá thị trường đã được xác minh.
- Trước khi phát hành, cần kiểm tra ngưỡng an toàn thực phẩm và thời hạn bảo quản thực tế bằng nguồn chuyên môn đáng tin cậy. Trò chơi nên dùng quy tắc thận trọng, không tự nhận là tài liệu đào tạo an toàn thực phẩm.

## 5. Nhắn tin đặt hàng nhà cung cấp

Dùng một ứng dụng nhắn tin đơn giản trên điện thoại cũ của Minh — không phải sàn thương mại điện tử và không mô phỏng cuộc gọi thoại.

- Ba nhóm nhà cung cấp chính: thịt bò; bánh phở; rau và hàng khô.
- Mỗi nhà cung cấp gửi tối đa một tin tổng hợp giá và tình trạng hàng trong một ngày chơi.
- Nhà cung cấp gửi báo giá và lượng hàng có thể giao cho ngày hôm sau. Người chơi có thể đặt theo đơn trước, chỉnh số lượng hoặc bỏ qua; dùng nút lựa chọn nhanh, không nhập văn bản tự do.
- Trước khi xác nhận, hiển thị tổng tiền và thời gian giao. Khi đã xác nhận, giá được cố định và hàng đến vào sáng hôm sau.
- Đơn đặt sau khi đóng quán sẽ đến sáng hôm sau. Đơn mới đặt sau khi đã bắt đầu bán cũng đến vào sáng hôm sau.
- Mua gấp ở chợ gần đó là phương án dự phòng, với hàng có hạn, tốn thời gian và có thể đắt hơn khi phù hợp. Chưa cố định một tỷ lệ tăng giá chung trước khi cân bằng trò chơi.
- Giá thị trường nhìn chung ổn định, thỉnh thoảng thay đổi nhẹ và hiếm khi có biến động lớn trong thời gian ngắn. Chỉ nguyên liệu bị ảnh hưởng mới đổi giá; thời tiết tác động trực tiếp đến rau và vận chuyển nhiều hơn thịt bò. Mức thay đổi 3–5% cho biến động nhỏ và 8–10% cho sự kiện hiếm chỉ là tham số thử nghiệm, không phải khẳng định về thị trường thật.

## 6. Thời gian, lượng khách và sự kiện

### Quy tắc lịch đã chốt

- **Một tháng trong game = 10 ngày chơi.** Toàn bộ chiến dịch trả nợ kéo dài 10 tháng, tương đương 100 ngày chơi.
- Một chu kỳ tài chính = một tháng chơi = **10 ngày chơi**. Không còn khái niệm một tháng 30 ngày chơi trong mô hình hiện hành.
- Tháng chơi được tính bằng `tháng = floor((ngày_toàn_cục - 1) / 10) + 1`.
- Thứ trong tuần vẫn chạy liên tục, không đặt lại đầu tháng: `thứ = ((ngày_toàn_cục - 1) mod 7)`.
- Tiền thuê, điện nước và các khoản định kỳ được thu theo tháng chơi 10 ngày. Các khoản mua hàng, trả nợ, tiền đặt cọc và tiền thuê trả trước vẫn phải được hạch toán theo giao dịch thực tế, không được tính hai lần.

### Độ dài ngày — mục tiêu thử nghiệm, chưa chốt

Mục tiêu là **15–25 phút thực cho một ngày bình thường** và **20–30 phút cho ngày sự kiện/giờ cao điểm**; khi mở sổ, công thức hoặc bảng tài chính thì thời gian tạm dừng. Người chơi có thể đóng quán sớm. Đây là khoảng để thử nghiệm, không phải cam kết của bản phát hành. Bản mẫu phải đo vòng chơi hoàn chỉnh ở mức 10, 15 và 20 bát/ngày. Nếu không thể phục vụ 20 bát trong khoảng thời gian dễ chịu, hãy giảm thời gian chết hoặc số thao tác thừa trước khi nghĩ đến tự động hóa nấu ăn.

### Mô hình lượng khách

Lượng khách thay đổi theo nhóm khách, thời điểm trong ngày, thứ trong tuần, lịch học/mùa hè, thời tiết, danh tiếng và mức giá phù hợp. Ảnh hưởng của lịch học chủ yếu áp dụng cho học sinh/phụ huynh; không áp dụng một hệ số giảm khách mùa hè cho tất cả nhóm. Mưa có thể làm giảm người qua lại và ảnh hưởng nguồn rau, nhưng không được liên tục trừng phạt người chơi.

- Giai đoạn học chơi: mục tiêu 10–14 bát/ngày.
- Xe phở vận hành ổn định: 14–20 bát/ngày.
- Xe phở đã phát triển/tối ưu: 18–25 bát/ngày.
- Ngày sự kiện/giờ cao điểm: 25–30 bát/ngày; không phải mức bình thường khi chơi một mình.

Đây là mục tiêu cân bằng. Lượng khách nên tự điều chỉnh nhẹ theo năng lực phục vụ thực tế: nếu người chơi liên tục quá tải, một số khách tiềm năng có thể đi qua hoặc quay lại sau, thay vì tạo ra chuỗi thất bại không hồi phục.

## 7. Kinh tế và hạch toán

### Các giả định chuẩn đang dùng

Các con số dưới đây là giả định cân bằng trò chơi, không phải khẳng định về mức trung bình ngoài đời. Vì một tháng trong game chỉ có 10 ngày chơi, các khoản thuê định kỳ được quy đổi theo tháng chơi 10 ngày để giữ nhịp chi phí mỗi ngày chơi gần với mô hình trước đó. Các con số thuê đã quy đổi là giả định thiết kế cần kiểm chứng, không phải giá thuê thực tế.

| Hạng mục | Giá trị đang dùng | Trạng thái/quy tắc |
|---|---:|---|
| Giá phở cơ bản | 40.000 đồng | Mức giá thiết kế |
| Giá phở thêm thịt/thập cẩm | 45.000 đồng | Mức giá thiết kế |
| Giá vốn trực tiếp một bát cơ bản | 25.500 đồng | Ước tính tạm thời |
| Giá vốn trực tiếp một bát thêm thịt | 28.500 đồng | Ước tính tạm thời |
| Tỷ trọng món bán ra giả định | 70% cơ bản / 30% thêm thịt | Giả định cân bằng |
| Giá bán bình quân gia quyền | 41.500 đồng/bát | Chỉ dùng trong mô hình nội bộ |
| Giá vốn bình quân gia quyền | 26.400 đồng/bát | Chỉ dùng trong mô hình nội bộ |
| Lãi góp bình quân | 15.100 đồng/bát | Giá bán bình quân trừ giá vốn bình quân |
| Tiền mặt đầu game | 2.000.000 đồng | Không phải tiền gia đình cứu trợ hay tiền của ông Năm |
| Hàng tồn ban đầu | 300.000 đồng | Theo dõi riêng với tiền mặt |
| Nợ gốc | 18.000.000 đồng | Sau dàn xếp chỉ còn khoản gốc |
| Tiền thuê phòng | 500.000 đồng / tháng chơi 10 ngày | Quy đổi để giữ mức chi phí theo ngày chơi gần với mô hình cũ; cần kiểm chứng cân bằng |
| Điện nước/vệ sinh/bảo trì nhỏ | 50.000 đồng / tháng chơi 10 ngày | Quy đổi cùng cơ sở thời gian |
| Chi phí cố định xe phở trước trả nợ | 550.000 đồng / tháng chơi | Tiền phòng + điện nước/bảo trì; nhiên liệu đã nằm trong giá vốn nước dùng |
| Tiền thuê cửa hàng | Khoảng 833.333 đồng / tháng chơi 10 ngày | Quy đổi từ giả định 2,5 triệu/30 ngày chơi; là giả định cân bằng |
| Tiền cần mở cửa hàng | Khoảng 3.666.666 đồng | 833.333 đồng đặt cọc + 833.333 đồng thuê trước tháng đầu + 2 triệu đồng sửa chữa/dụng cụ; cần kiểm chứng |
| Quỹ dự phòng khuyến nghị khi mở cửa hàng | Ít nhất 1.500.000 đồng ngoài chi phí mở | Ngưỡng bảo vệ dòng tiền, cần kiểm thử |

### Lịch trả nợ — đã chốt

- **Tháng 1:** ân hạn; Minh học nghề, mở quán và gây dựng nhịp bán hàng. Không có khoản trả nợ tối thiểu theo lịch mới.
- **Đầu tháng 2:** giang hồ đến phá quán; ông Năm can thiệp giúp chốt khoản nợ chỉ còn 18.000.000 đồng tiền gốc, không tính lãi và phí bị ép buộc.
- **Cuối tháng 2 đến cuối tháng 10:** trả **2.000.000 đồng vào cuối mỗi tháng chơi**, tổng cộng 9 lần × 2.000.000 = 18.000.000 đồng.
- Mỗi tháng chơi có 10 ngày; khoản trả đầu tiên đến hạn cuối ngày chơi thứ 20, khoản cuối cùng đến hạn cuối ngày chơi thứ 100.
- Sau dàn xếp, sổ nợ không cộng lãi. Con số 36 triệu chỉ là khoản bị đòi ép buộc trước khi ông Năm can thiệp, không phải số dư thực tế sau thỏa thuận.
- Có thể cho phép trả thêm vào gốc nếu người chơi có đủ tiền mặt an toàn; không được ép trả sớm nếu việc đó khiến người chơi không thể mua nguyên liệu hoặc chi trả chi phí thiết yếu.
- Đây là lịch cốt truyện đã chốt, nhưng khả năng cân bằng tài chính vẫn phải được kiểm thử trong bản mẫu.

### Điểm hòa vốn sơ bộ

Dùng lãi góp bình quân 15.100 đồng/bát và 10 ngày trong một tháng chơi:

- Trước khi tính nợ: 550.000 / (15.100 × 10) ≈ 3,64 → khoảng **4 bát/ngày** để bù chi phí cố định.
- Trong tháng có trả nợ: (550.000 + 2.000.000) / (15.100 × 10) ≈ 16,89 → khoảng **17 bát/ngày**.
- Sau khi mở cửa hàng và vẫn thuê phòng: chi phí cố định khoảng 500.000 + 833.333 + 50.000 = **1.383.333 đồng/tháng chơi**. Cộng 2.000.000 đồng trả nợ, điểm hòa vốn là 3.383.333 / 151.000 ≈ 22,41 → khoảng **23 bát/ngày**.
- Sau khi mở cửa hàng và không còn thuê phòng riêng: chi phí cố định khoảng 833.333 + 50.000 = **883.333 đồng/tháng chơi**. Cộng khoản trả nợ 2.000.000 đồng, điểm hòa vốn là 2.883.333 / 151.000 ≈ 19,10 → khoảng **20 bát/ngày**.
- Sau khi mở cửa hàng nhưng vẫn thuê phòng, bán 18 bát/ngày tạo lãi góp 2.718.000 đồng; trừ 1.383.333 đồng chi phí cố định và 2.000.000 đồng trả nợ thì còn **âm khoảng 665.333 đồng/tháng chơi**, chưa tính lương và hao hụt.
- Cùng kịch bản giữ phòng riêng, bán 25 bát/ngày tạo lãi góp 3.775.000 đồng; trừ 1.383.333 đồng và 2.000.000 đồng thì còn **khoảng 391.667 đồng/tháng chơi**, trước tiền công, hao hụt và chi phí phát sinh.

Đây là phép tính lãi góp, chưa phải mô phỏng đầy đủ dòng tiền. Bản mẫu phải kiểm tra cả tiền mua hàng, lượng tồn ban đầu, hư hỏng, tiền thuê trả trước, tiền đặt cọc, tiền công và giao dịch trả nợ. Nếu các giả định này khiến người chơi không thể trả nợ ở lượng khách thông thường, phải điều chỉnh tham số kinh tế sau khi thử nghiệm — không được âm thầm thay lịch nợ đã chốt.

### Kiểm tra sức chịu đựng khi giá nguyên liệu tăng

Nếu giá bán bình quân vẫn là 41.500 đồng và toàn bộ giá vốn bình quân 26.400 đồng tăng theo kịch bản:

| Kịch bản | Lãi góp/bát | Hòa vốn xe phở có trả nợ | Hòa vốn cửa hàng, vẫn thuê phòng |
|---|---:|---:|---:|
| Cơ sở | 15.100 đồng | 17 bát/ngày | 23 bát/ngày |
| Giá vốn tăng 10% | 12.460 đồng | 21 bát/ngày | 28 bát/ngày |
| Giá vốn tăng 20% | 9.820 đồng | 26 bát/ngày | 35 bát/ngày |

Nếu toàn bộ giá vốn cùng tăng 20%, việc giữ cả phòng riêng lẫn cửa hàng gần như không bền vững ở mức khách thường. Vì vậy biến động giá phải hiếm, chỉ tác động đến nhóm nguyên liệu liên quan; người chơi cần có thời gian và lựa chọn để điều chỉnh giá, đổi nguồn hàng hoặc tạm ngừng bán món bị ảnh hưởng. Đây là phép thử cân bằng trò chơi, không phải dự báo giá ngoài đời.

### Những nguyên tắc hạch toán bắt buộc

- Khách trả tiền thì tiền mặt tăng ngay, đúng một lần.
- Mua hàng làm tiền mặt giảm và tồn kho tăng; không tính lại toàn bộ khoản mua thành giá vốn ngay lúc đó.
- Giá vốn trực tiếp được ghi nhận khi nguyên liệu được dùng cho bát đã bán.
- Hàng bỏ đi được theo dõi riêng và ghi giảm đúng một lần.
- Trả nợ gốc làm tiền mặt và dư nợ giảm; không coi là chi phí vận hành.
- Tiền đặt cọc là khoản tiền bị khóa, không phải chi phí thuê.
- Tiền thuê trả trước được thanh toán bằng tiền mặt một lần và phân bổ vào thời gian đã trả; không thu lại cùng khoản tiền thuê trong giai đoạn đó.
- Sửa chữa/dụng cụ mở cửa hàng là khoản đầu tư ban đầu một lần, không gộp lẫn với tiền thuê định kỳ.
- Nhiên liệu đã nằm trong giá thành mẻ nước dùng, không thu thêm lần nữa theo từng bát.
- Trà đá/nhân trần do ông Năm cung cấp được đối soát riêng; chỉ khoản hoa hồng đã thỏa thuận rõ (nếu có) mới là doanh thu của Minh.

## 8. Nhân viên tùy chọn

**Khuyến nghị:** chỉ đưa một nhân viên bưng bê tùy chọn vào bản phát hành đầy đủ sau khi vòng phục vụ một mình đã vượt qua thử nghiệm. Không đưa trí tuệ nhân tạo điều khiển nhân viên vào bản mẫu lát cắt dọc đầu tiên.

- Mốc mở khóa đề xuất: người chơi duy trì khoảng 15–18 bát/ngày trong vài ngày và đạt điều kiện về danh tiếng/cốt truyện.
- Tiền công đề xuất: 60.000–80.000 đồng cho một ca ngắn; cần kiểm chứng với kinh tế trò chơi. Với lãi góp 15.100 đồng/bát, mức này tương đương lãi góp của khoảng 4–6 bát. Nhân viên phải giúp tăng năng lực phục vụ hoặc giảm thời gian chờ, không tự tạo thêm nhu cầu khách.
- Nhiệm vụ: bưng bát đã hoàn thành từ kệ chờ đến đúng bàn và thu bát bẩn về khu tập kết.
- Không nấu phở, mua hàng, thu ngân, xử lý nợ hay tự quản lý toàn bộ quán.
- Nhân viên không được lấy bát người chơi đang cầm/xử lý, mang nhầm bàn, thu tiền hai lần hoặc làm bát biến mất. Nếu đường đi bị chặn, nhân viên phải chờ hoặc chọn đường thay thế an toàn.
- Phụ bếp là tính năng mở rộng về sau, sau khi thuê cửa hàng; không thuộc phạm vi nhân viên ban đầu.

Tính năng nhân viên vẫn là đề xuất chờ chủ dự án duyệt vì đề xuất mới nhất chưa nhận được sự đồng ý rõ ràng.

## 9. Mở rộng cửa hàng và tiến trình

- Thuê lại mặt bằng cũ của cô Hường là lựa chọn tự nguyện, chỉ mở sau một mốc cốt truyện và không phải con đường duy nhất để hoàn thành trò chơi.
- Số tiền cần chuẩn bị theo mô hình thời gian hiện tại khoảng 3,67 triệu: 833.333 đồng đặt cọc (bị khóa), 833.333 đồng trả trước tháng đầu và 2 triệu sửa chữa/dụng cụ. Ngoài khoản đó, nên giữ ít nhất 1,5 triệu đồng dự phòng. Đây là giả định cân bằng theo tháng chơi 10 ngày, cần kiểm thử trước khi duyệt triển khai.
- Không tự động tăng lượng khách chỉ vì người chơi có cửa hàng lớn hơn. Mặt bằng mới tăng không gian, số bàn và năng lực phục vụ; nhu cầu vẫn phụ thuộc nhóm khách, danh tiếng, thời tiết và mức giá.
- Theo dõi rõ thời hạn tiền thuê đã trả trước. Tháng chơi đầu tiên sau khi mở cửa hàng được chi trả bằng khoản thuê trả trước 833.333 đồng; không trừ tiền mặt thêm lần nữa trong tháng đó, dù sổ kế toán vẫn có thể ghi nhận chi phí thuê phân bổ theo thời gian.
- Không có vòng lặp nâng cấp phòng ngủ/đi nơi khác để ngủ. Đóng quán sẽ chuyển sang ngày mới; về sau có thể thêm một góc nghỉ nhỏ trong nhà nếu phục vụ cốt truyện, nhưng không biến thành hệ thống quản lý bắt buộc.

## 10. Giao diện và điều khiển — mặc định đề xuất

- **WASD:** di chuyển; chuột: nhìn xung quanh.
- **E:** tương tác; chuột trái: lấy/đặt; chuột phải: hủy/đưa vật về vị trí an toàn.
- **Q:** mở bảng gọi món; con lăn chuột: chỉnh khẩu phần khi phù hợp; **Tab:** sổ bếp.
- Có thể đổi phím điều khiển. Không đặt thao tác nấu quan trọng vào một tổ hợp phím khó bấm.
- Giao diện nồi nước dùng hiển thị số lít còn lại và số bát ước tính theo lượng chan hiện tại.
- Sổ cuối ngày hiển thị tiền đầu/cuối ngày, doanh thu, tiền mua hàng, giá vốn, hàng bỏ đi, tồn kho, tiền thuê/chi phí khác, dư nợ và kỳ trả tiếp theo. Dùng tiếng Việt phổ thông, thông báo khoản phải trả trước khi người chơi xác nhận quyết định tốn kém.

## 11. Phạm vi và các cổng bàn giao

### Bản mẫu lát cắt dọc — phải làm trước

- Một góc ngõ nhỏ gọn và một xe phở.
- Một vòng ngày hoàn chỉnh: chuẩn bị → nhận đơn → nấu → bưng → thanh toán → thu bát bẩn → đóng ngày.
- Khay hai bát; phục vụ đúng bàn; không thanh toán hai lần.
- Ba biến thể bát/đơn và một nhóm nhỏ kiểu khách.
- Theo dõi số lượng tồn kho cơ bản và sổ tiền mặt đối soát được.
- Ghi nhận thời lượng ngày và năng suất ở mức 10/15/20 bát.
- Chưa cần trí tuệ nhân tạo nhân viên, mở rộng cửa hàng, hệ thống mùa, cảnh phim phức tạp hay đồ họa hoàn thiện.

### Hệ thống cho bản phát hành đầu sau khi bản mẫu được kiểm chứng

- Tồn kho theo lô, nước dùng theo mẻ, sổ công thức và phản hồi khách.
- Đặt hàng nhà cung cấp qua tin nhắn và phương án mua gấp ở chợ.
- Biến động nhu cầu theo thời tiết, thứ trong tuần và lịch học.
- Lịch trả nợ, các mốc cốt truyện, lần ông Năm can thiệp và sự kiện cửa hàng cô Hường.
- Một nhân viên bưng bê tùy chọn nếu đã kiểm chứng điểm nghẽn phục vụ và tính hợp lý của tiền công.
- Mở rộng cửa hàng tùy chọn, có hạch toán tiền đặt cọc và tiền thuê trả trước.

### Tính năng để sau hoặc nếu còn nguồn lực

- Thêm loại thịt và chiều sâu công thức.
- Phụ bếp, nhân viên bổ sung, tùy chỉnh sâu bố cục cửa hàng và thêm sự kiện khu phố.
- Nội dung theo mùa và hoàn thiện chất lượng trình bày.

### Quyết định kỹ thuật còn bỏ ngỏ

Chưa duyệt bộ công cụ phát triển trò chơi, cấu hình máy tính tối thiểu, định dạng lưu, kiến trúc tương tác hay cách triển khai nhân vật không điều khiển bởi người chơi và tìm đường. Không bắt đầu viết mã sản phẩm hoặc đặt làm tài sản đồ họa trước khi chủ dự án duyệt tài liệu và một kế hoạch triển khai riêng.

## 12. Các phép thử nghiệm thu

### Trạng thái của đơn phục vụ

- Một đơn đi qua các trạng thái `đã_nhận → đang_chuẩn_bị → trên_kệ_chờ → đã_phục_vụ → đã_thanh_toán → đã_dọn_bàn` mà không bỏ qua bước.
- Một bát chỉ được thanh toán một lần; đúng bàn nhận đúng đơn.
- Người chơi vẫn tự phục vụ được khi nhân viên đang hoạt động.
- Nhân viên không được lấy bát người chơi đang cầm hoặc thao tác.
- Nhân viên bị chặn đường không được làm mất bát hoặc tạo thanh toán trùng.

### Tồn kho và giá vốn công thức

- Mua 1kg thịt bò làm tiền mặt giảm đúng giá đã xác nhận và tồn kho tăng chính xác 1kg.
- Dùng 55g thịt làm lượng của đúng lô còn hợp lệ giảm chính xác 55g.
- Các lô mua ở mức giá khác nhau giữ nguyên giá vốn riêng; giá mới không sửa giá của hàng cũ.
- Hao hụt sơ chế được phản ánh trong giá mỗi gam nguyên liệu sử dụng được.
- Giá thành mẻ nước dùng dùng sản lượng sau lọc thực tế; mỗi bát chan 380ml phải trừ đúng 380ml và phân bổ chi phí chính xác.
- Nước dùng còn an toàn vẫn nằm trong tồn kho; nước dùng không an toàn được ghi loại bỏ một lần; không có cơ chế “đun lại là an toàn”.
- Mì chính không bị tính cả trong mẻ nước dùng lẫn từng bát, trừ khi công thức thực sự sử dụng ở cả hai bước.

### Tiền mặt và hạch toán

- Doanh thu bán hàng vào tiền mặt ngay và không được cộng lại cuối ngày.
- Mua hàng, giá vốn, hao hụt, tiền thuê, tiền công, trả nợ, đặt cọc và tiền thuê trả trước là các giao dịch riêng biệt.
- Giai đoạn tiền thuê cửa hàng đã trả trước không bị tính tiền hai lần.
- Trả nợ làm giảm tiền mặt và dư nợ gốc, không làm giảm lợi nhuận vận hành như một khoản chi phí.
- Tiền mặt cuối ngày khớp với sổ giao dịch trong sai số làm tròn cho phép.

### Lịch và lượng khách

- Tiền thuê được thu theo tháng chơi 10 ngày; lịch thứ trong tuần tiếp tục chạy qua ranh giới tháng.
- Thứ trong tuần tiếp tục chạy qua ranh giới tháng.
- Lịch học làm thay đổi hành vi của phụ huynh/học sinh mà không khiến mọi nhóm khách cùng giảm nhu cầu một cách máy móc.
- Ảnh hưởng thời tiết và biến động nhà cung cấp có giới hạn, dễ hiểu, không cộng dồn thành tình huống phá sản không thể tránh.

### Trải nghiệm người chơi

- Thử một ngày làm quen với 10 bát, ngày bình thường 15 bát, ngày bận 20 bát và ngày sự kiện 25–30 bát.
- Ghi thời gian hoàn thành, tỷ lệ bưng nhầm bàn, số đơn bỏ dở, tiền dự phòng, lượng hao hụt và mức căng thẳng cảm nhận.
- Một ngày bán kém hoặc một mẻ nước dùng hỏng không được tạo ra chuỗi thất bại dẫn tới kết thúc trò chơi.
- Người chơi có thể đóng quán sớm và được cảnh báo về khoản thuê/nợ sắp đến hạn trước khi quyết định tốn kém.

## 13. Mức độ sẵn sàng phát hành

**Định hướng thiết kế và cốt truyện đã được hợp nhất để chủ dự án duyệt. Chưa bắt đầu lập kế hoạch triển khai chi tiết cho đến khi chủ dự án duyệt đặc tả bằng văn bản. Sau khi duyệt, bước kế tiếp là lập kế hoạch bản mẫu lát cắt dọc; chưa sẵn sàng cho sản xuất toàn diện.** Các rủi ro lớn nhất còn lại là: (1) độ dài ngày so với tốc độ phục vụ thủ công; (2) độ chính xác của dòng tiền khi tính tồn kho và chi phí trả trước; (3) khả năng chi trả khi mở rộng cửa hàng trong kịch bản xấu; (4) khả năng tìm đường và quyền sở hữu bát của nhân viên; và (5) chưa chọn công cụ làm trò chơi cùng kiến trúc kỹ thuật.