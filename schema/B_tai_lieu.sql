CREATE TABLE TAI_LIEU (
    ma_tai_lieu VARCHAR(10),
    isbn VARCHAR(13),
    tieu_de VARCHAR(255) NOT NULL,
    nam_xuat_ban SMALLINT,
    lan_tai_ban SMALLINT,
    so_trang SMALLINT,
    ngon_ngu VARCHAR(30),
    loai_tai_lieu VARCHAR(20) NOT NULL,
    trang_thai_phuc_vu VARCHAR(20) NOT NULL DEFAULT 'đang phục vụ',
    gia_bia DECIMAL(12,0),
    tom_tat TEXT,
    duong_dan_dien_tu VARCHAR(500),
    ma_nxb VARCHAR(10),
    
    CONSTRAINT pk_tai_lieu PRIMARY KEY (ma_tai_lieu),
    CONSTRAINT uq_tai_lieu_isbn UNIQUE (isbn),
    
    CONSTRAINT chk_tai_lieu_lan_tai_ban CHECK (lan_tai_ban >= 1),
    CONSTRAINT chk_tai_lieu_so_trang CHECK (so_trang >= 1),
    CONSTRAINT chk_tai_lieu_loai CHECK (loai_tai_lieu IN ('sách in', 'giáo trình', 'luận văn', 'e-book')),
    CONSTRAINT chk_tai_lieu_trang_thai CHECK (trang_thai_phuc_vu IN ('đang phục vụ', 'ngừng phục vụ')),
    CONSTRAINT chk_tai_lieu_gia_bia CHECK (gia_bia >= 0),
    
    CONSTRAINT chk_tai_lieu_ebook_url CHECK (loai_tai_lieu != 'e-book' OR duong_dan_dien_tu IS NOT NULL),
    CONSTRAINT chk_tai_lieu_nxb CHECK (loai_tai_lieu = 'luận văn' OR ma_nxb IS NOT NULL)
);

CREATE TABLE TAI_LIEU_TU_KHOA (
    ma_tai_lieu VARCHAR(10),
    tu_khoa VARCHAR(100),
    CONSTRAINT pk_tai_lieu_tu_khoa PRIMARY KEY (ma_tai_lieu, tu_khoa)
);

CREATE TABLE TAC_GIA(
    ma_tac_gia VARCHAR(10),
    ho VARCHAR(50),
    ten_dem VARCHAR(50),
    ten VARCHAR(50) NOT NULL,
    quoc_tich VARCHAR(30),
    nam_sinh SMALLINT,
    tieu_su TEXT,
    CONSTRAINT pk_tac_gia PRIMARY KEY (ma_tac_gia)
);

CREATE TABLE VIET(
    ma_tac_gia VARCHAR(10),
    ma_tai_lieu VARCHAR(10),
    vai_tro VARCHAR(20) NOT NULL,
    thu_tu_tac_gia SMALLINT NOT NULL,
    CONSTRAINT pk_viet PRIMARY KEY (ma_tac_gia, ma_tai_lieu),
    CONSTRAINT uq_viet_thu_tu UNIQUE (ma_tai_lieu, thu_tu_tac_gia),
    CONSTRAINT chk_viet_vai_tro CHECK (vai_tro IN ('tác giả chính', 'đồng tác giả', 'chủ biên', 'dịch giả')),
    CONSTRAINT chk_viet_thu_tu CHECK (thu_tu_tac_gia >= 1)
);

CREATE TABLE NHA_XUAT_BAN (
    ma_nxb VARCHAR(10),
    ten_nxb VARCHAR(150) NOT NULL,
    email VARCHAR(100),
    so_nha VARCHAR(20),
    duong VARCHAR(100),
    phuong_xa VARCHAR(100),
    tinh_thanh VARCHAR(50),
    CONSTRAINT pk_nha_xuat_ban PRIMARY KEY (ma_nxb)
);

CREATE TABLE NXB_SDT (
    ma_nxb VARCHAR(10),
    so_dien_thoai VARCHAR(16),
    CONSTRAINT pk_nxb_sdt PRIMARY KEY (ma_nxb, so_dien_thoai)
);

CREATE TABLE THE_LOAI (
    ma_the_loai VARCHAR(10),
    ten_the_loai VARCHAR(150) NOT NULL,
    mo_ta VARCHAR(255),
    ma_the_loai_cha VARCHAR(10),
    CONSTRAINT pk_the_loai PRIMARY KEY (ma_the_loai),
    CONSTRAINT chk_the_loai_cha CHECK (ma_the_loai_cha != ma_the_loai)
);

CREATE TABLE THUOC (
    ma_tai_lieu VARCHAR(10),
    ma_the_loai VARCHAR(10),
    CONSTRAINT pk_thuoc PRIMARY KEY (ma_tai_lieu, ma_the_loai)
);

