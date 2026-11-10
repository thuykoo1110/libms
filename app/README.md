# LibMS app (BTL2, nộp 16/11)

Node.js + Express + `mysql2` + EJS. Kiến trúc: trình duyệt → Express (route) → connection pool `mysql2` → MySQL.
Logic nghiệp vụ nằm trong thủ tục/hàm/trigger của MySQL; app chỉ nhận form, gọi SQL của mảng mình và hiện kết quả
hoặc nguyên văn lỗi `SIGNAL` (có mã BR).

## Chạy lần đầu

```bash
# 1. Dựng database (ở thư mục gốc repo)
mysql -u root -p --default-character-set=utf8mb4 < run_all_mysql.sql

# 2. Cài và chạy app
cd app
npm install
copy .env.example .env      # Windows (macOS/Linux: cp). Mở .env điền DB_PASSWORD của máy bạn
npm start                   # http://localhost:3000
npm test                    # kiểm thử phần băm mật khẩu, vai trò, menu (không cần MySQL)
```

Đăng nhập thử (sau khi có `seed/A_nguoi_dung.sql`; mật khẩu mẫu xem đầu file seed):

| Vai trò | Tên đăng nhập | Ghi chú |
|---|---|---|
| Quản trị viên | `nv001` | thấy cả M05–M12 |
| Cán bộ thư viện | `nv003` | quầy mượn trả, tài liệu, phiếu phạt |
| Nhân viên + độc giả | `nv004` | thấy cả menu cán bộ và menu độc giả |
| Sinh viên | `2510001` | M02, M04 |
| Tài khoản bị khóa | `2510023` | phải bị từ chối |
| Nhân viên đã nghỉ việc | `nv008` | phải bị từ chối |

## Cấu trúc

```
app/
├── server.js          nạp tự động mọi routes/*.js (trừ file bắt đầu bằng _)
├── db.js              pool, truyVan(), goiThuTuc(), goiHam(), thongBaoLoi()
├── middleware.js      canDangNhap, canQuyen('can_bo'|'quan_tri'|'doc_gia')
├── menu.js            danh sách M01–M12, quyền, người phụ trách, mức ưu tiên
├── lib/xacthuc.js     băm mật khẩu, tính vai trò
├── routes/
│   ├── A_nguoi_dung.js    M01 đăng nhập, trang chủ, đổi mật khẩu (xong)
│   ├── _stub.js           trang "chưa làm" cho màn chưa có route thật
│   └── _mau.js            MẪU để sao chép (không được nạp)
├── views/             *.ejs, partials/dau.ejs và cuoi.ejs
└── public/style.css
```

## Cách thêm màn hình của mảng bạn

1. Sao chép `routes/_mau.js` thành `routes/<Mảng>_<tên>.js`, ví dụ `routes/C_muon_tra.js`. Server tự nạp, **không sửa `server.js`**.
2. Dùng đúng đường dẫn đã khai trong `menu.js` (ví dụ M05 là `/quay-muon-tra`). Trang "chưa làm" tự nhường cho route thật.
3. Tạo `views/<tên>.ejs`, bắt đầu bằng `<%- include('partials/dau') %>` và kết thúc bằng `<%- include('partials/cuoi') %>`.
4. Mọi tham số truyền bằng `?` qua `truyVan()` hoặc `goiThuTuc()`. **Không nối chuỗi SQL** (SQL injection).
5. Người thao tác (`ma_nv_xu_ly`, `ma_nv_nhan_tra`...) lấy từ `req.session.user.ma`, không lấy từ form (BR21, BR34).
6. Lỗi: `catch (err) { datThongBao(req, 'loi', thongBaoLoi(err)); }` để hiện nguyên văn `BR10: ...`.
7. Code đúng đặc tả giao diện M01–M12 của BTL1 (trường dữ liệu, nút), cô đối chiếu khi demo.

## Lưu ý

- Mật khẩu băm SHA-256 không muối cho khớp `SHA2(...,256)` trong dữ liệu mẫu. Chỉ dùng cho bài tập.
- Phiên đăng nhập lưu trong bộ nhớ, tắt server là mất phiên. Bình thường với demo.
- `app/.env` không được commit (đã có trong `.gitignore`). Commit `.env.example`.
