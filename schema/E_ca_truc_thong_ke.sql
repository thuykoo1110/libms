
CREATE TABLE CA_TRUC (
    ma_ca           VARCHAR(10) NOT NULL,
    ten_ca          VARCHAR(20) NOT NULL,
    ngay_truc       DATE        NOT NULL,
    gio_bat_dau     TIME        NOT NULL,
    gio_ket_thuc    TIME        NOT NULL,
    CONSTRAINT pk_ca_truc PRIMARY KEY (ma_ca),
    CONSTRAINT uq_ca_truc_ten_ca_ngay_truc UNIQUE (ten_ca, ngay_truc),
    CONSTRAINT chk_ca_truc_ten_ca CHECK (ten_ca IN ('sáng','chiều','tối')),
    CONSTRAINT chk_ca_truc_gio CHECK (gio_ket_thuc > gio_bat_dau)
) ENGINE = InnoDB;
  


CREATE TABLE PHAN_CONG (
    ma_nv           VARCHAR(10) NOT NULL,
    ma_ca           VARCHAR(10) NOT NULL,
    ma_khu_vuc      VARCHAR(10) NOT NULL,
    ghi_chu         VARCHAR(255) NULL,

    CONSTRAINT pk_phan_cong PRIMARY KEY (ma_nv, ma_ca, ma_khu_vuc)
) ENGINE = InnoDB;
