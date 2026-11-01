Gửi Nhiên đoạn code SQL hoàn chỉnh cho file **`schema/C_muon_tra.sql`** trong khung mã bên dưới:

```sql
-- =====================================================================
-- LibMS | schema/C_muon_tra.sql
-- Mảng C: Mượn, trả, gia hạn
-- Người phụ trách: Dương Phúc Tất Nhiên
-- Nội dung: CREATE TABLE (PK, UQ, NOT NULL, CHECK). KHÔNG khai báo FOREIGN KEY ở đây.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Bảng PHIEU_MUON (Mục 3.2.3 báo cáo BTL1 & Từ điển dữ liệu)
-- ---------------------------------------------------------------------
CREATE TABLE PHIEU_MUON (
    ma_phieu_muon VARCHAR(10) NOT NULL,
    ngay_muon DATE NOT NULL,
    ghi_chu VARCHAR(255) NULL,
    ma_doc_gia VARCHAR(10) NOT NULL,
    ma_nv_xu_ly VARCHAR(10) NOT NULL,

    PRIMARY KEY (ma_phieu_muon)
);

-- ---------------------------------------------------------------------
-- 2. Bảng CHI_TIET_PHIEU_MUON (Thực thể yếu, bổ sung cột M3)
-- ---------------------------------------------------------------------
CREATE TABLE CHI_TIET_PHIEU_MUON (
    ma_phieu_muon VARCHAR(10) NOT NULL,
    stt SMALLINT NOT NULL,
    han_tra DATE NOT NULL,
    ngay_tra_thuc_te DATE NULL,
    so_lan_gia_han SMALLINT NOT NULL DEFAULT 0,
    tinh_trang_khi_tra VARCHAR(20) NULL,
    ma_tai_lieu VARCHAR(10) NOT NULL,
    so_thu_tu_ban_sao SMALLINT NOT NULL,
    ma_nv_nhan_tra VARCHAR(10) NULL,

    PRIMARY KEY (ma_phieu_muon, stt),

    CONSTRAINT uq_ctpm_ban_sao UNIQUE (ma_phieu_muon, ma_tai_lieu, so_thu_tu_ban_sao),

    CONSTRAINT chk_ctpm_so_lan_gia_han CHECK (so_lan_gia_han >= 0),
    CONSTRAINT chk_ctpm_tinh_trang CHECK (tinh_trang_khi_tra IN ('bình thường', 'hư hỏng', 'mất')),

    CONSTRAINT chk_ctpm_ngay_tra_tinh_trang CHECK (
        (tinh_trang_khi_tra IS NULL AND ngay_tra_thuc_te IS NULL) OR 
        (tinh_trang_khi_tra IS NOT NULL AND ngay_tra_thuc_te IS NOT NULL)
    ),

    CONSTRAINT chk_ctpm_nv_nhan_tra CHECK (
        (ma_nv_nhan_tra IS NULL AND ngay_tra_thuc_te IS NULL) OR 
        (ma_nv_nhan_tra IS NOT NULL AND ngay_tra_thuc_te IS NOT NULL)
    )
);
```