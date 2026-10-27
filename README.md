# LibMS – BTL2 Hệ cơ sở dữ liệu (HK261, lớp L09)

**Nguyên tắc quan trọng nhất:** các file `.sql` trong repo này là bản gốc, không phải database. Mỗi người tự cài hệ quản trị trên máy và chạy `run_all` để có database giống hệt nhau. Không ai sửa bảng trực tiếp bằng giao diện (Workbench, pgAdmin), vì sửa kiểu đó không để lại dấu vết và máy người khác không có thay đổi.

## Mốc thời gian

| Ngày | Việc |
|---|---|
| 2/11 | Khóa schema: thư mục `schema/` và `fk/` chạy được trên database trống. Sau ngày này, muốn đổi bảng phải báo cả nhóm |
| 8/11 | Xong bản đầu của `seed/`, `functions/`, `procedures/`, `triggers/`, `queries/` |
| 13/11 | Chạy toàn bộ từ database trống không lỗi, review chéo xong |
| **16/11** | **Nộp và trình bày đợt 1** (bảng, dữ liệu, truy vấn, thủ tục) |
| **30/11** | **Nộp và demo đợt 2** (ứng dụng kết nối CSDL) |

## Phân công theo mảng

Mỗi người giữ **một mảng**. Trong mỗi thư mục, file của mảng nào có tiền tố của mảng đó (`A_`, `B_`, ...). Danh sách việc cụ thể ghi ở đầu từng file.

| Mảng | Người phụ trách | Bảng | FR |
|---|---|---|---|
| A – Người dùng, thẻ, tham số | Cái Ngọc Phương Thùy | NGUOI_DUNG, NGUOI_DUNG_SDT, DIA_CHI_LIEN_HE, DOC_GIA, SINH_VIEN, GIANG_VIEN, CAN_BO_TRUONG, NHAN_VIEN, THE_THU_VIEN, THAM_SO_HE_THONG | 01–05, 37 |
| B – Tài liệu, bản sao, nhập kho | Châu Mạnh Phát | TAI_LIEU, TAI_LIEU_TU_KHOA, TAC_GIA, VIET, NHA_XUAT_BAN, NXB_SDT, THE_LOAI, THUOC, KHU_VUC, BAN_SAO, NHA_CUNG_CAP, NCC_SDT, PHIEU_NHAP, CHI_TIET_PHIEU_NHAP | 06–08, 23–28, 34–35 |
| C – Mượn, trả, gia hạn | Dương Phúc Tất Nhiên | PHIEU_MUON, CHI_TIET_PHIEU_MUON | 09–14 |
| D – Đặt trước, phạt, đánh giá | Nguyễn Khang Kỳ | DAT_TRUOC, PHIEU_PHAT, DANH_GIA | 15–22 |
| E – Ca trực, thông báo, thống kê | Lê Quốc Linh | CA_TRUC, PHAN_CONG, THONG_BAO | 29–36 |

Thùy còn giữ `run_all_*.sql`, `demo/`, `docs/`, ghép và chạy thử toàn bộ, viết báo cáo.

## Cấu trúc thư mục

```
libms/
├── schema/       CREATE TABLE (PK, UQ, NOT NULL, CHECK). Không khai báo khóa ngoại ở đây
├── fk/           ALTER TABLE ... ADD FOREIGN KEY
├── index/        CREATE INDEX, ghi rõ phục vụ truy vấn nào
├── seed/         INSERT dữ liệu mẫu
├── functions/    hàm (thuộc tính dẫn xuất, giá trị dùng lại)
├── procedures/   thủ tục (logic nghiệp vụ nhiều bước)
├── triggers/     trigger (kiểm tra, giữ bất biến)
├── queries/      truy vấn cho từng FR, chạy riêng khi demo
├── tests/        ca thử: đúng và bị chặn đúng BR, chạy riêng
├── demo/         kịch bản demo tại lớp
├── docs/         ghi chú thiết kế, thay đổi so với BTL1
├── run_all_mysql.sql       dựng lại CSDL từ đầu (MySQL)
└── run_all_postgres.sql    dựng lại CSDL từ đầu (PostgreSQL)
```

**Vì sao tách khóa ngoại ra riêng:** `run_all` tạo hết bảng trước rồi mới thêm khóa ngoại, nên ai viết bảng trước cũng được, không phải lo bảng nào tạo trước.

