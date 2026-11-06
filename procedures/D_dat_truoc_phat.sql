-- =====================================================================
-- LibMS | procedures/D_dat_truoc_phat.sql
-- Mảng D: Đặt trước, phạt, đánh giá
-- Người phụ trách: Nguyễn Khang Kỳ
-- Nội dung: Thủ tục: logic nghiệp vụ nhiều bước, chạy trong transaction.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] sp_phan_bo_ban_sao   -- BR12, DÙNG CHUNG: B và C gọi, không tự viết lại
--   [ ] sp_dat_truoc         -- FR15 (BR13)
--   [ ] sp_huy_dat_truoc     -- FR16
--   [ ] sp_het_han_giu_cho   -- FR17, chạy định kỳ (BR14)
--   [ ] sp_lap_phieu_phat    -- FR18 (BR15, BR16, BR27)
--   [ ] sp_thu_phat          -- FR19 (BR17, BR30, BR34)
--   [ ] sp_huy_phieu_phat    -- S2: chỉ hủy phiếu chưa thu
--   [ ] sp_danh_gia          -- FR21 (BR18)

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_d_kiem_tra_nhan_vien$$
CREATE PROCEDURE sp_d_kiem_tra_nhan_vien(IN p_ma_nv VARCHAR(10))
BEGIN
 IF NOT EXISTS(SELECT 1 FROM NHAN_VIEN WHERE ma_nguoi_dung=p_ma_nv AND trang_thai_lam_viec='đang làm') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR21: Nhan vien phai dang lam';
 END IF;
END$$
DROP PROCEDURE IF EXISTS sp_d_kiem_tra_doc_gia$$
CREATE PROCEDURE sp_d_kiem_tra_doc_gia(IN p_ma VARCHAR(10))
BEGIN
 DECLARE v_nguong DECIMAL(18,4);
 IF NOT EXISTS(SELECT 1 FROM DOC_GIA d JOIN NGUOI_DUNG n ON n.ma_nguoi_dung=d.ma_nguoi_dung
 JOIN THE_THU_VIEN t ON t.ma_doc_gia=d.ma_nguoi_dung
 WHERE d.ma_nguoi_dung=p_ma AND n.trang_thai_tai_khoan='hoạt động' AND t.trang_thai='hoạt động'
 AND t.ngay_cap<=CURDATE() AND t.ngay_het_han>=CURDATE()) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR05: The/tai khoan khong hop le';
 END IF;
 SET v_nguong=fn_d_tham_so_so('NGUONG_NO_PHAT');
 IF EXISTS(SELECT 1 FROM PHIEU_MUON pm JOIN CHI_TIET_PHIEU_MUON ct ON ct.ma_phieu_muon=pm.ma_phieu_muon
 WHERE pm.ma_doc_gia=p_ma AND ct.ngay_tra_thuc_te IS NULL AND ct.han_tra<CURDATE())
 OR fn_tong_no_phat(p_ma)>v_nguong THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR10: Con sach qua han hoac no phat vuot nguong';
 END IF;
