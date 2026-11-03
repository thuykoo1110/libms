-- Liên kết ma_doc_gia trong PHIEU_MUON trỏ tới khóa chính ma_nguoi_dung bảng DOC_GIA
ALTER TABLE PHIEU_MUON 
    ADD CONSTRAINT fk_phieumuon_dg FOREIGN KEY (ma_doc_gia) 
    REFERENCES DOC_GIA(ma_nguoi_dung);

-- Liên kết ma_nv_xu_ly trong PHIEU_MUON trỏ tới khóa chính ma_nguoi_dung bảng NHAN_VIEN
ALTER TABLE PHIEU_MUON 
    ADD CONSTRAINT fk_phieumuon_nv FOREIGN KEY (ma_nv_xu_ly) 
    REFERENCES NHAN_VIEN(ma_nguoi_dung);

-- Liên kết ma_phieu_muon trong CHI_TIET_PHIEU_MUON trỏ tới PHIEU_MUON
ALTER TABLE CHI_TIET_PHIEU_MUON 
    ADD CONSTRAINT fk_ctpm_pm FOREIGN KEY (ma_phieu_muon) 
    REFERENCES PHIEU_MUON(ma_phieu_muon);

-- Liên kết khóa ngoại tổ hợp (ma_tai_lieu, so_thu_tu_ban_sao) trỏ tới khóa chính BAN_SAO
ALTER TABLE CHI_TIET_PHIEU_MUON 
    ADD CONSTRAINT fk_ctpm_bansao FOREIGN KEY (ma_tai_lieu, so_thu_tu_ban_sao) 
    REFERENCES BAN_SAO(ma_tai_lieu, so_thu_tu_ban_sao);

-- Liên kết ma_nv_nhan_tra (người ghi nhận trả, M3) trỏ tới NHAN_VIEN, cho phép NULL khi dòng chưa trả 
ALTER TABLE CHI_TIET_PHIEU_MUON 
    ADD CONSTRAINT fk_ctpm_nv_nhan_tra FOREIGN KEY (ma_nv_nhan_tra) 
    REFERENCES NHAN_VIEN(ma_nguoi_dung);
