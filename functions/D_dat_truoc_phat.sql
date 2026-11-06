-- =====================================================================
-- LibMS | functions/D_dat_truoc_phat.sql
-- Mảng D: Đặt trước, phạt, đánh giá
-- Người phụ trách: Nguyễn Khang Kỳ
-- Nội dung: Hàm: tính thuộc tính dẫn xuất và giá trị dùng lại.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] fn_thu_tu_hang_doi(ma_dat_truoc)   -- /thu_tu_hang_doi
--   [ ] fn_tong_no_phat(ma_doc_gia)        -- /tong_no_phat, dùng cho BR10
--   [ ] fn_phat_tam_tinh(ma_doc_gia)       -- phạt tạm tính, chỉ hiển thị (BR29)
--   [ ] fn_diem_danh_gia_tb(ma_tai_lieu)   -- /diem_danh_gia_trung_binh, chỉ đánh giá đang hiện

-- BR28/33: mã tham số phải thống nhất với A; thiếu/sai thì báo lỗi, không âm thầm dùng mặc định.
DELIMITER $$
DROP FUNCTION IF EXISTS fn_d_tham_so_so$$
CREATE FUNCTION fn_d_tham_so_so(p_ma VARCHAR(30)) RETURNS DECIMAL(18,4)
READS SQL DATA
BEGIN
 DECLARE v VARCHAR(20); DECLARE msg VARCHAR(128);
 SELECT MAX(gia_tri) INTO v FROM THAM_SO_HE_THONG WHERE ma_tham_so=p_ma AND pham_vi_ap_dung='tất cả';
 IF v IS NULL OR NOT REGEXP_LIKE(v,'^[0-9]+([.][0-9]+)?$') THEN
  SET msg=CONCAT('BR28: Thieu/sai tham so ',p_ma,' (tat ca)');
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=msg;
 END IF;
 RETURN CAST(v AS DECIMAL(18,4));
END$$
DROP FUNCTION IF EXISTS fn_tong_no_phat$$
CREATE FUNCTION fn_tong_no_phat(p_ma_doc_gia VARCHAR(10)) RETURNS DECIMAL(18,0)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(18,0);
 SELECT COALESCE(SUM(pp.so_tien),0) INTO v FROM PHIEU_PHAT pp
 JOIN PHIEU_MUON pm ON pm.ma_phieu_muon=pp.ma_phieu_muon
 WHERE pm.ma_doc_gia=p_ma_doc_gia AND pp.trang_thai='chưa thu';
 RETURN v;
END$$
-- 2.4 Hàm 1: FR20/M04, FR32/M10; BR15, BR29. Cursor + IF + LOOP.
DROP FUNCTION IF EXISTS fn_phat_tam_tinh$$
CREATE FUNCTION fn_phat_tam_tinh(p_ma_doc_gia VARCHAR(10)) RETURNS DECIMAL(18,0)
READS SQL DATA
BEGIN
 DECLARE done BOOLEAN DEFAULT FALSE;
 DECLARE v_han DATE; DECLARE v_gia DECIMAL(12,0); DECLARE v_muc DECIMAL(18,4);
 DECLARE v_tong DECIMAL(18,0) DEFAULT 0;
 DECLARE c CURSOR FOR
  SELECT ct.han_tra,tl.gia_bia FROM CHI_TIET_PHIEU_MUON ct
  JOIN PHIEU_MUON pm ON pm.ma_phieu_muon=ct.ma_phieu_muon
  JOIN TAI_LIEU tl ON tl.ma_tai_lieu=ct.ma_tai_lieu
  WHERE pm.ma_doc_gia=p_ma_doc_gia AND ct.ngay_tra_thuc_te IS NULL AND ct.han_tra<CURDATE();
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
 IF NOT EXISTS(SELECT 1 FROM DOC_GIA WHERE ma_nguoi_dung=p_ma_doc_gia) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Doc gia khong ton tai';
 END IF;
 SET v_muc=fn_d_tham_so_so('MUC_PHAT_QUA_HAN');
 IF v_muc<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR28: Muc phat phai duong'; END IF;
 OPEN c;
 read_loop: LOOP
  FETCH c INTO v_han,v_gia;
  IF done THEN LEAVE read_loop; END IF;
  IF v_gia IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR30: Tai lieu muon ve thieu gia bia'; END IF;
  SET v_tong=v_tong+LEAST(DATEDIFF(CURDATE(),v_han)*v_muc,v_gia);
 END LOOP;
 CLOSE c;
 RETURN v_tong;
END$$
DROP FUNCTION IF EXISTS fn_thu_tu_hang_doi$$
CREATE FUNCTION fn_thu_tu_hang_doi(p_ma_dat_truoc VARCHAR(10)) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT DEFAULT NULL;
 SELECT COUNT(*) INTO v FROM DAT_TRUOC d JOIN DAT_TRUOC x ON x.ma_dat_truoc=p_ma_dat_truoc
 WHERE x.trang_thai='đang chờ' AND d.trang_thai='đang chờ' AND d.ma_tai_lieu=x.ma_tai_lieu
 AND (d.ngay_dat<x.ngay_dat OR (d.ngay_dat=x.ngay_dat AND d.ma_dat_truoc<=x.ma_dat_truoc));
 RETURN NULLIF(v,0);
END$$
DROP FUNCTION IF EXISTS fn_diem_danh_gia_tb$$
CREATE FUNCTION fn_diem_danh_gia_tb(p_ma_tai_lieu VARCHAR(10)) RETURNS DECIMAL(3,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(3,2);
 SELECT AVG(so_sao) INTO v FROM DANH_GIA WHERE ma_tai_lieu=p_ma_tai_lieu AND trang_thai_hien_thi='hiện';
 RETURN v;
END$$
DELIMITER ;
