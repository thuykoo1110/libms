-- =====================================================================
-- LibMS | triggers/D_dat_truoc_phat.sql
-- Mảng D: Đặt trước, phạt, đánh giá
-- Người phụ trách: Nguyễn Khang Kỳ
-- Nội dung: Trigger: chỉ kiểm tra và giữ bất biến, không chứa logic nhiều bước.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] Phiếu phạt đã thu không được sửa so_tien, loai_phat (BR17)
--   [ ] Bản sao 'đang giữ chỗ' khi và chỉ khi có đúng một DAT_TRUOC 'sẵn sàng nhận' trỏ tới (BR30)

DELIMITER $$
DROP TRIGGER IF EXISTS trg_d_pp_bi$$
CREATE TRIGGER trg_d_pp_bi BEFORE INSERT ON PHIEU_PHAT FOR EACH ROW
BEGIN
 IF NEW.trang_thai<>'chưa thu' THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR35: Phieu moi phai chua thu';
 END IF;
END$$
DROP TRIGGER IF EXISTS trg_d_pp_bu$$
CREATE TRIGGER trg_d_pp_bu BEFORE UPDATE ON PHIEU_PHAT FOR EACH ROW
BEGIN
 IF OLD.trang_thai='đã thu' AND
  (NOT(NEW.so_tien<=>OLD.so_tien) OR NOT(NEW.loai_phat<=>OLD.loai_phat)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR17: Khong sua so tien/loai phieu da thu';
 END IF;
 IF OLD.trang_thai IN ('đã thu','đã hủy') AND NOT(NEW.trang_thai<=>OLD.trang_thai) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR35: Trang thai da thu/da huy la ket thuc';
 END IF;
 IF NEW.trang_thai='đã hủy' AND OLD.trang_thai NOT IN ('chưa thu','đã hủy') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR35: Chi huy phieu chua thu';
 END IF;
 -- Không cho chuyển phiếu đã thu sang một khoản nợ/dòng mượn khác.
 IF OLD.trang_thai='đã thu' AND
  (NOT(NEW.ma_phieu_muon<=>OLD.ma_phieu_muon) OR NOT(NEW.stt_chi_tiet<=>OLD.stt_chi_tiet)
   OR NOT(NEW.ma_phieu_phat<=>OLD.ma_phieu_phat) OR NOT(NEW.ngay_lap<=>OLD.ngay_lap)
   OR NOT(NEW.ngay_thu<=>OLD.ngay_thu) OR NOT(NEW.ma_nv_thu<=>OLD.ma_nv_thu)
   OR NOT(NEW.phuong_thuc_thu<=>OLD.phuong_thuc_thu)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR17: Khong thay doi thong tin phieu da thu';
 END IF;
END$$
DROP TRIGGER IF EXISTS trg_d_pp_bd$$
CREATE TRIGGER trg_d_pp_bd BEFORE DELETE ON PHIEU_PHAT FOR EACH ROW
BEGIN
 IF OLD.trang_thai='đã thu' THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='BR19: Khong xoa phieu da thu';
 END IF;
END$$
DELIMITER ;
