-- =====================================================================
-- LibMS | run_all_mysql.sql  (người giữ: Cái Ngọc Phương Thùy)
-- Dựng lại toàn bộ CSDL từ đầu trên MySQL.
-- Chạy bằng terminal tại thư mục gốc repo (MySQL Workbench KHÔNG hỗ trợ SOURCE):
--     mysql -u root -p < run_all_mysql.sql
-- CẢNH BÁO: xóa database libms cũ trước khi tạo lại.
-- =====================================================================

DROP DATABASE IF EXISTS libms;
CREATE DATABASE libms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE libms;

-- 1. Tạo bảng
SOURCE schema/A_nguoi_dung.sql;
SOURCE schema/B_tai_lieu.sql;
SOURCE schema/C_muon_tra.sql;
SOURCE schema/D_dat_truoc_phat.sql;
SOURCE schema/E_ca_truc_thong_ke.sql;

-- 2. Khóa ngoại
SOURCE fk/A_nguoi_dung.sql;
SOURCE fk/B_tai_lieu.sql;
SOURCE fk/C_muon_tra.sql;
SOURCE fk/D_dat_truoc_phat.sql;
SOURCE fk/E_ca_truc_thong_ke.sql;

-- 3. Chỉ mục
SOURCE index/A_nguoi_dung.sql;
SOURCE index/B_tai_lieu.sql;
SOURCE index/C_muon_tra.sql;
SOURCE index/D_dat_truoc_phat.sql;
SOURCE index/E_ca_truc_thong_ke.sql;

-- 4. Dữ liệu mẫu (thứ tự A -> E vì C, D, E tham chiếu dữ liệu của A, B)
SOURCE seed/A_nguoi_dung.sql;
SOURCE seed/B_tai_lieu.sql;
SOURCE seed/C_muon_tra.sql;
SOURCE seed/D_dat_truoc_phat.sql;
SOURCE seed/E_ca_truc_thong_ke.sql;

-- 5. Hàm
SOURCE functions/A_nguoi_dung.sql;
SOURCE functions/B_tai_lieu.sql;
SOURCE functions/C_muon_tra.sql;
SOURCE functions/D_dat_truoc_phat.sql;
SOURCE functions/E_ca_truc_thong_ke.sql;

-- 6. Thủ tục
SOURCE procedures/A_nguoi_dung.sql;
SOURCE procedures/B_tai_lieu.sql;
SOURCE procedures/C_muon_tra.sql;
SOURCE procedures/D_dat_truoc_phat.sql;
SOURCE procedures/E_ca_truc_thong_ke.sql;

-- 7. Trigger
SOURCE triggers/A_nguoi_dung.sql;
SOURCE triggers/B_tai_lieu.sql;
SOURCE triggers/C_muon_tra.sql;
SOURCE triggers/D_dat_truoc_phat.sql;
SOURCE triggers/E_ca_truc_thong_ke.sql;
