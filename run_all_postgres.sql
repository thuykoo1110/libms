-- =====================================================================
-- LibMS | run_all_postgres.sql  (người giữ: Cái Ngọc Phương Thùy)
-- Dựng lại toàn bộ CSDL từ đầu trên PostgreSQL.
-- Tạo database một lần:  createdb -U postgres libms
-- Chạy bằng terminal tại thư mục gốc repo:
--     psql -U postgres -d libms -v ON_ERROR_STOP=1 -f run_all_postgres.sql
-- CẢNH BÁO: xóa schema libms cũ trước khi tạo lại.
-- =====================================================================

DROP SCHEMA IF EXISTS libms CASCADE;
CREATE SCHEMA libms;
SET search_path TO libms;

-- 1. Tạo bảng
\ir schema/A_nguoi_dung.sql
\ir schema/B_tai_lieu.sql
\ir schema/C_muon_tra.sql
\ir schema/D_dat_truoc_phat.sql
\ir schema/E_ca_truc_thong_ke.sql

-- 2. Khóa ngoại
\ir fk/A_nguoi_dung.sql
\ir fk/B_tai_lieu.sql
\ir fk/C_muon_tra.sql
\ir fk/D_dat_truoc_phat.sql
\ir fk/E_ca_truc_thong_ke.sql

-- 3. Chỉ mục
\ir index/A_nguoi_dung.sql
\ir index/B_tai_lieu.sql
\ir index/C_muon_tra.sql
\ir index/D_dat_truoc_phat.sql
\ir index/E_ca_truc_thong_ke.sql

-- 4. Dữ liệu mẫu (thứ tự A -> E vì C, D, E tham chiếu dữ liệu của A, B)
\ir seed/A_nguoi_dung.sql
\ir seed/B_tai_lieu.sql
\ir seed/C_muon_tra.sql
\ir seed/D_dat_truoc_phat.sql
\ir seed/E_ca_truc_thong_ke.sql

-- 5. Hàm
\ir functions/A_nguoi_dung.sql
\ir functions/B_tai_lieu.sql
\ir functions/C_muon_tra.sql
\ir functions/D_dat_truoc_phat.sql
\ir functions/E_ca_truc_thong_ke.sql

-- 6. Thủ tục
\ir procedures/A_nguoi_dung.sql
\ir procedures/B_tai_lieu.sql
\ir procedures/C_muon_tra.sql
\ir procedures/D_dat_truoc_phat.sql
\ir procedures/E_ca_truc_thong_ke.sql

-- 7. Trigger
\ir triggers/A_nguoi_dung.sql
\ir triggers/B_tai_lieu.sql
\ir triggers/C_muon_tra.sql
\ir triggers/D_dat_truoc_phat.sql
\ir triggers/E_ca_truc_thong_ke.sql
