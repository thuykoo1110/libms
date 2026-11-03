-- =====================================================================
-- LibMS | schema/C_muon_tra.sql
-- Mảng C: Mượn, trả, gia hạn
-- Người phụ trách: Dương Phúc Tất Nhiên
-- Nội dung: CREATE TABLE (PK, UQ, NOT NULL, CHECK một dòng). KHÔNG khai báo FOREIGN KEY ở đây.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================

-- Việc cần làm:
-- [] CREATE TABLE PHIEU_MUON
-- [] CREATE TABLE CHI_TIET_PHIEU_MUON (thêm cột người ghi nhận trả, M3)

-- 1. Bảng PHIEU_MUON
CREATE TABLE PHIEU_MUON (
    ma_phieu_muon VARCHAR(10) PRIMARY KEY,
    ngay_muon DATE NOT NULL,
    ghi_chu VARCHAR(255),
    ma_doc_gia VARCHAR(10) NOT NULL,
    ma_nv_xu_ly VARCHAR(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng CHI_TIET_PHIEU_MUON
CREATE TABLE CHI_TIET_PHIEU_MUON (
    ma_phieu_muon VARCHAR(10) NOT NULL,
    stt SMALLINT NOT NULL CHECK (stt >= 1),
    han_tra DATE NOT NULL,
    ngay_tra_thuc_te DATE,
    so_lan_gia_han SMALLINT NOT NULL DEFAULT 0 CHECK (so_lan_gia_han >= 0),
    tinh_trang_khi_tra VARCHAR(20),
    ma_tai_lieu VARCHAR(10) NOT NULL,
    so_thu_tu_ban_sao SMALLINT NOT NULL CHECK (so_thu_tu_ban_sao >= 1),
    ma_nv_nhan_tra VARCHAR(10), 
    PRIMARY KEY (ma_phieu_muon, stt),
    CONSTRAINT uq_ctpm_bansao UNIQUE (ma_phieu_muon, ma_tai_lieu, so_thu_tu_ban_sao),
    CHECK (tinh_trang_khi_tra IN ('bình thường', 'hư hỏng', 'mất') OR tinh_trang_khi_tra IS NULL),
    CHECK (
        (ngay_tra_thuc_te IS NULL AND ma_nv_nhan_tra IS NULL AND tinh_trang_khi_tra IS NULL) OR 
        (ngay_tra_thuc_te IS NOT NULL AND ma_nv_nhan_tra IS NOT NULL AND tinh_trang_khi_tra IS NOT NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;