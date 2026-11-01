Gửi lại Nhiên đoạn code SQL cho file **`fk/C_muon_tra.sql`** trong khung code chuẩn bên dưới để dễ copy:

```sql
-- =====================================================================
-- LibMS | fk/C_muon_tra.sql
-- Mảng C: Mượn, trả, gia hạn
-- Người phụ trách: Dương Phúc Tất Nhiên
-- Nội dung: ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY cho các bảng của mảng này.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Khóa ngoại của PHIEU_MUON (Mục 3.2.3 báo cáo BTL1)
-- ---------------------------------------------------------------------

-- FK1: ma_doc_gia trỏ tới DOC_GIA(ma_nguoi_dung)
ALTER TABLE PHIEU_MUON
  ADD CONSTRAINT fk_phieu_muon_doc_gia
  FOREIGN KEY (ma_doc_gia) REFERENCES DOC_GIA(ma_nguoi_dung);

-- FK2: ma_nv_xu_ly trỏ tới NHAN_VIEN(ma_nguoi_dung)
ALTER TABLE PHIEU_MUON
  ADD CONSTRAINT fk_phieu_muon_nv_xu_ly
  FOREIGN KEY (ma_nv_xu_ly) REFERENCES NHAN_VIEN(ma_nguoi_dung);

-- ---------------------------------------------------------------------
-- 2. Khóa ngoại của CHI_TIET_PHIEU_MUON (Mục 3.2.3 BTL1 + Cập nhật M3)
-- ---------------------------------------------------------------------

-- FK1: ma_phieu_muon trỏ tới PHIEU_MUON(ma_phieu_muon)
ALTER TABLE CHI_TIET_PHIEU_MUON
  ADD CONSTRAINT fk_chi_tiet_phieu_muon_phieu_muon
  FOREIGN KEY (ma_phieu_muon) REFERENCES PHIEU_MUON(ma_phieu_muon);

-- FK2: (ma_tai_lieu, so_thu_tu_ban_sao) trỏ tới BAN_SAO(ma_tai_lieu, so_thu_tu_ban_sao)
ALTER TABLE CHI_TIET_PHIEU_MUON
  ADD CONSTRAINT fk_chi_tiet_phieu_muon_ban_sao
  FOREIGN KEY (ma_tai_lieu, so_thu_tu_ban_sao) 
  REFERENCES BAN_SAO(ma_tai_lieu, so_thu_tu_ban_sao);

-- FK3 (M3): ma_nv_nhan_tra trỏ tới NHAN_VIEN(ma_nguoi_dung)
ALTER TABLE CHI_TIET_PHIEU_MUON
  ADD CONSTRAINT fk_chi_tiet_phieu_muon_nv_nhan_tra
  FOREIGN KEY (ma_nv_nhan_tra) REFERENCES NHAN_VIEN(ma_nguoi_dung);
```