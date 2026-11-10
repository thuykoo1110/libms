
USE libms;
GO
 
-- NGUOI_DUNG 
create table NGUOI_DUNG (
    ma_nguoi_dung           varchar(10)     not null,  
    ho                      varchar(50)     not null,  
    ten_dem                 varchar(50)     null,       
    ten                     varchar(50)     not null,  
    gioi_tinh               varchar(20)     null,      
    ngay_sinh               date            null,       
    email                   varchar(100)    not null,  
    ten_dang_nhap           varchar(50)     not null,   
    mat_khau_ma_hoa         varchar(255)    not null,   
    trang_thai_tai_khoan    varchar(20)     not null    
        constraint df_nguoi_dung_trang_thai default 'hoat_dong',
 
    constraint pk_ma_nguoi_dung primary key (ma_nguoi_dung),
    constraint uq_nguoi_dung_email unique (email),
    constraint uq_nguoi_dung_ten_dang_nhap unique (ten_dang_nhap),
    constraint chk_nguoi_dung_gioi_tinh check (gioi_tinh in ('nam', 'nu')),
    constraint chk_nguoi_dung_trang_thai_tai_khoan
        check (trang_thai_tai_khoan in ('hoat_dong', 'khoa'))
);
 
-- NGUOI_DUNG_SDT 
create table NGUOI_DUNG_SDT (
    ma_nguoi_dung   varchar(10)     not null,   -- D_MA_ND
    so_dien_thoai   varchar(16)     not null,   -- D_SDT
    constraint pk_nguoi_dung_sdt primary key (ma_nguoi_dung, so_dien_thoai),

    constraint chk_nguoi_dung_sdt_dinh_dang check (
        (  
            so_dien_thoai not like '%[^0-9]%'
            and len(so_dien_thoai) between 8 and 15
        )
        or
        (   
            so_dien_thoai like '+%'  -- VD: +84...
            and substring(so_dien_thoai, 2, 16) not like '%[^0-9]%'
            and len(so_dien_thoai) between 9 and 16
        )
    )
);
 
-- DIA_CHI_LIEN_HE 
create table DIA_CHI_LIEN_HE (
    ma_nguoi_dung   varchar(10)     not null,   -- D_MA_ND
    loai_dia_chi    varchar(20)     not null,   -- D_TRANG_THAI (LOAI_DIA_CHI)
    so_nha          varchar(20)     not null,   -- D_SO_NHA
    duong           varchar(100)    not null,   -- D_DUONG
    phuong_xa       varchar(100)    not null,   -- D_PHUONG_XA
    tinh_thanh      varchar(50)     not null,   -- D_TINH_THANH
    constraint pk_dia_chi_lien_he
        primary key (ma_nguoi_dung, loai_dia_chi, so_nha, duong, phuong_xa, tinh_thanh),
    constraint chk_dia_chi_lien_he_local
        check (loai_dia_chi in ('thuong_tru', 'tam_tru'))
);
 
-- DOC_GIA 
create table DOC_GIA (
    ma_nguoi_dung   varchar(10)     not null,   -- D_MA_ND
    ngay_dang_ky    date            not null,   -- D_NGAY
    constraint pk_doc_gia primary key (ma_nguoi_dung)
);
 
-- SINH_VIEN
create table SINH_VIEN (
    ma_nguoi_dung   varchar(10)     not null,   -- D_MA_ND
    mssv            varchar(20)     not null,   -- D_MA_NGHIEP_VU
    khoa            varchar(150)    null,       -- D_TEN
    lop             varchar(30)     null,       -- D_CHUOI_NGAN
    nien_khoa       varchar(30)     null,       -- D_CHUOI_NGAN
    constraint pk_sinh_vien primary key (ma_nguoi_dung),
    constraint uq_sinh_vien_mssv unique (mssv)
);
 
-- GIANG_VIEN
create table GIANG_VIEN (
    ma_nguoi_dung   varchar(10)     not null,   -- D_MA_ND
    ma_giang_vien   varchar(20)     not null,   -- D_MA_NGHIEP_VU
    bo_mon          varchar(150)    null,       -- D_TEN
    hoc_vi          varchar(20)     null,       -- D_TRANG_THAI (HOC_VI)
    constraint pk_giang_vien primary key (ma_nguoi_dung),
    constraint uq_giang_vien_ma_giang_vien unique (ma_giang_vien),
    constraint chk_giang_vien_hoc_vi
        check (hoc_vi in ('cu_nhan', 'ky_su', 'thac_si', 'tien_si'))
);
 
