-- =====================================================================
-- LibMS | seed/B_tai_lieu.sql
-- Mảng B: Tài liệu, bản sao, nhập kho
-- Người phụ trách: Châu Mạnh Phát
-- Nội dung: INSERT dữ liệu mẫu, chỉ dùng mã trong khoảng của mảng mình.
--
-- Quy tắc: chỉ người phụ trách sửa file này. Thấy lỗi thì nhắn người
-- phụ trách hoặc mở Issue trên GitHub. Giữ đúng tên bảng, tên cột trong
-- báo cáo BTL1. Mỗi hàm, thủ tục, trigger ghi rõ đang hiện thực BR nào.
-- =====================================================================
--
-- Việc cần làm:
--   [ ] Khoảng mã: TL001–TL040, tác giả TG001–, NXB NXB01–, thể loại TLO01–, khu vực KV01–KV06, NCC NCC01–NCC05, phiếu nhập PN001–
--   [ ] Làm sớm sau A. Phủ đủ: sách in, giáo trình, luận văn (ma_nxb NULL), e-book (có đường dẫn, không bản sao); bản sao đủ 6 trạng thái; khu vực đủ 4 loại; thể loại cha-con 3 cấp; tài liệu ngừng phục vụ.


-- =====================================================================
-- 1. THỂ LOẠI (TLO01 - ...)
-- * TLO01, TLO04: Thể loại gốc (ma_the_loai_cha = NULL)
-- * TLO02, TLO05: Thể loại cấp 2
-- * TLO03, TLO06: Thể loại cấp 3
-- =====================================================================
INSERT INTO THE_LOAI (ma_the_loai, ten_the_loai, mo_ta, ma_the_loai_cha) VALUES
('TLO01', 'Khoa học Công nghệ', 'Các tài liệu kỹ thuật và công nghệ', NULL),
('TLO02', 'Công nghệ thông tin', 'Tài liệu chuyên ngành CNTT', 'TLO01'),
('TLO03', 'Kỹ thuật Lập trình', 'Các sách về lập trình goto, có cấu trúc và hướng đối tượng', 'TLO02'),
('TLO04', 'Khoa học Cơ bản', 'Các tài liệu khoa học tự nhiên', NULL),
('TLO05', 'Toán cao cấp', 'Tài liệu các môn toán đại cương', 'TLO04'),
('TLO06', 'Giải tích', 'Các sách về bộ môn giải tích', 'TLO04');

-- =====================================================================
-- 2. NHÀ XUẤT BẢN & SĐT (NXB01 - ...)
-- * NXB01: NXB trong nước
-- * NXB02: NXB trong nước
-- * NXB03: NXB quốc tế
-- =====================================================================
INSERT INTO NHA_XUAT_BAN (ma_nxb, ten_nxb, email, so_nha, duong, phuong_xa, tinh_thanh) VALUES
('NXB01', 'NXB Đại học Quốc gia TP.HCM', 'ttmtien.nxb@vnuhcm.edu.vn', '1', 'Võ Trường Toản', 'Thủ Đức', 'Thành phố Hồ Chí Minh'),
('NXB02', 'NXB Khoa học và Kỹ thuật', 'nhaxuatbankhkt@gmail.com', '70', 'Trần Hưng Đạo', 'Cửa Nam', 'Hà Nội'),
('NXB03', 'Cengage Learning', 'contact@cengage.com', '200', 'Pier 4 Boulevard', 'Boston', 'Massachusetts');

INSERT INTO NXB_SDT (ma_nxb, so_dien_thoai) VALUES
('NXB01', '02862726361'),
('NXB02', '0982435558'),
('NXB03', '18003549706');