END$$
-- BR12: p_thoi_diem=NULL dùng NOW(); ngày giả định được truyền từ thủ tục hết hạn.
-- B/C đặt bản sao về 'sẵn sàng' trước CALL trong cùng transaction (không gọi từ trigger BAN_SAO).
-- Không SELECT trả result set, không transaction control, không đọc/sửa CHI_TIET_PHIEU_MUON.
DROP PROCEDURE IF EXISTS sp_phan_bo_ban_sao$$
CREATE PROCEDURE sp_phan_bo_ban_sao(IN p_ma_tai_lieu VARCHAR(10), IN p_stt SMALLINT, IN p_thoi_diem DATETIME)
main: BEGIN
 DECLARE v_tl VARCHAR(10); DECLARE v_state VARCHAR(20); DECLARE v_khu VARCHAR(20);
 DECLARE v_pv VARCHAR(20); DECLARE v_dt VARCHAR(10); DECLARE v_ngay DATETIME;
 DECLARE v_now DATETIME; DECLARE v_days DECIMAL(18,4);
 SET v_now=COALESCE(p_thoi_diem,NOW());
 SELECT ma_tai_lieu,trang_thai_phuc_vu INTO v_tl,v_pv FROM TAI_LIEU WHERE ma_tai_lieu=p_ma_tai_lieu FOR UPDATE;
 IF v_tl IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Tai lieu khong ton tai'; END IF;
 SELECT b.tinh_trang,k.loai_khu_vuc INTO v_state,v_khu FROM BAN_SAO b JOIN KHU_VUC k ON k.ma_khu_vuc=b.ma_khu_vuc
 WHERE b.ma_tai_lieu=p_ma_tai_lieu AND b.so_thu_tu_ban_sao=p_stt FOR UPDATE;
 IF v_state IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Ban sao khong ton tai'; END IF;
 IF EXISTS(SELECT 1 FROM DAT_TRUOC WHERE ma_tai_lieu_giu_cho=p_ma_tai_lieu AND so_thu_tu_giu_cho=p_stt AND trang_thai='sẵn sàng nhận') THEN
  IF v_state<>'đang giữ chỗ' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR30: Ban sao va yeu cau giu cho khong khop'; END IF;
  LEAVE main;
 END IF;
 IF v_state NOT IN ('sẵn sàng','đang giữ chỗ') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR12: Ben goi phai giai phong ban sao truoc phan bo';
 END IF;
 -- Chuẩn hóa qua 'sẵn sàng' để tương thích BR36 của B.
 IF v_state='đang giữ chỗ' THEN
  UPDATE BAN_SAO SET tinh_trang='sẵn sàng' WHERE ma_tai_lieu=p_ma_tai_lieu AND so_thu_tu_ban_sao=p_stt;
 END IF;
 IF v_khu<>'mượn về' OR v_pv<>'đang phục vụ' THEN LEAVE main; END IF;
 BEGIN
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_dt=NULL;
  SELECT ma_dat_truoc,ngay_dat INTO v_dt,v_ngay FROM DAT_TRUOC
  WHERE ma_tai_lieu=p_ma_tai_lieu AND trang_thai='đang chờ'
  ORDER BY ngay_dat,ma_dat_truoc LIMIT 1 FOR UPDATE;
 END;
 IF v_dt IS NOT NULL THEN
  SET v_days=fn_d_tham_so_so('SO_NGAY_GIU_CHO');
  IF v_days<=0 OR v_days<>FLOOR(v_days) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR28: So ngay giu cho phai nguyen duong'; END IF;
  IF v_now<v_ngay THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR03: Ngay phan bo truoc ngay dat'; END IF;
  UPDATE DAT_TRUOC SET trang_thai='sẵn sàng nhận',han_nhan=DATE_ADD(v_now,INTERVAL v_days DAY),
   ma_tai_lieu_giu_cho=p_ma_tai_lieu,so_thu_tu_giu_cho=p_stt WHERE ma_dat_truoc=v_dt;
  UPDATE BAN_SAO SET tinh_trang='đang giữ chỗ' WHERE ma_tai_lieu=p_ma_tai_lieu AND so_thu_tu_ban_sao=p_stt;
 END IF;
