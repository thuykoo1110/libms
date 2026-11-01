-- =====================================================================
-- LibMS | fk/B_tai_lieu.sql
-- Mảng B: Tài liệu, bản sao, nhập kho
-- Người phụ trách: Châu Mạnh Phát
-- Nội dung: ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY cho các bảng của mảng này.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] Khóa ngoại của TAI_LIEU (xem mục 3.2 báo cáo BTL1)
ALTER TABLE TAI_LIEU
ADD CONSTRAINT fk_tai_lieu_nha_xuat_ban FOREIGN KEY (ma_nxb) REFERENCES NHA_XUAT_BAN(ma_nxb);

--   [ ] Khóa ngoại của TAI_LIEU_TU_KHOA (xem mục 3.2 báo cáo BTL1)
ALTER TABLE TAI_LIEU_TU_KHOA
ADD CONSTRAINT fk_tai_lieu_tu_khoa_tai_lieu FOREIGN KEY (ma_tai_lieu) REFERENCES TAI_LIEU(ma_tai_lieu);

--   [ ] Khóa ngoại của TAC_GIA (xem mục 3.2 báo cáo BTL1)
--   [ ] Khóa ngoại của VIET (xem mục 3.2 báo cáo BTL1)
ALTER TABLE VIET
ADD CONSTRAINT fk_viet_tac_gia FOREIGN KEY (ma_tac_gia) REFERENCES TAC_GIA(ma_tac_gia),
ADD CONSTRAINT fk_viet_tai_lieu FOREIGN KEY (ma_tai_lieu) REFERENCES TAI_LIEU(ma_tai_lieu);

--   [ ] Khóa ngoại của NHA_XUAT_BAN (xem mục 3.2 báo cáo BTL1)
--   [ ] Khóa ngoại của NXB_SDT (xem mục 3.2 báo cáo BTL1)
ALTER TABLE NXB_SDT
ADD CONSTRAINT fk_nxb_sdt_nha_xuat_ban FOREIGN KEY (ma_nxb) REFERENCES NHA_XUAT_BAN(ma_nxb);

--   [ ] Khóa ngoại của THE_LOAI (xem mục 3.2 báo cáo BTL1)
ALTER TABLE THE_LOAI
ADD CONSTRAINT fk_the_loai_the_loai FOREIGN KEY (ma_the_loai_cha) REFERENCES THE_LOAI(ma_the_loai);

--   [ ] Khóa ngoại của THUOC (xem mục 3.2 báo cáo BTL1)
ALTER TABLE THUOC
ADD CONSTRAINT fk_thuoc_tai_lieu FOREIGN KEY (ma_tai_lieu) REFERENCES TAI_LIEU(ma_tai_lieu),
ADD CONSTRAINT fk_thuoc_the_loai FOREIGN KEY (ma_the_loai) REFERENCES THE_LOAI(ma_the_loai);

--   [ ] Khóa ngoại của KHU_VUC (xem mục 3.2 báo cáo BTL1)
--   [ ] Khóa ngoại của BAN_SAO (xem mục 3.2 báo cáo BTL1)
ALTER TABLE BAN_SAO
ADD CONSTRAINT fk_ban_sao_tai_lieu FOREIGN KEY (ma_tai_lieu) REFERENCES TAI_LIEU(ma_tai_lieu),
ADD CONSTRAINT fk_ban_sao_khu_vuc FOREIGN KEY (ma_khu_vuc) REFERENCES KHU_VUC(ma_khu_vuc),
ADD CONSTRAINT fk_ban_sao_chi_tiet_phieu_nhap FOREIGN KEY (ma_phieu_nhap_nguon, stt_nhap_nguon) REFERENCES CHI_TIET_PHIEU_NHAP(ma_phieu_nhap, stt);

--   [ ] Khóa ngoại của NHA_CUNG_CAP (xem mục 3.2 báo cáo BTL1)
--   [ ] Khóa ngoại của NCC_SDT (xem mục 3.2 báo cáo BTL1)
ALTER TABLE NCC_SDT
ADD CONSTRAINT fk_ncc_sdt_nha_cung_cap FOREIGN KEY (ma_ncc) REFERENCES NHA_CUNG_CAP(ma_ncc);

--   [ ] Khóa ngoại của PHIEU_NHAP (xem mục 3.2 báo cáo BTL1)
ALTER TABLE PHIEU_NHAP
ADD CONSTRAINT fk_phieu_nhap_nha_cung_cap FOREIGN KEY (ma_ncc) REFERENCES NHA_CUNG_CAP(ma_ncc),
ADD CONSTRAINT fk_phieu_nhap_nhan_vien FOREIGN KEY (ma_nv_lap) REFERENCES NHAN_VIEN(ma_nguoi_dung);



--   [ ] Khóa ngoại của CHI_TIET_PHIEU_NHAP (xem mục 3.2 báo cáo BTL1)
ALTER TABLE CHI_TIET_PHIEU_NHAP
ADD CONSTRAINT fk_chi_tiet_phieu_nhap_phieu_nhap FOREIGN KEY (ma_phieu_nhap) REFERENCES PHIEU_NHAP(ma_phieu_nhap),
ADD CONSTRAINT fk_chi_tiet_phieu_nhap_tai_lieu FOREIGN KEY (ma_tai_lieu) REFERENCES TAI_LIEU(ma_tai_lieu);