-- NHAN_VIEN_KHAC (lớp con của DOC_GIA, trước đây là CAN_BO_TRUONG)
create table NHAN_VIEN_KHAC (
    ma_nguoi_dung   varchar(10)     not null,   -- D_MA_ND
    ma_nhan_vien_khac varchar(20)   not null,   -- D_MA_NGHIEP_VU
    don_vi_cong_tac varchar(150)    null,       -- D_TEN
    constraint pk_nhan_vien_khac primary key (ma_nguoi_dung),
    constraint uq_nhan_vien_khac_ma_nhan_vien_khac unique (ma_nhan_vien_khac)
);
 
-- NHAN_VIEN
create table NHAN_VIEN (
    ma_nguoi_dung       varchar(10)     not null,   -- D_MA_ND
    ma_nhan_vien        varchar(20)     not null,   -- D_MA_NGHIEP_VU
    ngay_vao_lam        date            not null,   -- D_NGAY
    chuc_vu             varchar(20)     not null,   -- D_TRANG_THAI (CHUC_VU)
    luong_co_ban        decimal(12,0)   null,       -- D_TIEN
    trang_thai_lam_viec varchar(20)     not null    -- D_TRANG_THAI (TT_LAM_VIEC)
        constraint df_nhan_vien_trang_thai default 'dang_lam',
    ma_nguoi_quan_ly    varchar(10)     null,       -- D_MA_ND
 
    constraint pk_nhan_vien primary key (ma_nguoi_dung),
    constraint uq_nhan_vien_ma_nhan_vien unique (ma_nhan_vien),
    constraint chk_nhan_vien_chuc_vu
        check (chuc_vu in ('can_bo_thu_vien', 'quan_tri_vien')),
    constraint chk_nhan_vien_trang_thai_lam_viec
        check (trang_thai_lam_viec in ('dang_lam', 'nghi_viec')),
    constraint chk_nhan_vien_luong_khong_am     
        check (luong_co_ban >= 0),
    constraint chk_nhan_vien_khong_tu_quan_ly   -- nhân viên không tự quản lý mình
        check (ma_nguoi_quan_ly <> ma_nguoi_dung)
);
 
-- THE_THU_VIEN
create table THE_THU_VIEN (
    so_the          varchar(20)     not null,   -- D_MA_NGHIEP_VU
    ngay_cap        date            not null,   -- D_NGAY
    ngay_het_han    date            not null,   -- D_NGAY
    trang_thai      varchar(20)     not null,   -- D_TRANG_THAI (TT_THE)
    ma_doc_gia      varchar(10)     not null,   -- D_MA_ND
    constraint pk_the_thu_vien primary key (so_the),
    constraint uq_the_thu_vien_ma_doc_gia unique (ma_doc_gia),
    constraint chk_the_thu_vien_trang_thai
        check (trang_thai in ('hoat_dong', 'khoa', 'bao_mat')),
    constraint chk_the_thu_vien_het_han_sau_cap     -- BR03
        check (ngay_cap < ngay_het_han)
);
 
-- THAM_SO_HE_THONG (bảng cấu hình độc lập)
create table THAM_SO_HE_THONG (
    ma_tham_so      varchar(30)     not null,   -- D_MA_THAM_SO
    pham_vi_ap_dung varchar(20)     not null,   -- D_TRANG_THAI (PHAM_VI)
    gia_tri         varchar(20)     not null,   -- D_GIA_TRI_TS (V1)
    don_vi          varchar(30)     null,       -- D_CHUOI_NGAN
    mo_ta           varchar(255)    null,       -- D_GHI_CHU
    constraint pk_tham_so_he_thong primary key (ma_tham_so, pham_vi_ap_dung),
    constraint chk_tham_so_pham_vi
        check (pham_vi_ap_dung in ('sinh_vien', 'giang_vien', 'nhan_vien_khac',
                                   'ca_sang', 'ca_chieu', 'ca_toi', 'tat_ca')),

    constraint chk_tham_so_dinh_dang check (
        (  
            len(gia_tri) > 0
            and gia_tri not like '%[^0-9.]%'
            and gia_tri not like '%.%.%'
            and gia_tri not like '.%'
            and gia_tri not like '%.'
        )
        
        or gia_tri like '[0-9][0-9]:[0-9][0-9]'
        or gia_tri like '[0-9][0-9]:[0-9][0-9]:[0-9][0-9]'
    ),

    constraint chk_tham_so_ty_le_phat_mat check (
        ma_tham_so <> 'TY_LE_PHAT_MAT'
        or isnull(try_cast(gia_tri as decimal(12,2)), 0) >= 100
    )
);
GO