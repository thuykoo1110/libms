# LibMS – BTL2 Hệ cơ sở dữ liệu (HK261, lớp L09)

**Nguyên tắc quan trọng nhất:** các file `.sql` trong repo này là bản gốc, không phải database. Mỗi người tự cài hệ quản trị trên máy và chạy `run_all` để có database giống hệt nhau. Không ai sửa bảng trực tiếp bằng giao diện (Table Designer của SSMS), vì sửa kiểu đó không để lại dấu vết và máy người khác không có thay đổi.

## Mốc thời gian

Cô yêu cầu nộp **cả SQL (Phần 1, 2) và ứng dụng kết nối CSDL** vào **thứ 2, 16/11**. Buổi trình bày rơi vào giờ học sáng thứ 2, nên báo cáo phải in xong và CSDL, ứng dụng phải chạy sẵn trước buổi học.

| Ngày | Việc |
|---|---|
| 2/11 | ✅ Khóa schema: `schema/` và `fk/` chạy được trên database trống. Sau ngày này, muốn đổi bảng phải báo cả nhóm |
| 6/11 | `seed/A_` và `seed/B_` xong, vì C, D, E cần mã độc giả, nhân viên, bản sao |
| 8/11 | Xong bản đầu của `seed/`, `functions/`, `procedures/`, `triggers/`, `queries/`, `index/`. Khung `app/` chạy được |
| 11/11 | Toàn bộ SQL chạy trọn từ database trống không lỗi, mỗi mục có file `tests/` |
| 12–13/11 | Làm màn hình ứng dụng gọi SQL của mảng mình. **13/11 chốt code**, Thùy chạy lại từ đầu, mọi người chụp ảnh từ bản đã ghép |
| 14–15/11 | Viết phần báo cáo của mình, ghép báo cáo, tập hỏi đáp chéo, in |
| **16/11** | **Nộp LMS, trình bày SQL và demo ứng dụng** |

## Tiến độ hiện tại (4/11)

- [x] `schema/`, `fk/`: đủ 31 bảng và khóa ngoại
- [ ] `seed/`
- [ ] `functions/`, `procedures/`, `triggers/`
- [ ] `index/`, `queries/`
- [ ] `tests/`, `demo/`
- [ ] `app/`

## Phân công theo mảng

Mỗi người giữ **một mảng**. Trong mỗi thư mục, file của mảng nào có tiền tố của mảng đó (`A_`, `B_`, ...). Danh sách việc cụ thể ghi ở đầu từng file.

| Mảng | Người phụ trách | Bảng | FR |
|---|---|---|---|
| A – Người dùng, thẻ, tham số | Cái Ngọc Phương Thùy | NGUOI_DUNG, NGUOI_DUNG_SDT, DIA_CHI_LIEN_HE, DOC_GIA, SINH_VIEN, GIANG_VIEN, NHAN_VIEN_KHAC, NHAN_VIEN, THE_THU_VIEN, THAM_SO_HE_THONG | 01–05, 37 |
| B – Tài liệu, bản sao, nhập kho | Châu Mạnh Phát | TAI_LIEU, TAI_LIEU_TU_KHOA, TAC_GIA, VIET, NHA_XUAT_BAN, NXB_SDT, THE_LOAI, THUOC, KHU_VUC, BAN_SAO, NHA_CUNG_CAP, NCC_SDT, PHIEU_NHAP, CHI_TIET_PHIEU_NHAP | 06–08, 23–28, 34–35 |
| C – Mượn, trả, gia hạn | Dương Phúc Tất Nhiên | PHIEU_MUON, CHI_TIET_PHIEU_MUON | 09–14 |
| D – Đặt trước, phạt, đánh giá | Nguyễn Khang Kỳ | DAT_TRUOC, PHIEU_PHAT, DANH_GIA | 15–22 |
| E – Ca trực, thống kê | Lê Quốc Linh | CA_TRUC, PHAN_CONG | 29–36 |

Thùy còn giữ file `run_all` (đang chuyển sang SQL Server), `demo/`, khung `app/`, ghép và chạy thử toàn bộ, viết báo cáo, thuyết trình.

## Hàng trong Bảng kê nhiệm vụ (đề xuất, cả nhóm xác nhận)

Mẫu báo cáo của cô tính điểm từng người theo **các hàng mình đánh dấu trong Bảng kê nhiệm vụ**, mỗi hàng chỉ 1 người làm. Bảng kê chia theo loại việc (bảng, chỉ mục, truy vấn, trigger, thủ tục, hàm), nên phải ánh xạ từ mảng sang hàng:

