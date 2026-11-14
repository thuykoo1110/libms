USE libms;

-- 1. Dữ liệu mẫu cho bảng PHIEU_MUON (Khoảng mã: PM001 - PM007)
-- Tham chiếu ma_doc_gia từ mảng A (ND011 - ND017) và ma_nv_xu_ly từ NHAN_VIEN (NV003, NV004)[cite: 5, 9]
INSERT INTO PHIEU_MUON (ma_phieu_muon, ngay_muon, ghi_chu, ma_doc_gia, ma_nv_xu_ly) VALUES
('PM001', '2026-05-01', 'Mượn sách in - Đang mượn còn hạn', 'ND011', 'NV003'),
('PM002', '2026-04-01', 'Mượn sách in - Đang quá hạn', 'ND012', 'NV003'),
('PM003', '2026-04-10', 'Mượn giáo trình - Đã trả đúng hạn', 'ND013', 'NV004'),
('PM004', '2026-03-15', 'Mượn giáo trình - Trả trễ hạn', 'ND014', 'NV004'),
('PM005', '2026-03-20', 'Mượn sách in - Trả bị hư hỏng', 'ND015', 'NV005'),
('PM006', '2026-03-01', 'Mượn sách in - Báo mất sách', 'ND016', 'NV005'),
('PM007', '2026-04-05', 'Mượn giáo trình - Đã gia hạn 2 lần', 'ND017', 'NV003');

-- 2. Dữ liệu mẫu cho bảng CHI_TIET_PHIEU_MUON
-- Tham chiếu ma_tai_lieu và so_thu_tu_ban_sao từ bảng BAN_SAO ở mảng B
INSERT INTO CHI_TIET_PHIEU_MUON (ma_phieu_muon, stt, han_tra, ngay_tra_thuc_te, so_lan_gia_han, tinh_trang_khi_tra, ma_tai_lieu, so_thu_tu_ban_sao) VALUES

-- Ca 1: Đang mượn còn hạn 
('PM001', 1, '2026-06-01', NULL, 0, NULL, 'TL001', 1),

-- Ca 2: Đang quá hạn 
('PM002', 1, '2026-04-15', NULL, 0, NULL, 'TL001', 2),

-- Ca 3: Đã trả đúng hạn 
('PM003', 1, '2026-04-25', '2026-04-20', 0, 'binh_thuong', 'TL002', 1),

-- Ca 4: Trả trễ hạn 
('PM004', 1, '2026-03-30', '2026-04-05', 0, 'binh_thuong', 'TL002', 2),

-- Ca 5: Trả bị hư hỏng
('PM005', 1, '2026-04-04', '2026-04-03', 0, 'hu_hong', 'TL001', 4),

-- Ca 6: Báo mất sách
('PM006', 1, '2026-03-15', '2026-03-14', 0, 'mat', 'TL001', 5),

-- Ca 7: Đã gia hạn tối đa 2 lần
('PM007', 1, '2026-05-15', NULL, 2, NULL, 'TL002', 3);


-- 3. KIỂM TRA DỮ LIỆU SAU KHI NẠP
SELECT 'PHIEU_MUON' AS bang, COUNT(*) AS so_dong, 7 AS mong_doi FROM PHIEU_MUON
UNION ALL
SELECT 'CHI_TIET_PHIEU_MUON', COUNT(*), 7 FROM CHI_TIET_PHIEU_MUON;