USE libms;
GO
-- Thuộc tính đa trị 
ALTER TABLE NGUOI_DUNG_SDT
    ADD CONSTRAINT fk_nguoi_dung_sdt_nguoi_dung
    FOREIGN KEY (ma_nguoi_dung) REFERENCES NGUOI_DUNG (ma_nguoi_dung);
 
ALTER TABLE DIA_CHI_LIEN_HE
    ADD CONSTRAINT fk_dia_chi_lien_he_nguoi_dung
    FOREIGN KEY (ma_nguoi_dung) REFERENCES NGUOI_DUNG (ma_nguoi_dung);
 
-- Chuyên biệt hóa 
ALTER TABLE DOC_GIA
    ADD CONSTRAINT fk_doc_gia_nguoi_dung
    FOREIGN KEY (ma_nguoi_dung) REFERENCES NGUOI_DUNG (ma_nguoi_dung);
 
ALTER TABLE NHAN_VIEN
    ADD CONSTRAINT fk_nhan_vien_nguoi_dung
    FOREIGN KEY (ma_nguoi_dung) REFERENCES NGUOI_DUNG (ma_nguoi_dung);
 
-- QUAN_LY đệ quy 1:N 
ALTER TABLE NHAN_VIEN
    ADD CONSTRAINT fk_nhan_vien_nhan_vien
    FOREIGN KEY (ma_nguoi_quan_ly) REFERENCES NHAN_VIEN (ma_nguoi_dung);
 
-- Chuyên biệt hóa cấp 2: trỏ về DOC_GIA, KHÔNG trỏ thẳng NGUOI_DUNG 
ALTER TABLE SINH_VIEN
    ADD CONSTRAINT fk_sinh_vien_doc_gia
    FOREIGN KEY (ma_nguoi_dung) REFERENCES DOC_GIA (ma_nguoi_dung);
 
ALTER TABLE GIANG_VIEN
    ADD CONSTRAINT fk_giang_vien_doc_gia
    FOREIGN KEY (ma_nguoi_dung) REFERENCES DOC_GIA (ma_nguoi_dung);
 
ALTER TABLE NHAN_VIEN_KHAC
    ADD CONSTRAINT fk_nhan_vien_khac_doc_gia
    FOREIGN KEY (ma_nguoi_dung) REFERENCES DOC_GIA (ma_nguoi_dung);
 
-- SO_HUU_THE 1:1 
ALTER TABLE THE_THU_VIEN
    ADD CONSTRAINT fk_the_thu_vien_doc_gia
    FOREIGN KEY (ma_doc_gia) REFERENCES DOC_GIA (ma_nguoi_dung);