CREATE TABLE KHU_VUC (
    ma_khu_vuc VARCHAR(10),
    ten_khu_vuc VARCHAR(150) NOT NULL,
    tang TINYINT,
    suc_chua SMALLINT,
    loai_khu_vuc VARCHAR(20) NOT NULL,
    
    CONSTRAINT pk_khu_vuc PRIMARY KEY (ma_khu_vuc),
    CONSTRAINT chk_khu_vuc_suc_chua CHECK (suc_chua >= 0),
    CONSTRAINT chk_khu_vuc_loai CHECK (loai_khu_vuc IN ('đọc tại chỗ', 'mượn về', 'tham khảo', 'luận văn'))
);

CREATE TABLE BAN_SAO (
    ma_tai_lieu VARCHAR(10),
    so_thu_tu_ban_sao SMALLINT,
    tinh_trang VARCHAR(20) NOT NULL,
    ngay_nhap DATE,
    gia_mua DECIMAL(12,0),
    vi_tri_ke VARCHAR(30),
    ma_khu_vuc VARCHAR(10) NOT NULL,
    ma_phieu_nhap_nguon VARCHAR(10),
    stt_nhap_nguon SMALLINT,
    
    CONSTRAINT pk_ban_sao PRIMARY KEY (ma_tai_lieu, so_thu_tu_ban_sao),
    CONSTRAINT chk_ban_sao_stt CHECK (so_thu_tu_ban_sao >= 1),
    CONSTRAINT chk_ban_sao_tinh_trang CHECK (tinh_trang IN ('sẵn sàng', 'đang mượn', 'đang giữ chỗ', 'hư hỏng', 'mất', 'thanh lý')),
    CONSTRAINT chk_ban_sao_gia_mua CHECK (gia_mua >= 0),
    CONSTRAINT chk_ban_sao_stt_nguon CHECK (stt_nhap_nguon >= 1),
    CONSTRAINT chk_ban_sao_nguon CHECK ((ma_phieu_nhap_nguon IS NULL AND stt_nhap_nguon IS NULL) OR (ma_phieu_nhap_nguon IS NOT NULL AND stt_nhap_nguon IS NOT NULL))
);

CREATE TABLE NHA_CUNG_CAP (
    ma_ncc VARCHAR(10),
    ten_ncc VARCHAR(150) NOT NULL,
    ma_so_thue VARCHAR(14) NOT NULL,
    nguoi_lien_he VARCHAR(150),
    email VARCHAR(100),
    so_nha VARCHAR(20),
    duong VARCHAR(100),
    phuong_xa VARCHAR(100),
    tinh_thanh VARCHAR(50),
    trang_thai_hop_tac VARCHAR(20),
    
    CONSTRAINT pk_nha_cung_cap PRIMARY KEY (ma_ncc),
    CONSTRAINT uq_ncc_mst UNIQUE (ma_so_thue),
    CONSTRAINT chk_ncc_trang_thai CHECK (trang_thai_hop_tac IN ('đang hợp tác', 'ngừng hợp tác'))
);


CREATE TABLE NCC_SDT (
    ma_ncc VARCHAR(10),
    so_dien_thoai VARCHAR(16),
    CONSTRAINT pk_ncc_sdt PRIMARY KEY (ma_ncc, so_dien_thoai)
);

CREATE TABLE PHIEU_NHAP (
    ma_phieu_nhap VARCHAR(10),
    ngay_nhap DATE NOT NULL,
    hinh_thuc_nhap VARCHAR(20) NOT NULL DEFAULT 'mua',
    ghi_chu VARCHAR(255),
    ma_ncc VARCHAR(10) NULL,
    ma_nv_lap VARCHAR(10) NOT NULL,
    CONSTRAINT pk_phieu_nhap PRIMARY KEY (ma_phieu_nhap),
    CONSTRAINT chk_phieu_nhap_hinh_thuc
        CHECK (hinh_thuc_nhap IN ('mua', 'biếu tặng', 'nộp lưu chiểu')),
    -- mua thì bắt buộc có nhà cung cấp, biếu tặng/nộp lưu chiểu thì không
    CONSTRAINT chk_phieu_nhap_ncc
        CHECK ((hinh_thuc_nhap = 'mua' AND ma_ncc IS NOT NULL)
            OR (hinh_thuc_nhap <> 'mua' AND ma_ncc IS NULL))
);

CREATE TABLE CHI_TIET_PHIEU_NHAP (
    ma_phieu_nhap VARCHAR(10),
    stt SMALLINT,
    so_luong SMALLINT NOT NULL,
    don_gia DECIMAL(12,0) NOT NULL,
    ma_tai_lieu VARCHAR(10) NOT NULL,
    
    CONSTRAINT pk_ct_phieu_nhap PRIMARY KEY (ma_phieu_nhap, stt),
    CONSTRAINT chk_ctpn_stt CHECK (stt >= 1),
    CONSTRAINT chk_ctpn_so_luong CHECK (so_luong > 0),
    CONSTRAINT chk_ctpn_don_gia CHECK (don_gia >= 0)
);