-- =====================================================================
-- 3. TÁC GIẢ (TG001 - ...)
-- * TG001, TG002: Tác giả trong nước (nam_sinh NULL)
-- * TG003: Tác giả quốc tế
-- * TG004: Tác giả quốc tế (nam_sinh NULL)
-- * TG005: Tác giả James Stewart
-- =====================================================================
INSERT INTO TAC_GIA (ma_tac_gia, ho, ten_dem, ten, quoc_tich, nam_sinh, tieu_su) VALUES
('TG001', 'Nguyễn', 'Trung', 'Trực', 'Việt Nam', NULL, 'Tác giả sách Kỹ thuật Lập trình'),
('TG002', 'Nguyễn', 'Hoàng', 'Hiếu', 'Việt Nam', NULL, 'Học viên Cao học HCMUT'),
('TG003', 'Elmasri', '', 'Ramez', 'Mỹ', 1950, 'Tác giả sách Fundamentals of Database Systems'),
('TG004', 'Fruton', 'S.', 'Joseph', 'Mỹ', NULL, 'Tác giả sách Molecules and life'),
('TG005', 'Stewart', '', 'James', 'Canada', 1941, 'Giáo sư toán học, tác giả sách Calculus');

-- =====================================================================
-- 4. TÀI LIỆU (TL001 - TL040)
-- * TL001: sách in (trạng thái: đang phục vụ)
-- * TL002: giáo trình
-- * TL003: luận văn (ma_nxb BẮT BUỘC là NULL)
-- * TL004: e-book (BẮT BUỘC có duong_dan_dien_tu) - Dữ liệu thật từ Internet Archive dùng làm minh họa
-- * TL005: sách in (trạng thái: ngừng phục vụ)
-- =====================================================================
INSERT INTO TAI_LIEU (ma_tai_lieu, isbn, tieu_de, nam_xuat_ban, lan_tai_ban, so_trang, ngon_ngu, loai_tai_lieu, trang_thai_phuc_vu, gia_bia, tom_tat, duong_dan_dien_tu, ma_nxb) VALUES
('TL001', 'QP517', 'Molecules and life', 1972, 1, 579, 'Tiếng Anh', 'sách in', 'đang phục vụ', 800000, 'Historical essays on biochemistry', NULL, 'NXB02'),
('TL002', '9786047362844', 'Kỹ thuật Lập trình', 2018, 1, 945, 'Tiếng Việt', 'giáo trình', 'đang phục vụ', 155000, 'Giáo trình chuẩn HCMUT', NULL, 'NXB01'),
('TL003', NULL, 'Giảm vị đắng của dịch thủy phân protein thịt hến (Corbiculidae sp.)', 2025, 1, 123, 'Tiếng Việt', 'luận văn', 'đang phục vụ', 0, 'Nghiên cứu khoa học', NULL, NULL),
('TL004', '9780495841333', 'Calculus, 6E', 2008, 6, 1386, 'English', 'e-book', 'đang phục vụ', 0, 'Custom Edition For Vanderbilt University', 'https://archive.org/details/isbn_9780495841333', 'NXB03'),
('TL005', '9789999999999', 'Sách cũ ngừng lưu hành', 2000, 1, 100, 'Tiếng Việt', 'sách in', 'ngừng phục vụ', 50000, 'Tài liệu đã lỗi thời', NULL, 'NXB01');

-- =====================================================================
-- 5. CÁC BẢNG LIÊN KẾT TÀI LIỆU (VIET, THUOC, TAI_LIEU_TU_KHOA)
-- * Phủ đủ vai trò: 'tác giả chính', 'chủ biên'
-- * Thuộc đủ các thể loại đã tạo
-- * Có từ khóa tương ứng
-- =====================================================================
INSERT INTO VIET (ma_tac_gia, ma_tai_lieu, vai_tro, thu_tu_tac_gia) VALUES
('TG004', 'TL001', 'tác giả chính', 1), 
('TG001', 'TL002', 'chủ biên', 1),
('TG002', 'TL003', 'tác giả chính', 1),
('TG005', 'TL004', 'tác giả chính', 1);