| Người (mảng) | Hàng trong Bảng kê | Điểm /20 |
|---|---|---|
| Thùy (A) | 1.1.a bảng phần 1 = các bảng mảng A; 2.1 thủ tục INSERT/UPDATE/DELETE trên THAM_SO_HE_THONG (FR37, M11) + demo 2.1; truy vấn GROUP BY thống kê lượt mượn theo đối tượng độc giả (FR36, M10) | 4.0 |
| Phát (B) | 1.1.a bảng phần 2 = các bảng mảng B; 1.1.b trigger kiểm tra BR22, BR26, BR32, BR36; Hàm 2 đếm bản sao khả dụng theo thể loại kể cả thể loại con (FR07, M02); truy vấn tra cứu tài liệu (FR06, M02) | 3.75 |
| Nhiên (C) | 1.1.b CHECK và trigger kiểm tra mảng C (BR30, BR34); Trigger 2 trên CHI_TIET_PHIEU_MUON, ảnh hưởng BAN_SAO và DAT_TRUOC; Thủ tục 1 `sp_lap_phieu_muon` (FR10, M05); truy vấn lịch sử mượn (FR09, M04) | 4.25 |
| Kỳ (D) | Trigger 1 trên PHIEU_PHAT (BR17, BR35); Thủ tục 2 `sp_het_han_giu_cho` (FR17, BR12, BR14, chạy hằng ngày; SQL Server không có EVENT, xem mục Hệ quản trị CSDL); Hàm 1 `fn_phat_tam_tinh` (BR29, M04) | 4.0 |
| Linh (E) | 1.2 chỉ mục + demo chỉ mục; 1.1 demo tạo bảng; truy vấn GROUP BY tiền phạt theo tháng (FR33); truy vấn 2 lồng nhau + hàm gộp (FR31) | 4.0 |

Yêu cầu bắt buộc của cô cho từng loại:

- **Truy vấn (5 câu, trên các bảng khác nhau):** 2 câu SELECT-FROM-WHERE-ORDER BY; 2 câu có thêm GROUP BY + hàm gộp; 1 câu có 2 truy vấn lồng + hàm gộp.
- **Trigger (2):** 1 trigger trên 1 bảng, 1 trigger ảnh hưởng hơn 1 bảng. Trigger chỉ kiểm tra ràng buộc khai được trong CREATE TABLE (UNIQUE, NOT NULL, CHECK) **không được tính điểm**.
- **Thủ tục 2.3 (2) và hàm 2.4 (2):** xử lý dữ liệu từ 1 hay nhiều bảng, **có câu lệnh điều kiện và vòng lặp**.
- **Mỗi mục trong báo cáo:** nói rõ dùng cho FR nào, ở màn hình nào (M01–M12), có flowchart (trừ truy vấn), câu lệnh dạng text, ảnh chụp toàn màn hình DBMS có chú thích, ca lỗi và ca đúng.

Các thủ tục, hàm khác trong danh sách việc của từng file (`sp_ghi_nhan_tra`, `sp_lap_phieu_nhap`, `sp_dang_ky_doc_gia`...) vẫn phải viết vì ứng dụng cần, và có thể đưa vào mục "Phần thêm" của báo cáo.

## Ứng dụng (`app/`)

Code **theo đúng đặc tả giao diện M01–M12 của BTL1** (trường dữ liệu, nút, phần "Khác LibMS"), vì cô đối chiếu demo với mô tả đó. Màn nào có SQL ở trên thì gọi đúng thủ tục, hàm, trigger đó, không viết lại logic trong code.

- **Công nghệ:** Node.js + Express + thư viện `mysql2`, giao diện HTML/EJS đơn giản.
> **Đang chuyển:** khung `app/` hiện viết cho MySQL (`mysql2`, cổng 3306). Thùy đổi `db.js` sang thư viện `mssql` (cổng 1433, tham số dạng `@ten`, lỗi lấy từ `THROW`). Hai dòng dưới đây sẽ cập nhật theo.

- **Kiến trúc:** trình duyệt → Express (route, controller) → connection pool `mysql2` → MySQL. Mọi tham số truyền bằng `?` (chống SQL injection). Lỗi `SIGNAL` từ MySQL hiện nguyên thông báo có mã BR lên màn hình.
- **Thông tin kết nối** để trong `app/.env` (đã có trong `.gitignore`, không commit).