**Vì sao dữ liệu mẫu chạy trước trigger:** dữ liệu mẫu có cả lịch sử cũ (sách đã mất, phiếu đã thu). Nạp trước trigger thì không bị trigger chặn nhầm. Thủ tục và trigger được kiểm tra riêng bằng `tests/`.

## Hệ quản trị CSDL

- MySQL: `run_all_mysql.sql`

## Cài đặt lần đầu

### 1. Lấy repo về máy

**Cách dễ (không cần dòng lệnh):** cài [GitHub Desktop](https://desktop.github.com/), đăng nhập, chọn **File → Clone repository** rồi chọn `libms`.

**Cách dòng lệnh:**
```bash
git clone https://github.com/thuykoo1110/libms.git
cd libms
```

### 2. Chạy thử

Mở terminal tại thư mục `libms`:

```bash
# MySQL (MySQL Workbench không chạy được lệnh SOURCE, phải dùng terminal)
mysql -u root -p < run_all_mysql.sql

# PostgreSQL (tạo database một lần trước)
createdb -U postgres libms
psql -U postgres -d libms -v ON_ERROR_STOP=1 -f run_all_postgres.sql
```

`run_all` **xóa database cũ rồi tạo lại từ đầu**, nên chạy bao nhiêu lần cũng được.

## Quy trình làm việc mỗi ngày

1. **Pull trước khi làm**: GitHub Desktop bấm **Fetch origin → Pull**, hoặc `git pull`.
2. Sửa **file của mình**.
3. Chạy `run_all` trên máy mình, bảo đảm không lỗi.
4. **Commit**, ghi mảng và việc đã làm:
   ```bash
   git add .
   git commit -m "C: thêm sp_gia_han (BR11)"
   ```
5. **Push**: GitHub Desktop bấm **Push origin**, hoặc `git push`.

Nếu bị báo push lỗi do có người push trước: pull về rồi push lại.

## Quy tắc

1. **Chỉ sửa file của mình.** Thấy lỗi ở file người khác thì nhắn người đó hoặc mở **Issue** trên GitHub.
2. **Giữ đúng tên bảng, tên cột** như báo cáo BTL1 (chữ không dấu, gạch dưới). Không tự đổi tên.
3. **Mỗi hàm, thủ tục, trigger ghi rõ BR nào** trong comment.
4. **BR12 (phân bổ bản sao) chỉ viết một lần** trong `sp_phan_bo_ban_sao` của mảng D. Mảng B, C gọi thủ tục đó, không tự viết lại.
5. **Trigger chỉ kiểm tra và giữ bất biến.** Logic nhiều bước đặt trong thủ tục.

## Quy ước mã dữ liệu mẫu

Mỗi mảng dùng khoảng mã riêng, để khóa chính không trùng và người khác biết mã nào mà tham chiếu.

| Mảng | Khoảng mã |
|---|---|
| A | Người dùng ND001–ND060 (ND001–ND010 là nhân viên), thẻ TH001–TH050 |
| B | Tài liệu TL001–TL040, tác giả TG001–, NXB NXB01–, thể loại TLO01–, khu vực KV01–KV06, NCC NCC01–NCC05, phiếu nhập PN001– |
| C | Phiếu mượn PM001– |
| D | Đặt trước DT001–, phiếu phạt PP001– |
| E | Ca trực CA0001–, thông báo TB0001– |

Mảng A và B nên xong dữ liệu mẫu sớm, vì C, D, E cần mã độc giả, nhân viên và bản sao để viết dữ liệu của mình.

- [ ] Hệ quản trị: MySQL hay PostgreSQL
- [ ] Giá trị liệt kê giữ có dấu (`'hoạt động'`) hay đổi sang mã không dấu (`'hoat_dong'`)
- [ ] S1: nhân viên thư viện mượn sách (đổi chuyên biệt hóa sang chồng lấn) hay ghi vào phạm vi
- [ ] S4: thêm thực thể THONG_BAO hay ghi vào phạm vi
- [ ] S5: phiếu nhập có hình thức biếu tặng, nộp lưu hay ghi vào phạm vi
- [ ] M3: tên cột người ghi nhận trả (`ma_nv_ghi_nhan` hay `ma_nv_nhan_tra`)