INSERT INTO THUOC (ma_tai_lieu, ma_the_loai) VALUES
('TL001', 'TLO04'),
('TL002', 'TLO03'),
('TL003', 'TLO01'),
('TL004', 'TLO06');

INSERT INTO TAI_LIEU_TU_KHOA (ma_tai_lieu, tu_khoa) VALUES
('TL001', 'Chemistry'),
('TL001', 'Biology'),
('TL002', 'Fundamental programming'), 
('TL003', 'Protein thịt hến'),
('TL004', 'Calculus');

-- =====================================================================
-- 6. KHU VỰC (KV01 - KV06)
-- * Phủ đủ 4 loại khu vực: 'mượn về', 'đọc tại chỗ', 'tham khảo', 'luận văn'
-- =====================================================================
INSERT INTO KHU_VUC (ma_khu_vuc, ten_khu_vuc, tang, suc_chua, loai_khu_vuc) VALUES
('KV01', 'Kho mượn về Sinh viên', 1, 5000, 'mượn về'),
('KV02', 'Phòng đọc tự học', 2, 200, 'đọc tại chỗ'),
('KV03', 'Phòng tài liệu chuyên ngành', 3, 100, 'tham khảo'),
('KV04', 'Kho Lưu chiểu & Luận văn', 4, 500, 'luận văn');

-- =====================================================================
-- 7. NHÀ CUNG CẤP & PHIẾU NHẬP
-- * Phủ 2 trạng thái NCC: 'đang hợp tác', 'ngừng hợp tác'
-- * Phủ 3 hình thức nhập: 'mua' (có NCC), 'nộp lưu chiểu' (không NCC), 'biếu tặng' (không NCC)
-- =====================================================================
INSERT INTO NHA_CUNG_CAP (ma_ncc, ten_ncc, ma_so_thue, nguoi_lien_he, email, so_nha, duong, phuong_xa, tinh_thanh, trang_thai_hop_tac) VALUES
('NCC01', 'Nhà sách Fahasa', '0304201111', 'Nguyễn Văn A', 'contact@fahasa.com', '387', 'Hai Bà Trưng', 'Phường 8, Quận 3', 'TP.HCM', 'đang hợp tác'),
('NCC02', 'Công ty Sách Phương Nam', '0304202222', 'Lê Thị B', 'info@pnc.com.vn', '12', 'Lê Duẩn', 'Bến Nghé, Quận 1', 'TP.HCM', 'ngừng hợp tác');

INSERT INTO NCC_SDT (ma_ncc, so_dien_thoai) VALUES
('NCC01', '1900636467'),
('NCC02', '1900123456');

INSERT INTO PHIEU_NHAP (ma_phieu_nhap, ngay_nhap, hinh_thuc_nhap, ghi_chu, ma_ncc, ma_nv_lap) VALUES
('PN001', '2026-10-01', 'mua', 'Nhập đợt 1', 'NCC01', 'NV001'),
('PN002', '2026-10-15', 'nộp lưu chiểu', 'Sinh viên nộp luận văn', NULL, 'NV001'),
('PN003', '2026-10-20', 'biếu tặng', 'Trường bạn biếu tặng', NULL, 'NV001');

INSERT INTO CHI_TIET_PHIEU_NHAP (ma_phieu_nhap, stt, so_luong, don_gia, ma_tai_lieu) VALUES
('PN001', 1, 5, 800000, 'TL001'),
('PN001', 2, 2, 155000, 'TL002'),
('PN002', 1, 1, 0, 'TL003');