END$$
-- FR15/M03; BR05,10,13. Không kiểm tra hạn mức BR06.
-- Mã DT do ứng dụng/bên gọi cấp; PK chặn trùng, không dùng MAX+1.
DROP PROCEDURE IF EXISTS sp_dat_truoc$$
CREATE PROCEDURE sp_dat_truoc(IN p_ma_dat_truoc VARCHAR(10),IN p_ma_doc_gia VARCHAR(10),IN p_ma_tai_lieu VARCHAR(10))
BEGIN
 DECLARE v_tl VARCHAR(10); DECLARE v_dg VARCHAR(10); DECLARE v_loai VARCHAR(20); DECLARE v_state VARCHAR(20);
 SELECT ma_tai_lieu,loai_tai_lieu,trang_thai_phuc_vu INTO v_tl,v_loai,v_state FROM TAI_LIEU WHERE ma_tai_lieu=p_ma_tai_lieu FOR UPDATE;
 SELECT ma_nguoi_dung INTO v_dg FROM DOC_GIA WHERE ma_nguoi_dung=p_ma_doc_gia FOR UPDATE;
 IF p_ma_dat_truoc IS NULL OR TRIM(p_ma_dat_truoc)='' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Ma dat truoc khong duoc rong'; END IF;
 IF v_tl IS NULL OR v_dg IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Tai lieu/doc gia khong ton tai'; END IF;
 CALL sp_d_kiem_tra_doc_gia(p_ma_doc_gia);
 IF v_loai='e-book' OR v_state<>'đang phục vụ' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR13: Tai lieu khong cho dat truoc'; END IF;
 IF EXISTS(SELECT 1 FROM DAT_TRUOC WHERE ma_doc_gia=p_ma_doc_gia AND ma_tai_lieu=p_ma_tai_lieu AND trang_thai IN ('đang chờ','sẵn sàng nhận')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR13: Da co yeu cau con hieu luc';
 END IF;
 IF EXISTS(SELECT 1 FROM PHIEU_MUON pm JOIN CHI_TIET_PHIEU_MUON ct ON ct.ma_phieu_muon=pm.ma_phieu_muon
 WHERE pm.ma_doc_gia=p_ma_doc_gia AND ct.ma_tai_lieu=p_ma_tai_lieu AND ct.ngay_tra_thuc_te IS NULL) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR13: Dang muon tai lieu nay';
 END IF;
 IF EXISTS(SELECT 1 FROM BAN_SAO b JOIN KHU_VUC k ON k.ma_khu_vuc=b.ma_khu_vuc
 WHERE b.ma_tai_lieu=p_ma_tai_lieu AND k.loai_khu_vuc='mượn về' AND b.tinh_trang='sẵn sàng') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR13: Van con ban sao kha dung';
 END IF;
 IF NOT EXISTS(SELECT 1 FROM BAN_SAO b JOIN KHU_VUC k ON k.ma_khu_vuc=b.ma_khu_vuc
 WHERE b.ma_tai_lieu=p_ma_tai_lieu AND k.loai_khu_vuc='mượn về' AND b.tinh_trang IN ('sẵn sàng','đang mượn','đang giữ chỗ')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR13: Khong con ban sao luu thong';
 END IF;
 INSERT INTO DAT_TRUOC(ma_dat_truoc,ngay_dat,ma_doc_gia,ma_tai_lieu) VALUES(p_ma_dat_truoc,NOW(),p_ma_doc_gia,p_ma_tai_lieu);
END$$
-- FR16: xác minh chủ yêu cầu. Hủy hệ thống dùng thủ tục riêng bên dưới.
DROP PROCEDURE IF EXISTS sp_huy_dat_truoc$$
CREATE PROCEDURE sp_huy_dat_truoc(IN p_ma_dat_truoc VARCHAR(10),IN p_ma_doc_gia VARCHAR(10))
BEGIN
 DECLARE v_tl VARCHAR(10); DECLARE v_lock VARCHAR(10); DECLARE v_dg VARCHAR(10);
 DECLARE v_stt SMALLINT; DECLARE v_state VARCHAR(20);
 SELECT ma_tai_lieu INTO v_tl FROM DAT_TRUOC WHERE ma_dat_truoc=p_ma_dat_truoc;
 SELECT ma_tai_lieu INTO v_lock FROM TAI_LIEU WHERE ma_tai_lieu=v_tl FOR UPDATE;
 SELECT ma_doc_gia,so_thu_tu_giu_cho,trang_thai INTO v_dg,v_stt,v_state FROM DAT_TRUOC WHERE ma_dat_truoc=p_ma_dat_truoc FOR UPDATE;
 IF v_dg IS NULL OR NOT(v_dg<=>p_ma_doc_gia) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR14: Yeu cau khong thuoc doc gia'; END IF;
 IF v_state NOT IN ('đang chờ','sẵn sàng nhận') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR14: Yeu cau da ket thuc'; END IF;
 UPDATE DAT_TRUOC SET trang_thai='đã hủy' WHERE ma_dat_truoc=p_ma_dat_truoc;
 IF v_state='sẵn sàng nhận' THEN CALL sp_phan_bo_ban_sao(v_tl,v_stt,NULL); END IF;
END$$
-- 2.3 Thủ tục 2, FR17/M05, BR12/14. Đây là thủ tục top-level, KHÔNG gọi trong transaction khác.
DROP PROCEDURE IF EXISTS sp_het_han_giu_cho$$
CREATE PROCEDURE sp_het_han_giu_cho(IN p_ngay_xet DATETIME)
BEGIN
 DECLARE done BOOLEAN DEFAULT FALSE; DECLARE v_dt VARCHAR(10); DECLARE v_tl VARCHAR(10);
 DECLARE v_lock VARCHAR(10); DECLARE v_stt SMALLINT; DECLARE v_state VARCHAR(20); DECLARE v_han DATETIME;
 DECLARE v_result JSON DEFAULT (JSON_ARRAY());
 DECLARE c CURSOR FOR SELECT ma_dat_truoc,ma_tai_lieu FROM DAT_TRUOC
 WHERE trang_thai='sẵn sàng nhận' AND han_nhan<p_ngay_xet ORDER BY ma_tai_lieu,ma_dat_truoc;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 IF p_ngay_xet IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR14: Ngay xet khong duoc NULL'; END IF;
 START TRANSACTION;
 OPEN c;
 expiry_loop: LOOP
  FETCH c INTO v_dt,v_tl;
  IF done THEN LEAVE expiry_loop; END IF;
  SELECT ma_tai_lieu INTO v_lock FROM TAI_LIEU WHERE ma_tai_lieu=v_tl FOR UPDATE;
  SET v_state=NULL;
  BEGIN
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_state=NULL;
   SELECT trang_thai,han_nhan,so_thu_tu_giu_cho INTO v_state,v_han,v_stt FROM DAT_TRUOC WHERE ma_dat_truoc=v_dt FOR UPDATE;
  END;
  -- Recheck sau khóa: không xử lý lại yêu cầu vừa nhận/hủy bởi phiên khác.
  IF v_state='sẵn sàng nhận' AND v_han<p_ngay_xet THEN
   UPDATE DAT_TRUOC SET trang_thai='hết hạn' WHERE ma_dat_truoc=v_dt;
   CALL sp_phan_bo_ban_sao(v_tl,v_stt,p_ngay_xet);
   SET v_result=JSON_ARRAY_APPEND(v_result,'$',JSON_OBJECT('ma_dat_truoc',v_dt,'ma_tai_lieu',v_tl,'so_thu_tu',v_stt,'han_nhan',v_han));
  END IF;
 END LOOP;
 CLOSE c;
 COMMIT;
 SELECT j.* FROM JSON_TABLE(v_result,'$[*]' COLUMNS(
 ma_dat_truoc VARCHAR(10) PATH '$.ma_dat_truoc',ma_tai_lieu VARCHAR(10) PATH '$.ma_tai_lieu',
 so_thu_tu SMALLINT PATH '$.so_thu_tu',han_nhan DATETIME PATH '$.han_nhan')) j;
END$$
-- FR18/M05/M08; BR15/16/27/33. C phải cập nhật dòng trả trước khi CALL trong cùng transaction.
DROP PROCEDURE IF EXISTS sp_lap_phieu_phat$$
CREATE PROCEDURE sp_lap_phieu_phat(IN p_ma_phieu_phat VARCHAR(10),IN p_ma_phieu_muon VARCHAR(10),
 IN p_stt SMALLINT,IN p_loai VARCHAR(20),IN p_muc_hu_hong DECIMAL(12,0),IN p_ma_nv VARCHAR(10))
BEGIN
 DECLARE v_dg VARCHAR(10); DECLARE v_han DATE; DECLARE v_tra DATE; DECLARE v_tt VARCHAR(20);
 DECLARE v_tl VARCHAR(10); DECLARE v_gia DECIMAL(12,0); DECLARE v_rate DECIMAL(18,4);
 DECLARE v_daily DECIMAL(18,4); DECLARE v_late DECIMAL(18,0); DECLARE v_money DECIMAL(18,0);
 DECLARE v_cap DECIMAL(18,0); DECLARE v_other DECIMAL(18,0);
 CALL sp_d_kiem_tra_nhan_vien(p_ma_nv);
 SELECT pm.ma_doc_gia,ct.han_tra,ct.ngay_tra_thuc_te,ct.tinh_trang_khi_tra,ct.ma_tai_lieu
 INTO v_dg,v_han,v_tra,v_tt,v_tl FROM CHI_TIET_PHIEU_MUON ct JOIN PHIEU_MUON pm ON pm.ma_phieu_muon=ct.ma_phieu_muon
 WHERE ct.ma_phieu_muon=p_ma_phieu_muon AND ct.stt=p_stt FOR UPDATE;
 IF v_dg IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Dong muon khong ton tai'; END IF;
 IF v_dg=p_ma_nv THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR34: Khong tu xu ly phat cua minh'; END IF;
 IF v_tra IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR29: Chua tra/bao mat thi chi tinh phat tam'; END IF;
 SELECT gia_bia INTO v_gia FROM TAI_LIEU WHERE ma_tai_lieu=v_tl;
 IF v_gia IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR30: Thieu gia bia'; END IF;
 IF p_loai IS NULL OR p_loai NOT IN ('quá hạn','hư hỏng','mất') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Loai phat khong hop le'; END IF;
 IF p_ma_phieu_phat IS NULL OR TRIM(p_ma_phieu_phat)='' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: Ma phieu phat rong'; END IF;
 IF EXISTS(SELECT 1 FROM PHIEU_PHAT WHERE ma_phieu_muon=p_ma_phieu_muon AND stt_chi_tiet=p_stt AND loai_phat=p_loai) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR27: Dong muon da co phieu cung loai (ke ca da huy)';
 END IF;
 SET v_daily=fn_d_tham_so_so('MUC_PHAT_QUA_HAN');
 SET v_rate=fn_d_tham_so_so('TY_LE_PHAT_MAT');
 IF v_daily<=0 OR v_rate<100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR28: Muc phat/ty le phat mat khong hop le'; END IF;
 SET v_cap=ROUND(v_gia*v_rate/100,0);
 SET v_late=LEAST(GREATEST(DATEDIFF(v_tra,v_han),0)*v_daily,v_gia);
 IF p_loai='mất' THEN
  IF v_tt<>'mất' OR EXISTS(SELECT 1 FROM PHIEU_PHAT WHERE ma_phieu_muon=p_ma_phieu_muon AND stt_chi_tiet=p_stt AND loai_phat IN ('quá hạn','hư hỏng') AND trang_thai<>'đã hủy') THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR27: Mat khong di kem phat qua han/hu hong';
  END IF;
  SET v_money=v_cap;
 ELSE
  IF v_tt='mất' OR EXISTS(SELECT 1 FROM PHIEU_PHAT WHERE ma_phieu_muon=p_ma_phieu_muon AND stt_chi_tiet=p_stt AND loai_phat='mất' AND trang_thai<>'đã hủy') THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR27: Phai huy phieu mat truoc khi lap phat khac';
  END IF;
  IF p_loai='quá hạn' THEN
   IF v_late<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR15: Dong muon khong qua han'; END IF;
   SET v_money=v_late;
   SELECT COALESCE(SUM(so_tien),0) INTO v_other FROM PHIEU_PHAT WHERE ma_phieu_muon=p_ma_phieu_muon AND stt_chi_tiet=p_stt AND loai_phat='hư hỏng' AND trang_thai<>'đã hủy';
   IF v_money+v_other>v_cap THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR16: Tong phat vuot tran; kiem tra phieu hu hong'; END IF;
  ELSE
   IF v_tt<>'hư hỏng' OR p_muc_hu_hong IS NULL OR p_muc_hu_hong<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR16: Tinh trang/muc hu hong khong hop le'; END IF;
   -- Ưu tiên số tiền phiếu quá hạn đã chốt (BR33). Nếu trả trễ, C phải lập quá hạn trước.
   IF v_late>0 AND NOT EXISTS(SELECT 1 FROM PHIEU_PHAT WHERE ma_phieu_muon=p_ma_phieu_muon AND stt_chi_tiet=p_stt AND loai_phat='quá hạn' AND trang_thai<>'đã hủy') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR16: Lap phieu qua han truoc phieu hu hong';
   END IF;
   SELECT COALESCE(SUM(so_tien),0) INTO v_late FROM PHIEU_PHAT WHERE ma_phieu_muon=p_ma_phieu_muon AND stt_chi_tiet=p_stt AND loai_phat='quá hạn' AND trang_thai<>'đã hủy';
   SET v_money=LEAST(p_muc_hu_hong,v_gia,GREATEST(v_cap-v_late,0));
  END IF;
 END IF;
 INSERT INTO PHIEU_PHAT(ma_phieu_phat,loai_phat,so_tien,ngay_lap,ma_phieu_muon,stt_chi_tiet)
 VALUES(p_ma_phieu_phat,p_loai,v_money,CURDATE(),p_ma_phieu_muon,p_stt);
END$$
DROP PROCEDURE IF EXISTS sp_thu_phat$$
CREATE PROCEDURE sp_thu_phat(IN p_ma_phieu_phat VARCHAR(10),IN p_ma_nv VARCHAR(10),IN p_phuong_thuc VARCHAR(20))
BEGIN
 DECLARE v_state VARCHAR(20); DECLARE v_dg VARCHAR(10);
 CALL sp_d_kiem_tra_nhan_vien(p_ma_nv);
 SELECT pp.trang_thai,pm.ma_doc_gia INTO v_state,v_dg FROM PHIEU_PHAT pp JOIN PHIEU_MUON pm ON pm.ma_phieu_muon=pp.ma_phieu_muon
 WHERE pp.ma_phieu_phat=p_ma_phieu_phat FOR UPDATE;
 IF v_state IS NULL OR v_state<>'chưa thu' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR17: Chi thu phieu chua thu'; END IF;
 IF v_dg=p_ma_nv THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR34: Khong tu thu phat cua minh'; END IF;
 IF p_phuong_thuc IS NULL OR p_phuong_thuc NOT IN ('tiền mặt','chuyển khoản') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR30: Phuong thuc thu khong hop le'; END IF;
 UPDATE PHIEU_PHAT SET trang_thai='đã thu',ngay_thu=CURDATE(),ma_nv_thu=p_ma_nv,phuong_thuc_thu=p_phuong_thuc WHERE ma_phieu_phat=p_ma_phieu_phat;
END$$
-- BR35: gọi được từ sp_tim_lai_ban_sao của C, không COMMIT giao dịch bên ngoài.
DROP PROCEDURE IF EXISTS sp_huy_phieu_phat$$
CREATE PROCEDURE sp_huy_phieu_phat(IN p_ma_phieu_phat VARCHAR(10),IN p_ma_nv VARCHAR(10),IN p_ly_do VARCHAR(255))
BEGIN
 DECLARE v_state VARCHAR(20); DECLARE v_dg VARCHAR(10);
 CALL sp_d_kiem_tra_nhan_vien(p_ma_nv);
 SELECT pp.trang_thai,pm.ma_doc_gia INTO v_state,v_dg FROM PHIEU_PHAT pp JOIN PHIEU_MUON pm ON pm.ma_phieu_muon=pp.ma_phieu_muon
 WHERE pp.ma_phieu_phat=p_ma_phieu_phat FOR UPDATE;
 IF v_state IS NULL OR v_state<>'chưa thu' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR35: Chi huy phieu chua thu'; END IF;
 IF v_dg=p_ma_nv THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR34: Khong tu xu ly phat cua minh'; END IF;
 IF p_ly_do IS NULL OR TRIM(p_ly_do)='' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR35: Phai co ly do huy'; END IF;
 UPDATE PHIEU_PHAT SET trang_thai='đã hủy',ly_do_huy=TRIM(p_ly_do) WHERE ma_phieu_phat=p_ma_phieu_phat;
END$$
-- FR21/M03; BR18/26. Upsert một đánh giá/cặp; giữ trạng thái ẩn khi sửa nội dung.
DROP PROCEDURE IF EXISTS sp_danh_gia$$
CREATE PROCEDURE sp_danh_gia(IN p_ma_doc_gia VARCHAR(10),IN p_ma_tai_lieu VARCHAR(10),IN p_so_sao TINYINT,IN p_binh_luan TEXT)
BEGIN
 IF p_so_sao IS NULL OR p_so_sao NOT BETWEEN 1 AND 5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR01: So sao tu 1 den 5'; END IF;
 IF NOT EXISTS(SELECT 1 FROM TAI_LIEU WHERE ma_tai_lieu=p_ma_tai_lieu AND loai_tai_lieu<>'e-book') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR26: Tai lieu khong hop le de danh gia'; END IF;
 IF NOT EXISTS(SELECT 1 FROM PHIEU_MUON pm JOIN CHI_TIET_PHIEU_MUON ct ON ct.ma_phieu_muon=pm.ma_phieu_muon WHERE pm.ma_doc_gia=p_ma_doc_gia AND ct.ma_tai_lieu=p_ma_tai_lieu) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR18: Chi danh gia tai lieu da tung muon'; END IF;
 INSERT INTO DANH_GIA(ma_doc_gia,ma_tai_lieu,so_sao,binh_luan,ngay_danh_gia)
 VALUES(p_ma_doc_gia,p_ma_tai_lieu,p_so_sao,p_binh_luan,CURDATE())
 ON DUPLICATE KEY UPDATE so_sao=p_so_sao,binh_luan=p_binh_luan,ngay_danh_gia=CURDATE();
END$$
-- BR14: hook hệ thống. A gọi sau khóa tài khoản; B gọi sau ngừng phục vụ/mất hết bản lưu thông.
-- Chỉ nhận một bộ lọc. Bên gọi phải khóa tài nguyên nghiệp vụ và dùng chung transaction.
DROP PROCEDURE IF EXISTS sp_d_huy_dat_truoc_he_thong$$
CREATE PROCEDURE sp_d_huy_dat_truoc_he_thong(IN p_ma_doc_gia VARCHAR(10),IN p_ma_tai_lieu VARCHAR(10))
BEGIN
 DECLARE done BOOLEAN DEFAULT FALSE; DECLARE v_tl VARCHAR(10); DECLARE v_dt VARCHAR(10); DECLARE v_lock VARCHAR(10);
 DECLARE v_copies JSON DEFAULT (JSON_ARRAY()); DECLARE v_stt SMALLINT; DECLARE i INT DEFAULT 0;
 DECLARE c CURSOR FOR SELECT DISTINCT ma_tai_lieu FROM DAT_TRUOC
 WHERE trang_thai IN ('đang chờ','sẵn sàng nhận') AND
 ((p_ma_doc_gia IS NOT NULL AND ma_doc_gia=p_ma_doc_gia) OR (p_ma_tai_lieu IS NOT NULL AND ma_tai_lieu=p_ma_tai_lieu))
 ORDER BY ma_tai_lieu;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
 IF (p_ma_doc_gia IS NULL)=(p_ma_tai_lieu IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR14: Truyen dung mot bo loc huy he thong'; END IF;
 IF p_ma_doc_gia IS NOT NULL AND NOT EXISTS(SELECT 1 FROM NGUOI_DUNG WHERE ma_nguoi_dung=p_ma_doc_gia AND trang_thai_tai_khoan='khóa') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR14: Tai khoan chua bi khoa';
 END IF;
 OPEN c;
 title_loop: LOOP
  FETCH c INTO v_tl; IF done THEN LEAVE title_loop; END IF;
  SELECT ma_tai_lieu INTO v_lock FROM TAI_LIEU WHERE ma_tai_lieu=v_tl FOR UPDATE;
  IF p_ma_tai_lieu IS NOT NULL AND EXISTS(SELECT 1 FROM TAI_LIEU WHERE ma_tai_lieu=v_tl AND trang_thai_phuc_vu='đang phục vụ')
   AND EXISTS(SELECT 1 FROM BAN_SAO b JOIN KHU_VUC k ON k.ma_khu_vuc=b.ma_khu_vuc WHERE b.ma_tai_lieu=v_tl AND k.loai_khu_vuc='mượn về' AND b.tinh_trang IN ('sẵn sàng','đang mượn','đang giữ chỗ')) THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR14: Tai lieu van dang luu thong';
  END IF;
  SELECT COALESCE(JSON_ARRAYAGG(so_thu_tu_giu_cho),JSON_ARRAY()) INTO v_copies FROM DAT_TRUOC
  WHERE ma_tai_lieu=v_tl AND trang_thai='sẵn sàng nhận' AND (p_ma_doc_gia IS NULL OR ma_doc_gia=p_ma_doc_gia);
  -- Hủy toàn bộ tập liên quan TRƯỚC khi phân bổ để không chọn lại chính người bị khóa.
  UPDATE DAT_TRUOC SET trang_thai='đã hủy' WHERE ma_tai_lieu=v_tl AND trang_thai IN ('đang chờ','sẵn sàng nhận')
   AND (p_ma_doc_gia IS NULL OR ma_doc_gia=p_ma_doc_gia);
  SET i=0;
  WHILE i<JSON_LENGTH(v_copies) DO
   SET v_stt=CAST(JSON_UNQUOTE(JSON_EXTRACT(v_copies,CONCAT('$[',i,']'))) AS UNSIGNED);
   CALL sp_phan_bo_ban_sao(v_tl,v_stt,NULL);
   SET i=i+1;
  END WHILE;
 END LOOP;
 CLOSE c;
END$$
DELIMITER ;

-- =====================================================================
-- LỊCH TỰ ĐỘNG XÉT HẾT HẠN GIỮ CHỖ (đã gộp từ events/D_dat_truoc_phat.sql)
-- =====================================================================
-- BR14: lịch chạy theo time_zone của session lúc CREATE EVENT.
-- Đặt sau toàn bộ thủ tục D và DELIMITER ;. Tài khoản cài đặt cần quyền EVENT.
DROP EVENT IF EXISTS ev_het_han_giu_cho;
CREATE EVENT ev_het_han_giu_cho
 ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
 ON COMPLETION PRESERVE ENABLE
 DO CALL sp_het_han_giu_cho(NOW());
-- Kiểm tra: SHOW VARIABLES LIKE 'event_scheduler'; SHOW EVENTS;
-- DBA bật event_scheduler nếu đang OFF. File này không đổi cấu hình GLOBAL.