| Màn hình | Mảng | Người | Gọi tới | Ưu tiên |
|---|---|---|---|---|
| Khung dự án, `db.js`, layout | A | Thùy | | Bắt buộc |
| M01 Đăng nhập (FR01) | A | Thùy | NGUOI_DUNG, NHAN_VIEN.chuc_vu, DOC_GIA | Bắt buộc |
| M05 Quầy mượn trả (FR10–FR13) | C | Nhiên | `sp_lap_phieu_muon`, `sp_ghi_nhan_tra`, `sp_gia_han`, `sp_bao_mat_hu_hong` | Bắt buộc |
| M06 Tài liệu và bản sao (FR23, FR24) | B | Phát | `sp_them_tai_lieu`, `sp_cap_nhat_ban_sao`, `sp_them_ban_sao` | Bắt buộc |
| M10 Báo cáo (FR31–FR36) | E | Linh | các truy vấn thống kê | Bắt buộc |
| M02 Tra cứu (FR06, FR07) | B | Phát | truy vấn tra cứu, Hàm 2 | Nên có |
| M04 Trang độc giả (FR09, FR12, FR20) | D | Kỳ | truy vấn lịch sử mượn, `fn_phat_tam_tinh`, `sp_huy_dat_truoc` | Nên có |
| M08 Phiếu phạt (FR18, FR19) | D | Kỳ | `sp_thu_phat`, `sp_huy_phieu_phat`, Trigger 1 | Nên có |
| M11 Cấu hình quy định (FR37) | A | Thùy | thủ tục 2.1 trên THAM_SO_HE_THONG | Nên có |
| M12 Đăng ký độc giả (FR02) | A | Thùy | `sp_dang_ky_doc_gia` | Nên có |
| M03 Chi tiết tài liệu (FR08, FR15, FR21) | B | Phát | `sp_dat_truoc`, `sp_danh_gia` | Nếu kịp |
| M07 Phiếu nhập (FR27, FR28) | B | Phát | `sp_lap_phieu_nhap` | Nếu kịp |
| M09 Xếp lịch trực (FR29) | E | Linh | `sp_phan_cong` | Nếu kịp |

Làm xong hết "Bắt buộc" mới sang "Nên có", rồi mới tới "Nếu kịp". Màn nào không kịp thì ghi rõ phạm vi demo trong báo cáo.

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
├── app/          ứng dụng Node.js kết nối CSDL
└── run_all_mysql.sql       bản MySQL cũ, sẽ thay bằng bản SQL Server
```

**Vì sao tách khóa ngoại ra riêng:** `run_all` tạo hết bảng trước rồi mới thêm khóa ngoại, nên ai viết bảng trước cũng được, không phải lo bảng nào tạo trước.

**Vì sao dữ liệu mẫu chạy trước trigger:** dữ liệu mẫu có cả lịch sử cũ (sách đã mất, phiếu đã thu). Nạp trước trigger thì không bị trigger chặn nhầm. Thủ tục và trigger được kiểm tra riêng bằng `tests/`.

## Hệ quản trị CSDL

Nhóm đã đổi từ MySQL sang **Microsoft SQL Server** (11/2026). Cần **SQL Server 2019 trở lên** (bản Express hoặc Developer đều được) và **SSMS** để chạy file, chụp minh chứng.

### Tạo database: bắt buộc dùng đúng collation

Ai cũng phải tạo `libms` bằng **đúng lệnh dưới đây**. Nếu tạo bằng chuột phải → New Database, SQL Server dùng collation mặc định `SQL_Latin1_General_CP1_CI_AS`. Khi đó chữ có dấu trong cột `varchar` (họ tên, địa chỉ, mô tả) bị lưu thành `?`, và ảnh minh chứng của mỗi máy sẽ khác nhau.

```sql
USE master;
GO
-- Xóa database cũ (nếu có), ngắt mọi kết nối đang mở vào libms
IF DB_ID('libms') IS NOT NULL
BEGIN
    ALTER DATABASE libms SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE libms;
END
GO
CREATE DATABASE libms COLLATE Vietnamese_100_CI_AS_SC_UTF8;
GO

