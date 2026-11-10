-- =====================================================================
-- LibMS | queries/D_dat_truoc_phat.sql
-- Mảng D: Đặt trước, phạt, đánh giá
-- Người phụ trách: Nguyễn Khang Kỳ
-- Nội dung: Truy vấn cho từng FR, mỗi truy vấn ghi FR, đầu vào, đầu ra.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] Truy vấn cho FR15–FR22

SET @ma_doc_gia='XD005';
SELECT fn_tong_no_phat(@ma_doc_gia) AS no_phat_chua_thu,
 fn_phat_tam_tinh(@ma_doc_gia) AS phat_tam_tinh;
SELECT d.ma_dat_truoc,t.tieu_de,d.ngay_dat,d.trang_thai,d.han_nhan,
 fn_thu_tu_hang_doi(d.ma_dat_truoc) AS thu_tu_hang_doi
FROM DAT_TRUOC d JOIN TAI_LIEU t ON t.ma_tai_lieu=d.ma_tai_lieu
WHERE d.ma_doc_gia=@ma_doc_gia ORDER BY d.ngay_dat DESC,d.ma_dat_truoc DESC;
SELECT pp.*,pm.ma_doc_gia,ct.ma_tai_lieu,ct.so_thu_tu_ban_sao,t.tieu_de
FROM PHIEU_PHAT pp JOIN PHIEU_MUON pm ON pm.ma_phieu_muon=pp.ma_phieu_muon
JOIN CHI_TIET_PHIEU_MUON ct ON ct.ma_phieu_muon=pp.ma_phieu_muon AND ct.stt=pp.stt_chi_tiet
JOIN TAI_LIEU t ON t.ma_tai_lieu=ct.ma_tai_lieu
WHERE pm.ma_doc_gia=@ma_doc_gia ORDER BY pp.ngay_lap DESC,pp.ma_phieu_phat DESC;