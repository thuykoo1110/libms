# Thay đổi so với BTL1

File này là nguồn cho mục "Thay đổi so với BTL1" trong báo cáo BTL2. Mỗi thay đổi ghi lý do, những chỗ phải sửa và trạng thái. Người cập nhật: Cái Ngọc Phương Thùy.

Chi tiết lý do và cách sửa nằm trong doc rà soát "LibMS – Rà soát thiết kế BTL1 và phân công BTL2".

## Mức 1 – Bắt buộc sửa

| Mã | Thay đổi | Đổi ERD | Mảng | Trạng thái |
|---|---|---|---|---|
| M1 | Thêm lớp con CAN_BO_TRUONG (ma_can_bo, don_vi_cong_tac) dưới DOC_GIA, vẫn rời nhau, toàn phần. Hạn mức, thời hạn giống giảng viên (10 cuốn, 30 ngày, gia hạn 2 lần). Sửa BR04, BR06, BR07, BR11, FR02, FR36, M11 | Có | A | Đã chốt |
| M2 | Thêm BR32: bản sao luận văn không được ở khu "mượn về" | Không | B | Đã chốt |
| M3 | Thêm mối liên kết ghi nhận trả: NHAN_VIEN 1:N CHI_TIET_PHIEU_MUON, từng phần cả hai phía. Cột người ghi nhận cùng NULL với ngay_tra_thuc_te, tinh_trang_khi_tra (BR30). BR21: người ghi nhận là cán bộ thư viện | Có | C | Chờ chốt tên cột |
| M4 | Thêm anh_bia vào TAI_LIEU, hoặc bỏ "bìa" khỏi M02 | Có | B | Chờ chốt |
| M5 | Điền phần việc BTL1 thật của từng người vào bảng phân công | Không | A | Chưa làm |
| M6 | Thêm BR33: đổi tham số không ảnh hưởng han_tra và phiếu phạt đã lập | Không | A | Đã chốt |

## Mức 2 – Nên sửa

| Mã | Thay đổi | Đổi ERD | Mảng | Trạng thái |
|---|---|---|---|---|
| S1 | NGUOI_DUNG đổi sang chồng lấn, toàn phần; BR04 thành "ít nhất một"; BR34 chống tự xử lý | Có | A | Chờ chốt |
| S2 | PHIEU_PHAT thêm trạng thái "đã hủy" và ly_do_huy; sách mất tìm lại về sẵn sàng | Không | D | Chờ chốt |
| S3 | Cấp lại thẻ báo mất thì sinh so_the mới | Không | A | Chờ chốt |
| S4 | Thêm thực thể THONG_BAO, NGUOI_DUNG 1:N THONG_BAO | Có | E | Chờ chốt |
| S5 | PHIEU_NHAP thêm hinh_thuc_nhap ∈ {mua, biếu tặng, nộp lưu}; ma_ncc chỉ bắt buộc khi mua; phía PHIEU_NHAP của CUNG_CAP_PHIEU đổi thành từng phần | Có | B | Chờ chốt |
| S6 | Khóa chính DIA_CHI_LIEN_HE đổi thành (ma_nguoi_dung, loai_dia_chi) | Không | A | Chờ chốt |

## Mức 3 – Ghi vào phạm vi (mục 1.1.3)

Ngày nghỉ lễ; một người hai vai trò độc giả; cao học và nghiên cứu sinh; độc giả ngoài trường; báo, tạp chí, bộ nhiều tập; đền sách; kiểm kê và nhật ký thao tác; khoa, bộ môn là chuỗi tự do.