-- =====================================================================
-- 8. BẢN SAO
-- * TL001: Phủ đủ 5 trạng thái ('sẵn sàng', 'đang mượn', 'đang giữ chỗ', 'hư hỏng', 'mất')
-- * TL002: Trạng thái 'thanh lý'
-- * TL003 (Luận văn): Trạng thái 'sẵn sàng', xếp ở khu 'luận văn'
-- * TL004 (E-book): KHÔNG CÓ bản sao
-- =====================================================================
INSERT INTO BAN_SAO (ma_tai_lieu, so_thu_tu_ban_sao, tinh_trang, ngay_nhap, gia_mua, vi_tri_ke, ma_khu_vuc, ma_phieu_nhap_nguon, stt_nhap_nguon) VALUES
('TL001', 1, 'sẵn sàng', '2026-10-01', 800000, 'Kệ A1', 'KV01', 'PN001', 1),
('TL001', 2, 'đang mượn', '2026-10-01', 800000, 'Kệ A1', 'KV01', 'PN001', 1),
('TL001', 3, 'đang giữ chỗ', '2026-10-01', 800000, 'Kệ A1', 'KV01', 'PN001', 1),
('TL001', 4, 'hư hỏng', '2026-10-01', 800000, 'Kệ A1', 'KV01', 'PN001', 1),
('TL001', 5, 'mất', '2026-10-01', 800000, 'Kệ A1', 'KV01', 'PN001', 1),
('TL002', 1, 'thanh lý', '2026-10-01', 155000, 'Kệ B2', 'KV03', 'PN001', 2),
('TL003', 1, 'sẵn sàng', '2026-10-15', 0, 'Kệ LV01', 'KV04', 'PN002', 1);

-- =====================================================================
-- 9. KHU VỰC SOẠN LỆNH TEST LỖI (BẪY NGHIỆP VỤ - CHỈ SOẠN, KHÔNG CHẠY)
-- Hướng dẫn: Bỏ dấu comment (--) khi cần chạy trực tiếp để demo báo lỗi.
-- =====================================================================

-- LỖI 1 (Test BR32 - Trigger): Chèn bản sao Luận văn vào khu 'mượn về' (KV01).
-- INSERT INTO BAN_SAO (ma_tai_lieu, so_thu_tu_ban_sao, tinh_trang, ngay_nhap, gia_mua, vi_tri_ke, ma_khu_vuc, ma_phieu_nhap_nguon, stt_nhap_nguon) VALUES ('TL003', 2, 'sẵn sàng', '2026-10-15', 0, 'Kệ A1', 'KV01', 'PN002', 1);

-- LỖI 2 (Test BR26 - Trigger): Tạo bản sao cho 'e-book' (TL004).
-- INSERT INTO BAN_SAO (ma_tai_lieu, so_thu_tu_ban_sao, tinh_trang, ngay_nhap, gia_mua, vi_tri_ke, ma_khu_vuc, ma_phieu_nhap_nguon, stt_nhap_nguon) VALUES ('TL004', 1, 'sẵn sàng', '2026-10-20', 0, 'Kệ E1', 'KV02', NULL, NULL);

-- LỖI 3 (Test BR26 - Trigger): Nhập kho 'e-book' (TL004) vào CTPN.
-- INSERT INTO CHI_TIET_PHIEU_NHAP (ma_phieu_nhap, stt, so_luong, don_gia, ma_tai_lieu) VALUES ('PN003', 1, 10, 50000, 'TL004');

-- LỖI 4 (Test CHECK chk_phieu_nhap_ncc): Phiếu nhập 'mua' nhưng ma_ncc = NULL.
-- INSERT INTO PHIEU_NHAP (ma_phieu_nhap, ngay_nhap, hinh_thuc_nhap, ghi_chu, ma_ncc, ma_nv_lap) VALUES ('PN004', '2026-10-21', 'mua', 'Lỗi nhập', NULL, 'NV001');

-- LỖI 5 (Test CHECK chk_phieu_nhap_ncc): Phiếu nhập 'biếu tặng' nhưng có ma_ncc.
-- INSERT INTO PHIEU_NHAP (ma_phieu_nhap, ngay_nhap, hinh_thuc_nhap, ghi_chu, ma_ncc, ma_nv_lap) VALUES ('PN005', '2026-10-21', 'biếu tặng', 'Lỗi nhập', 'NCC01', 'NV001');