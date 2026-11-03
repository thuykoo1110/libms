-- =====================================================================
-- LibMS | fk/E_ca_truc_thong_ke.sql
-- Mảng E: Ca trực, thông báo, thống kê
-- Người phụ trách: Lê Quốc Linh
-- Nội dung: ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY cho các bảng của mảng này.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] Khóa ngoại của CA_TRUC (xem mục 3.2 báo cáo BTL1)
--   [ ] Khóa ngoại của PHAN_CONG (xem mục 3.2 báo cáo BTL1)

ALTER TABLE PHAN_CONG
    ADD CONSTRAINT fk_phan_cong_nhan_vien
    FOREIGN KEY (ma_nv)
    REFERENCES NHAN_VIEN (ma_nguoi_dung),
    ADD CONSTRAINT fk_phan_cong_ca_truc
        FOREIGN KEY (ma_ca)
        REFERENCES CA_TRUC (ma_ca),
    ADD CONSTRAINT fk_phan_cong_khu_vuc
        FOREIGN KEY (ma_khu_vuc)
        REFERENCES KHU_VUC (ma_khu_vuc);