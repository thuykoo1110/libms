create table NGUOI_DUNG (
	ma_nguoi_dung	varchar(10)	not null,
    ho				varchar(50) not null,
    ten_dem	  varchar(50),
    ten				varchar(50) not null,
    gioi_tinh varchar(20) null,
    ngay_sinh date null, 
    email			varchar(100)	not null,
    ten_dang_nhap	varchar(50)	not null,
    mat_khau_ma_hoa varchar(255)  not null,
    trang_thai_tai_khoan	varchar(20)	not null default 'hoạt động',
    
    constraint pk_ma_nguoi_dung primary key (ma_nguoi_dung),
    constraint uq_nguoi_dung_email	unique (email),
    constraint uq_nguoi_dung_ten_dang_nhap UNIQUE (ten_dang_nhap),
    constraint chk_nguoi_dung_gioi_tinh check (gioi_tinh in ('nam', 'nữ')),
    constraint chk_nguoi_dung_trang_thai_tai_khoan check (trang_thai_tai_khoan in ('hoạt động', 'khóa'))
)	engine = InnoDB;


# NGUOI_DUNG_SDT
create table NGUOI_DUNG_SDT (
	ma_nguoi_dung	varchar(10)	not null,
    so_dien_thoai	varchar(16)	not null,
    constraint pk_nguoi_dung_sdt primary key (ma_nguoi_dung, so_dien_thoai),
    constraint chk_nguoi_dung_sdt_dinh_dang check (so_dien_thoai REGEXP '^[+]?[0-9]{8,15}$')
) engine = InnoDB;

# DIA_CHI_LIEN_HE
create table DIA_CHI_LIEN_HE  (
	ma_nguoi_dung	varchar(10)	not null,
    loai_dia_chi	varchar(20)	not null,
    so_nha			varchar(20)	not null,
    duong			varchar(100)	not null,
    phuong_xa		varchar(100)	not null,
    tinh_thanh 		varchar(50)	not null,
    constraint pk_dia_chi_lien_he primary key (ma_nguoi_dung, loai_dia_chi, so_nha, duong, phuong_xa, tinh_thanh),
    constraint chk_dia_chi_lien_he_local check (loai_dia_chi in ('thường trú', 'tạm trú'))
) engine = InnoDB;

# DOC_GIA 
create table DOC_GIA (
	ma_nguoi_dung 	varchar(10)	not null,
    ngay_dang_ky	date	not null,
    constraint pk_doc_gia primary key (ma_nguoi_dung)
) engine = InnoDB;

# SINH_VIEN 
create table SINH_VIEN (
	ma_nguoi_dung	varchar(10)	not null,
    mssv			varchar(20)	not null,
    khoa 			varchar(150)	null,
    lop				varchar(30)	null,
    nien_khoa		varchar(30)	null,
    
    constraint pk_sinh_vien primary key (ma_nguoi_dung),
    constraint uq_sinh_vien_mssv unique (mssv)
) engine = InnoDB;

# GIANG_VIEN
create table GIANG_VIEN(
	ma_nguoi_dung 	varchar(10)	not null,
    ma_giang_vien	varchar(20)	not null,
    bo_mon 			varchar(150)	null,
    hoc_vi			varchar(20)	null,
    
    constraint pk_giang_vien primary key (ma_nguoi_dung),
    constraint uq_giang_vien_ma_giang_vien UNIQUE (ma_giang_vien),
    constraint chk_giang_vien_hoc_vi
        check (hoc_vi in ('cử nhân', 'kỹ sư', 'thạc sĩ', 'tiến sĩ'))
) engine = InnoDB;

# CAN_BO_TRUONG
create table CAN_BO_TRUONG (
	ma_nguoi_dung 	varchar(10)	not null,
    ma_can_bo		varchar(20)	not null,
    don_vi_cong_tac	varchar(150) null,
    
    CONSTRAINT pk_can_bo_truong PRIMARY KEY (ma_nguoi_dung),
    CONSTRAINT uq_can_bo_truong_ma_can_bo UNIQUE (ma_can_bo)          
) ENGINE = InnoDB;

# NHAN_VIEN
create table NHAN_VIEN (
	ma_nguoi_dung 	varchar(10)	not null,
    ma_nhan_vien	varchar(20)	not null,
    ngay_vao_lam	date	not null,
    chuc_vu			varchar(20)	not null,
    luong_co_ban	decimal(12,0)	null,
    trang_thai_lam_viec 	varchar(20)	not null default 'đang làm',
    ma_nguoi_quan_ly		varchar(10)	null,
    
    constraint pk_nhan_vien primary key (ma_nguoi_dung),
    constraint uq_nhan_vien_ma_nhan_vien unique (ma_nhan_vien),
    constraint chk_nhan_vien_chuc_vu 
		check (chuc_vu IN ('cán bộ thư viện', 'quản trị viên')),
	constraint chk_nhan_vien_trang_thai_lam_viec 
		check (trang_thai_lam_viec in  ('đang làm', 'nghỉ việc')),
	constraint chk_nhan_vien_luong_khong_am 
		check (luong_co_ban >= 0),
	constraint chk_nhan_vien_khac_quan_ly  # nhân viên không tự quản lí mik 
		check (ma_nguoi_quan_ly <> ma_nguoi_dung)
) engine = InnoDB;

# THE_THU_VIEN
create table THE_THU_VIEN(
	so_the 	varchar(20)	not null,
    ngay_cap	date	not null,
    ngay_het_han	date	not null,
    trang_thai	varchar(20)	not null,
    ma_doc_gia	varchar(10)	not null,
    
    constraint pk_the_thu_vien primary key (so_the),
    constraint uq_the_thu_vien_ma_doc_gia unique (ma_doc_gia),
    constraint chk_the_thu_vien_trang_thai 
		check (trang_thai in ('hoạt động', 'khóa', 'báo mất')),
	constraint chk_the_thu_vien_het_han_sau_cap
		check (ngay_cap < ngay_het_han)
) engine = InnoDB;

# THAM_SO_HE_THONG
CREATE TABLE THAM_SO_HE_THONG (
    ma_tham_so      VARCHAR(30)   NOT NULL,                           
    pham_vi_ap_dung VARCHAR(20)   NOT NULL,                           
    gia_tri         VARCHAR(20)   NOT NULL,                               
    don_vi          VARCHAR(30)   NULL,                             
    mo_ta           VARCHAR(255)  NULL,                         
    CONSTRAINT pk_tham_so_he_thong PRIMARY KEY (ma_tham_so, pham_vi_ap_dung),
    CONSTRAINT chk_tham_so_pham_vi
        CHECK (pham_vi_ap_dung IN ('sinh viên', 'giảng viên', 'cán bộ',
                                   'ca sáng', 'ca chiều', 'ca tối', 'tất cả')),
    CONSTRAINT chk_tham_so_dinh_dang
        CHECK (gia_tri REGEXP '^[0-9]+([.][0-9]+)?$'
            OR gia_tri REGEXP '^[0-9]{2}:[0-9]{2}(:[0-9]{2})?$'),
    CONSTRAINT chk_tham_so_ty_le_phat_mat                           
        CHECK (ma_tham_so <> 'TY_LE_PHAT_MAT' OR CAST(gia_tri AS DECIMAL(12,2)) >= 100)
) ENGINE = InnoDB;
