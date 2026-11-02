-- =====================================================================
-- LibMS | fk/C_muon_tra.sql 
-- Mảng C: Mượn, trả, gia hạn 
-- Người phụ trách: Dương Phúc Tất Nhiên 
-- Nội dung: ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY cho các bảng của mảng này.
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người 
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong 
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào. 
-- =====================================================================

-- Việc cần làm: 
-- [] Khóa ngoại của PHIEU_MUON (xem mục 3.2 báo cáo BTL1)
-- [] Khóa ngoại của CHI_TIET_PHIEU_MUON (xem mục 3.2 báo cáo BTL1)

-- ---------------------------------------------------------------------
-- 1. KHÓA NGOẠI CHO BẢNG PHIEU_MUON 
-- ---------------------------------------------------------------------

-- Liên kết ma_doc_gia trong PHIEU_MUON trỏ tới khóa chính ma_nguoi_dung của bảng DOC_GIA
ALTER TABLE PHIEU_MUON 
    ADD CONSTRAINT fk_phieumuon_dg FOREIGN KEY (ma_doc_gia) 
    REFERENCES DOC_GIA(ma_nguoi_dung);

-- Liên kết ma_nv_xu_ly trong PHIEU_MUON trỏ tới khóa chính ma_nguoi_dung của bảng NHAN_VIEN
ALTER TABLE PHIEU_MUON 
    ADD CONSTRAINT fk_phieumuon_nv FOREIGN KEY (ma_nv_xu_ly) 
    REFERENCES NHAN_VIEN(ma_nguoi_dung);


-- ---------------------------------------------------------------------
-- 2. KHÓA NGOẠI CHO BẢNG CHI_TIET_PHIEU_MUON
-- ---------------------------------------------------------------------

-- Liên kết ma_phieu_muon trong CHI_TIET_PHIEU_MUON trỏ tới bảng PHIEU_MUON
ALTER TABLE CHI_TIET_PHIEU_MUON 
    ADD CONSTRAINT fk_ctpm_pm FOREIGN KEY (ma_phieu_muon) 
    REFERENCES PHIEU_MUON(ma_phieu_muon);

-- Liên kết khóa ngoại tổ hợp (ma_tai_lieu, so_thu_tu_ban_sao) trỏ tới khóa chính của bảng BAN_SAO
ALTER TABLE CHI_TIET_PHIEU_MUON 
    ADD CONSTRAINT fk_ctpm_bansao FOREIGN KEY (ma_tai_lieu, so_thu_tu_ban_sao) 
    REFERENCES BAN_SAO(ma_tai_lieu, so_thu_tu_ban_sao);