-- Kiểm tra: phải ra Vietnamese_100_CI_AS_SC_UTF8 và MULTI_USER
SELECT name, collation_name, user_access_desc
FROM sys.databases
WHERE name = 'libms';
```

Ý nghĩa từng phần của `Vietnamese_100_CI_AS_SC_UTF8`:

| Phần | Nghĩa | Vì sao cần |
|---|---|---|
| `Vietnamese_100` | Quy tắc so sánh, sắp xếp tiếng Việt | `ORDER BY ten` xếp đúng thứ tự chữ Việt |
| `CI` | Không phân biệt hoa thường | `'Hoat_Dong'` = `'hoat_dong'` khi so sánh |
| `AS` | **Có phân biệt dấu** | `'mat'` khác `'mất'`, nên CHECK `IN (...)` kiểm tra chặt |
| `SC` | Hỗ trợ đủ ký tự Unicode | |
| `UTF8` | Cột `varchar` lưu dạng UTF-8 | Chữ có dấu lưu đúng mà không phải đổi sang `nvarchar` hay viết `N'...'` |

Hai lưu ý:

- **`varchar(n)` tính theo byte, không theo ký tự.** Một chữ có dấu như "ồ" chiếm 3 byte, nên `varchar(50)` có thể chứa ít hơn 50 chữ. Họ tên, địa chỉ vẫn dư chỗ. Cột nào chứa câu dài (mô tả, bình luận) thì để độ dài rộng.
- **Mọi file `.sql` mở đầu bằng `USE libms; GO`.** Thiếu dòng này, chạy nhầm trong tab đang đứng ở `master` sẽ bị lỗi kiểu *Cannot find the object ...* hoặc *Invalid object name ...*.

Giá trị liệt kê viết **không dấu, gạch dưới** (`'hoat_dong'`, `'sinh_vien'`, `'tat_ca'`). Dữ liệu tự do (họ tên, địa chỉ, mô tả) được viết có dấu.

### Lưu ý khi chuyển code MySQL sang SQL Server

| MySQL | SQL Server |
|---|---|
| `DROP ... IF EXISTS` + `DELIMITER $$` | `CREATE OR ALTER PROCEDURE/FUNCTION/TRIGGER`, ngăn các batch bằng `GO`. `CREATE PROCEDURE` phải là lệnh đầu tiên của batch |
| Tham số `p_ma`, biến `DECLARE v_x` | Tham số và biến có `@`: `@ma_doc_gia`, `DECLARE @x INT` |
| `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BR10: ...'` | `THROW 50010, 'BR10: ...', 1;`, thông báo vẫn mở đầu bằng mã BR. Số lỗi từ 50000 trở lên |
| Hàm báo lỗi bằng `SIGNAL` | **Hàm không được `THROW`/`RAISERROR`, không được INSERT/UPDATE bảng.** Hàm trả NULL, thủ tục gọi hàm kiểm tra rồi `THROW` |
| `LIMIT 1` | `SELECT TOP 1 ...`, hoặc `OFFSET ... FETCH NEXT ...` |
| `IFNULL`, `CURDATE()`, `NOW()`, `DATE_ADD` | `ISNULL`, `CAST(GETDATE() AS date)`, `GETDATE()`, `DATEADD(day, n, ngay)` |
| `DATEDIFF(ket_thuc, bat_dau)` | `DATEDIFF(day, bat_dau, ket_thuc)`: **thứ tự tham số ngược với MySQL** |
| Trigger `BEFORE`, `FOR EACH ROW`, `NEW`/`OLD` | Chỉ có `AFTER` và `INSTEAD OF`. Trigger chạy **một lần cho cả câu lệnh**, dữ liệu nằm trong bảng ảo `inserted`/`deleted` (có thể nhiều dòng). Kiểm tra trong `AFTER` rồi `THROW` thì cả câu lệnh bị hủy |
| `CREATE EVENT ... EVERY 1 DAY` | Không có. SQL Server Agent job không có ở bản Express, nên khi demo gọi `EXEC sp_het_han_giu_cho` bằng tay hoặc từ app |
| InnoDB tự tạo chỉ mục cho cột khóa ngoại | SQL Server **không tự tạo**. Chỉ mục trên cột khóa ngoại phải tự khai |
| UNIQUE không kèm điều kiện được | Có **filtered index**: `CREATE UNIQUE INDEX ... WHERE ngay_tra_thuc_te IS NULL` |
| `EXPLAIN ANALYZE`, `IGNORE INDEX (idx_...)` | Bật **Include Actual Execution Plan** (Ctrl+M) và `SET STATISTICS IO, TIME ON`. Ép không dùng chỉ mục bằng `WITH (INDEX(0))` |
| Kiểu `BOOLEAN`, `TINYINT(1)` | `BIT` |

