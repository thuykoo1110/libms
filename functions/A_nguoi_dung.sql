DELIMITER $$
-- ---------------------------------------------------------------------
-- fn_lay_tham_so: đọc một tham số hệ thống dưới dạng chuỗi.
--   Đầu vào : p_ma_tham_so  (ví dụ 'SO_NGAY_MUON')
--             p_pham_vi     ('sinh viên', 'giảng viên', 'cán bộ',
--                            'ca sáng', 'ca chiều', 'ca tối', 'tất cả')
--   Đầu ra  : gia_tri (VARCHAR); ví dụ ('SO_NGAY_MUON','sinh viên') -> '14'
--   Quy tắc : tìm đúng phạm vi trước; không có thì dùng phạm vi 'tất cả'
--             (tham số chung như MUC_PHAT_QUA_HAN chỉ khai ở 'tất cả').
--             Không có cả hai thì báo lỗi, không trả NULL âm thầm, để
--             thủ tục gọi hàm không tính tiếp với giá trị rỗng.
--   BR liên quan: BR33 (áp dụng cấu hình hiện hành tại thời điểm giao dịch;
--             nơi gọi hàm phải LƯU lại kết quả vào han_tra, so_tien...),
--             BR06, BR07, BR10, BR11, BR14, BR15, BR16, BR20, BR28.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_lay_tham_so$$
CREATE FUNCTION fn_lay_tham_so(p_ma_tham_so VARCHAR(30), p_pham_vi VARCHAR(20))
RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE v_gia_tri VARCHAR(20);

    -- 1. đúng phạm vi được hỏi
    SELECT gia_tri INTO v_gia_tri
    FROM THAM_SO_HE_THONG
    WHERE ma_tham_so = p_ma_tham_so
      AND pham_vi_ap_dung = p_pham_vi
    LIMIT 1;

    -- 2. không có thì tham số chung
    IF v_gia_tri IS NULL THEN
        SELECT gia_tri INTO v_gia_tri
        FROM THAM_SO_HE_THONG
        WHERE ma_tham_so = p_ma_tham_so
          AND pham_vi_ap_dung = 'tất cả'
        LIMIT 1;
    END IF;

    -- 3. không có thì báo lỗi
    IF v_gia_tri IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'BR33: khong tim thay tham so he thong (ma_tham_so, pham_vi_ap_dung)';
    END IF;

    RETURN v_gia_tri;
END$$

-- ---------------------------------------------------------------------
-- fn_lay_tham_so_so: bản trả số của fn_lay_tham_so.
--   Dùng cho tham số kiểu số (hạn mức, số ngày, mức phạt, ngưỡng nợ...).
--   Ví dụ: SELECT fn_lay_tham_so_so('SO_NGAY_MUON', 'giảng viên');  -> 30
--   Không dùng cho GIO_BAT_DAU / GIO_KET_THUC (giá trị dạng HH:MM).
--   BR liên quan: như fn_lay_tham_so.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_lay_tham_so_so$$
CREATE FUNCTION fn_lay_tham_so_so(p_ma_tham_so VARCHAR(30), p_pham_vi VARCHAR(20))
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_gia_tri VARCHAR(20);
    SET v_gia_tri = fn_lay_tham_so(p_ma_tham_so, p_pham_vi);
    IF v_gia_tri NOT REGEXP '^[0-9]+([.][0-9]+)?$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'BR33: tham so khong phai gia tri so, dung fn_lay_tham_so';
    END IF;
    RETURN CAST(v_gia_tri AS DECIMAL(12,2));
END$$

-- ---------------------------------------------------------------------
-- fn_tuoi: tuổi của người dùng tính từ ngay_sinh đến hôm nay.
--   Thuộc tính dẫn xuất /tuoi, không lưu cột (BR25).
--   Trả NULL nếu người dùng không có ngay_sinh hoặc không tồn tại.
--   TIMESTAMPDIFF(YEAR, ...) đã trừ đúng khi chưa tới sinh nhật năm nay.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_tuoi$$
CREATE FUNCTION fn_tuoi(p_ma_nguoi_dung VARCHAR(10))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_ngay_sinh DATE;
    SELECT ngay_sinh INTO v_ngay_sinh
    FROM NGUOI_DUNG
    WHERE ma_nguoi_dung = p_ma_nguoi_dung;
    RETURN TIMESTAMPDIFF(YEAR, v_ngay_sinh, CURDATE());
END$$

-- ---------------------------------------------------------------------
-- fn_tham_nien: số năm làm việc của nhân viên, tính từ ngay_vao_lam.
--   Thuộc tính dẫn xuất /tham_nien, không lưu cột (BR25).
--   Nhân viên đã nghỉ việc: không có ngày nghỉ trong lược đồ nên vẫn tính
--   đến hôm nay; nơi hiển thị nên kèm trang_thai_lam_viec.
--   Trả NULL nếu mã không phải nhân viên.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_tham_nien$$
CREATE FUNCTION fn_tham_nien(p_ma_nguoi_dung VARCHAR(10))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_ngay_vao_lam DATE;
    SELECT ngay_vao_lam INTO v_ngay_vao_lam
    FROM NHAN_VIEN
    WHERE ma_nguoi_dung = p_ma_nguoi_dung;
    RETURN TIMESTAMPDIFF(YEAR, v_ngay_vao_lam, CURDATE());
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Chạy thử (kết quả mong đợi với seed/A_nguoi_dung.sql, ngày 06/11/2026)
-- ---------------------------------------------------------------------
-- SELECT fn_lay_tham_so('SO_NGAY_MUON', 'sinh viên');        -- '14'
-- SELECT fn_lay_tham_so('SO_NGAY_MUON', 'giảng viên');       -- '30'
-- SELECT fn_lay_tham_so('MUC_PHAT_QUA_HAN', 'sinh viên');    -- '2000'  (lùi về 'tất cả')
-- SELECT fn_lay_tham_so_so('NGUONG_NO_PHAT', 'tất cả') + 1;  -- 50001.00
-- SELECT fn_lay_tham_so('GIO_BAT_DAU', 'ca chiều');          -- '12:30'
-- SELECT fn_lay_tham_so('KHONG_CO', 'tất cả');               -- lỗi 45000 'BR33: ...'
-- SELECT fn_tuoi('ND011');                                   -- tuổi của ND011 (sinh 2004-08-09 -> 22)
-- SELECT fn_tham_nien('ND001');                              -- 8 (vào làm 2018-08-15)
-- SELECT fn_tham_nien('ND011');                              -- NULL (không phải nhân viên)
