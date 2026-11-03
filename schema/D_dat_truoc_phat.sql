-- =====================================================================
-- LibMS | schema/D_dat_truoc_phat.sql
-- Mảng D: Đặt trước, phạt, đánh giá
-- Người phụ trách: Nguyễn Khang Kỳ
-- Nội dung: CREATE TABLE (PK, UQ, NOT NULL, CHECK một dòng). KHÔNG khai báo FOREIGN KEY ở đây.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] CREATE TABLE DAT_TRUOC
--   [ ] CREATE TABLE PHIEU_PHAT
--   [ ] CREATE TABLE DANH_GIA

-- Kế thừa charset/collation database để FK khớp bảng A/B/C.
CREATE TABLE DAT_TRUOC (
 ma_dat_truoc VARCHAR(10) PRIMARY KEY,
 ngay_dat DATETIME NOT NULL,
 trang_thai VARCHAR(20) NOT NULL DEFAULT 'đang chờ',
 han_nhan DATETIME NULL,
 ma_doc_gia VARCHAR(10) NOT NULL,
 ma_tai_lieu VARCHAR(10) NOT NULL,
 ma_tai_lieu_giu_cho VARCHAR(10) NULL,
 so_thu_tu_giu_cho SMALLINT NULL,


 d_doc_gia_hieu_luc VARCHAR(10) GENERATED ALWAYS AS
  (CASE WHEN trang_thai IN ('đang chờ','sẵn sàng nhận') THEN ma_doc_gia ELSE NULL END) VIRTUAL,
 d_ban_sao_hieu_luc SMALLINT GENERATED ALWAYS AS
  (CASE WHEN trang_thai='sẵn sàng nhận' THEN so_thu_tu_giu_cho ELSE NULL END) VIRTUAL,
 CONSTRAINT uq_d_dt_active UNIQUE(ma_tai_lieu,d_doc_gia_hieu_luc),
 CONSTRAINT uq_d_dt_copy UNIQUE(ma_tai_lieu_giu_cho,d_ban_sao_hieu_luc),
 CONSTRAINT chk_d_dt_state CHECK(trang_thai IN ('đang chờ','sẵn sàng nhận','đã nhận','đã hủy','hết hạn')),
 CONSTRAINT chk_d_dt_date CHECK(han_nhan IS NULL OR han_nhan>=ngay_dat),
 CONSTRAINT chk_d_dt_pair CHECK((ma_tai_lieu_giu_cho IS NULL AND so_thu_tu_giu_cho IS NULL)
  OR (ma_tai_lieu_giu_cho IS NOT NULL AND so_thu_tu_giu_cho IS NOT NULL)),
 CONSTRAINT chk_d_dt_title CHECK(ma_tai_lieu_giu_cho IS NULL OR ma_tai_lieu_giu_cho=ma_tai_lieu),
 CONSTRAINT chk_d_dt_stt CHECK(so_thu_tu_giu_cho IS NULL OR so_thu_tu_giu_cho>=1),
 CONSTRAINT chk_d_dt_ready CHECK(trang_thai<>'sẵn sàng nhận' OR
  (han_nhan IS NOT NULL AND ma_tai_lieu_giu_cho IS NOT NULL AND so_thu_tu_giu_cho IS NOT NULL)),
 CONSTRAINT chk_d_dt_wait CHECK(trang_thai<>'đang chờ' OR
  (han_nhan IS NULL AND ma_tai_lieu_giu_cho IS NULL AND so_thu_tu_giu_cho IS NULL))
) ENGINE=InnoDB;
CREATE TABLE PHIEU_PHAT (
 ma_phieu_phat VARCHAR(10) PRIMARY KEY,
 loai_phat VARCHAR(20) NOT NULL,
 so_tien DECIMAL(12,0) NOT NULL,
 ngay_lap DATE NOT NULL,
 trang_thai VARCHAR(20) NOT NULL DEFAULT 'chưa thu',
 ngay_thu DATE NULL,
 phuong_thuc_thu VARCHAR(20) NULL,
 ma_phieu_muon VARCHAR(10) NOT NULL,
 stt_chi_tiet SMALLINT NOT NULL,
 ma_nv_thu VARCHAR(10) NULL,
 ly_do_huy VARCHAR(255) NULL, -- S2: có trong phân công, chưa có ở từ điển gốc
 CONSTRAINT uq_d_pp_type UNIQUE(ma_phieu_muon,stt_chi_tiet,loai_phat),
 CONSTRAINT chk_d_pp_type CHECK(loai_phat IN ('quá hạn','hư hỏng','mất')),
 CONSTRAINT chk_d_pp_money CHECK(so_tien>=0),
 CONSTRAINT chk_d_pp_stt CHECK(stt_chi_tiet>=1),
 CONSTRAINT chk_d_pp_state CHECK(trang_thai IN ('chưa thu','đã thu','đã hủy')),
 CONSTRAINT chk_d_pp_method CHECK(phuong_thuc_thu IS NULL OR phuong_thuc_thu IN ('tiền mặt','chuyển khoản')),
 CONSTRAINT chk_d_pp_date CHECK(ngay_thu IS NULL OR ngay_thu>=ngay_lap),
 CONSTRAINT chk_d_pp_payment CHECK(
  (trang_thai='đã thu' AND ngay_thu IS NOT NULL AND phuong_thuc_thu IS NOT NULL AND ma_nv_thu IS NOT NULL)
  OR (trang_thai IN ('chưa thu','đã hủy') AND ngay_thu IS NULL AND phuong_thuc_thu IS NULL AND ma_nv_thu IS NULL)),
 CONSTRAINT chk_d_pp_cancel CHECK(
  (trang_thai='đã hủy' AND ly_do_huy IS NOT NULL AND CHAR_LENGTH(TRIM(ly_do_huy))>0)
  OR (trang_thai<>'đã hủy' AND ly_do_huy IS NULL))
) ENGINE=InnoDB;
CREATE TABLE DANH_GIA (
 ma_doc_gia VARCHAR(10) NOT NULL,
 ma_tai_lieu VARCHAR(10) NOT NULL,
 so_sao TINYINT NOT NULL,
 binh_luan TEXT NULL,
 ngay_danh_gia DATE NOT NULL,
 trang_thai_hien_thi VARCHAR(20) NOT NULL DEFAULT 'hiện',
 PRIMARY KEY(ma_doc_gia,ma_tai_lieu),
 CONSTRAINT chk_d_dg_star CHECK(so_sao BETWEEN 1 AND 5),
 CONSTRAINT chk_d_dg_state CHECK(trang_thai_hien_thi IN ('hiện','ẩn'))
) ENGINE=InnoDB;