## Cài đặt lần đầu

### 1. Lấy repo về máy

**Cách dễ (không cần dòng lệnh):** cài [GitHub Desktop](https://desktop.github.com/), đăng nhập, chọn **File → Clone repository** rồi chọn `libms`.

**Cách dòng lệnh:**
```bash
git clone https://github.com/thuykoo1110/libms.git
cd libms
```

### 2. Chạy thử

1. Trong SSMS, Connect vào server (`localhost` hoặc `.\SQLEXPRESS`).
2. Chạy đoạn **tạo database** ở mục Hệ quản trị CSDL. Đoạn này xóa `libms` cũ rồi tạo lại từ đầu, nên chạy bao nhiêu lần cũng được.
3. Mở từng file (Ctrl+O) rồi bấm F5, theo đúng thứ tự: `schema/` → `fk/` → `seed/` → `functions/` → `procedures/` → `triggers/` → `index/`. Trong mỗi thư mục, chạy theo thứ tự A → B → C → D → E.
4. Xem tab **Messages**. Không có dòng chữ đỏ là được.

Bản `run_all` cho SQL Server (chạy một lần bằng `sqlcmd`) đang làm.

### 3. Chạy ứng dụng

Sẽ bổ sung khi có khung `app/`.

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
5. **Trigger kiểm tra và giữ bất biến.** Trigger được cập nhật bảng khác khi để giữ hai bảng khớp nhau (ví dụ Trigger 2: chèn dòng mượn thì bản sao chuyển "đang mượn"). Logic nhiều bước như lập phiếu phạt, phân bổ hàng đợi vẫn đặt trong thủ tục.
6. **Đặt tên ràng buộc** theo kiểu `chk_<bang>_<y_nghia>`, `fk_...`, `uq_...`, để ảnh chụp báo lỗi đọc được ngay ràng buộc nào chặn.

## Quy ước mã dữ liệu mẫu

Mỗi mảng dùng khoảng mã riêng, để khóa chính không trùng và người khác biết mã nào mà tham chiếu.

| Mảng | Khoảng mã |
|---|---|
| A | Người dùng ND001–ND060 (ND001–ND010 là nhân viên), thẻ TH001–TH050 |
| B | Tài liệu TL001–TL040, tác giả TG001–, NXB NXB01–, thể loại TLO01–, khu vực KV01–KV06, NCC NCC01–NCC05, phiếu nhập PN001– |
| C | Phiếu mượn PM001– |
| D | Đặt trước DT001–, phiếu phạt PP001– |
| E | Ca trực CA0001– |

Mảng A và B nên xong dữ liệu mẫu sớm, vì C, D, E cần mã độc giả, nhân viên và bản sao để viết dữ liệu của mình.

## Việc đang mở

- [ ] **C (Nhiên):** thêm CHECK `ma_nv_xu_ly <> ma_doc_gia` cho PHIEU_MUON (BR34, khai được trong CREATE TABLE); đặt tên cho các CHECK trong `schema/C_muon_tra.sql`
- [ ] **E (Linh):** demo chỉ mục trước/sau bằng cùng một câu truy vấn, lần đầu thêm `IGNORE INDEX (idx_...)`. Cần thêm script sinh vài chục nghìn dòng riêng cho phần demo này, vì dữ liệu mẫu nhỏ thì thời gian chạy gần như không khác nhau
- [x] **Cả nhóm:** collation chốt `Vietnamese_100_CI_AS_SC_UTF8` (có phân biệt dấu), xem mục Hệ quản trị CSDL
- [ ] **B (Phát), D (Kỳ):** chuyển code từ MySQL sang SQL Server theo bảng lưu ý ở mục Hệ quản trị CSDL
- [ ] **Cả nhóm:** xác nhận bảng "Hàng trong Bảng kê nhiệm vụ" ở trên

### Việc mới phát sinh từ đặc tả main 12

Bản báo cáo main 12 thêm BR36, BR37 và sửa BR11, BR13, BR14, BR16, BR21, BR34, BR35 (xem phụ lục "Ghi chú thay đổi so với bản BTL1"). Các việc dưới đây không phải hàng chấm điểm riêng, nhưng thủ tục chấm điểm và ứng dụng dựa vào chúng. Mỗi người tự thêm vào danh sách việc ở đầu file của mảng mình.

**B (Phát)**
- [ ] Trigger BEFORE UPDATE trên BAN_SAO: tình trạng chỉ chuyển theo bước hợp lệ, không đổi khu vực khi đang mượn hoặc đang giữ chỗ (BR36). Gộp vào hàng 1.1.b vì phải so OLD với NEW nên CHECK không làm được
- [ ] `sp_cap_nhat_ban_sao` cho M06: chặn sửa tay bản sao đang mượn, đang giữ chỗ; gọi `sp_phan_bo_ban_sao` khi bản sao về "sẵn sàng" ở khu mượn về (BR36, BR12, BR14)
- [ ] `sp_them_tai_lieu` cho M06: chèn TAI_LIEU, VIET (tác giả chính), THUOC (thể loại) trong một transaction (BR37, BR26)

**C (Nhiên)**
- [ ] `sp_tim_lai_ban_sao`: sách báo mất được mang trả, hủy phiếu mất chưa thu, cập nhật dòng chi tiết bằng ngày mang trả, lập phiếu quá hạn nếu trả trễ, phân bổ bản sao (BR35, BR27, BR15). Gọi `sp_huy_phieu_phat`, `sp_lap_phieu_phat` của D
- [ ] `sp_gia_han`: chỉ chặn khi tài liệu còn yêu cầu đặt trước "đang chờ"; nhân viên không gia hạn dòng mượn của chính mình (BR11, BR34)
- [ ] `sp_ghi_nhan_tra`, `sp_bao_mat_hu_hong`: nhân viên ghi nhận khác độc giả của phiếu (BR34)

**D (Kỳ)**
- [ ] `sp_lap_phieu_phat`: phạt hư hỏng = MIN(mức cán bộ nhập, giá bìa, trần − phạt quá hạn), trần = tỷ lệ phạt mất × giá bìa (BR16)
- [ ] `sp_dat_truoc`: độc giả phải thỏa BR05, BR10; không xét hạn mức BR06 (BR13)
- [ ] `CREATE EVENT ev_het_han_giu_cho ON SCHEDULE EVERY 1 DAY DO CALL sp_het_han_giu_cho(NOW())` (BR14); thêm 1 dòng vào `run_all` sau phần thủ tục

**C, D**
- [ ] Mọi thủ tục lưu thông chỉ kiểm tra "nhân viên đang làm", không bắt buộc chức vụ cán bộ thư viện, vì quản trị viên cũng được đứng quầy (BR21)

## Quyết định đã chốt

- [x] Hệ quản trị: **SQL Server 2019+** (đổi từ MySQL, 11/2026), collation `Vietnamese_100_CI_AS_SC_UTF8`
- [x] Giá trị liệt kê: **không dấu, gạch dưới** (`'hoat_dong'`), theo từ điển dữ liệu bản SQL Server (trước đây là có dấu)
- [x] Lớp con "cán bộ trường" của DOC_GIA đổi thành **NHAN_VIEN_KHAC** (cột `ma_nhan_vien_khac`, phạm vi tham số `'nhan_vien_khac'`)
- [x] S1: nhân viên thư viện được mượn sách, chuyên biệt hóa NGUOI_DUNG đổi sang **chồng lấn** (o), thêm BR34. Báo cáo BTL2 phải sửa câu ở mục 3.2.1 (đang ghi "rời nhau") và ghi vào bảng thay đổi ở Phụ lục
- [x] S4: **không làm** THONG_BAO, đã ghi vào phạm vi
- [x] S5: **có làm** hình thức nhập (mua, biếu tặng, nộp lưu chiểu), `ma_ncc` chỉ bắt buộc khi mua
- [x] M3: tên cột người ghi nhận trả là `ma_nv_nhan_tra`
- [x] S2: phiếu phạt có trạng thái `đã hủy` kèm `ly_do_huy` (BR35)
- [x] Ứng dụng nộp cùng ngày **16/11**, code theo đặc tả giao diện M01–M12 của BTL1
- [x] Thủ tục 1 chấm điểm là `sp_lap_phieu_muon` (FR10)
- [x] Đặc tả nghiệp vụ chốt theo bản báo cáo **main 12**: thêm BR36 (bước chuyển tình trạng bản sao), BR37 (mỗi tài liệu có ít nhất 1 tác giả và 1 thể loại); `sp_tim_lai_ban_sao` thuộc mảng C
