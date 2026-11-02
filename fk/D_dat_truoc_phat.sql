-- =====================================================================
-- LibMS | fk/D_dat_truoc_phat.sql
-- Mảng D: Đặt trước, phạt, đánh giá
-- Người phụ trách: Nguyễn Khang Kỳ
-- Nội dung: ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY cho các bảng của mảng này.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] Khóa ngoại của DAT_TRUOC (xem mục 3.2 báo cáo BTL1)
--   [ ] Khóa ngoại của PHIEU_PHAT (xem mục 3.2 báo cáo BTL1)
--   [ ] Khóa ngoại của DANH_GIA (xem mục 3.2 báo cáo BTL1)


ALTER TABLE DAT_TRUOC
 ADD CONSTRAINT fk_d_dt_reader FOREIGN KEY(ma_doc_gia) REFERENCES DOC_GIA(ma_nguoi_dung),
 ADD CONSTRAINT fk_d_dt_title FOREIGN KEY(ma_tai_lieu) REFERENCES TAI_LIEU(ma_tai_lieu),
 ADD CONSTRAINT fk_d_dt_copy FOREIGN KEY(ma_tai_lieu_giu_cho,so_thu_tu_giu_cho)
 REFERENCES BAN_SAO(ma_tai_lieu,so_thu_tu_ban_sao);
ALTER TABLE PHIEU_PHAT
 ADD CONSTRAINT fk_d_pp_loan FOREIGN KEY(ma_phieu_muon,stt_chi_tiet)
 REFERENCES CHI_TIET_PHIEU_MUON(ma_phieu_muon,stt),
 ADD CONSTRAINT fk_d_pp_staff FOREIGN KEY(ma_nv_thu) REFERENCES NHAN_VIEN(ma_nguoi_dung);
ALTER TABLE DANH_GIA
 ADD CONSTRAINT fk_d_dg_reader FOREIGN KEY(ma_doc_gia) REFERENCES DOC_GIA(ma_nguoi_dung),
 ADD CONSTRAINT fk_d_dg_title FOREIGN KEY(ma_tai_lieu) REFERENCES TAI_LIEU(ma_tai_lieu);
