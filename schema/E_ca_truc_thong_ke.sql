-- =====================================================================
-- LibMS | schema/E_ca_truc_thong_ke.sql
-- Mảng E: Ca trực, thông báo, thống kê
-- Người phụ trách: Lê Quốc Linh
-- Nội dung: CREATE TABLE (PK, UQ, NOT NULL, CHECK một dòng). KHÔNG khai báo FOREIGN KEY ở đây.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] CREATE TABLE CA_TRUC
--   [ ] CREATE TABLE PHAN_CONG
--   [ ] CREATE TABLE THONG_BAO (chỉ khi nhóm chốt S4)

-- CA_TRUC: moi ca truc cu the trong mot ngay
-- BR01: moi cap (ten_ca, ngay_truc) la duy nhat
-- BR03: gio_ket_thuc phai sau gio_bat_dau

CREATE TABLE CA_TRUC (
    ma_ca           VARCHAR(10) NOT NULL,
    ten_ca          VARCHAR(20) NOT NULL,
    ngay_truc       DATE        NOT NULL,
    gio_bat_dau     TIME        NOT NULL,
    gio_ket_thuc    TIME        NOT NULL,
    CONSTRAINT pk_ca_truc PRIMARY KEY (ma_ca),
    CONSTRAINT uq_ca_truc_ten_ca_ngay_truc UNIQUE (ten_ca, ngay_truc),
    CONSTRAINT chk_ca_truc_ten_ca CHECK (ten_ca IN ('sáng','chiều','tối')),
    CONSTRAINT chk_ca_truc_gio CHECK (gio_ket_thuc > gio_bat_dau)
) ENGINE = InnoDB;
  


-- PHAN_CONG: moi bo ba nhan vien/ca/khu vuc la duy nhat
-- BR20: PK ba cot ngan trung bo ba, cac dieu kien nghiep vu con lai
-- duoc xu ly trong sp_phan_cong
CREATE TABLE PHAN_CONG (
    ma_nv           VARCHAR(10) NOT NULL,
    ma_ca           VARCHAR(10) NOT NULL,
    ma_khu_vuc      VARCHAR(10) NOT NULL,
    ghi_chu         VARCHAR(255) NULL,

    CONSTRAINT pk_phan_cong PRIMARY KEY (ma_nv, ma_ca, ma_khu_vuc)
) ENGINE = InnoDB;


-- Đợi chốt S4 để tạo bảng THONG_BAO