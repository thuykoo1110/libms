-- =====================================================================
-- LibMS | index/D_dat_truoc_phat.sql
-- Mảng D: Đặt trước, phạt, đánh giá
-- Người phụ trách: Nguyễn Khang Kỳ
-- Nội dung: CREATE INDEX, mỗi index ghi rõ phục vụ truy vấn nào.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] Chỉ mục cho các truy vấn hay dùng của mảng, ghi lý do chọn cột và thứ tự cột

-- FR17 / BR12: lọc hàng đợi theo tài liệu, trạng thái;
-- sắp xếp theo ngày đặt, dùng mã đặt trước để phân định khi trùng ngày.
CREATE INDEX idx_dat_truoc_hang_doi
ON DAT_TRUOC (ma_tai_lieu, trang_thai, ngay_dat, ma_dat_truoc);