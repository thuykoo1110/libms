// =====================================================================
// LibMS app | db.js  (mảng A: Thùy)
// Connection pool dùng chung. Mọi truy vấn đi qua truyVan() / goiThuTuc()
// và truyền tham số bằng dấu ? (chống SQL injection), KHÔNG nối chuỗi.
// =====================================================================
require('dotenv').config();
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'libms',
  charset: 'utf8mb4',        // chữ có dấu trong dữ liệu và CHECK
  dateStrings: true,         // DATE trả về chuỗi 'YYYY-MM-DD', tránh lệch múi giờ
  waitForConnections: true,
  connectionLimit: 10,
});

// SELECT/INSERT/UPDATE/DELETE thường. Trả về mảng dòng (SELECT) hoặc ResultSetHeader.
async function truyVan(sql, params = []) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

// Gọi thủ tục: goiThuTuc('sp_lap_phieu_muon', ['ND015', 'TH005', ...]).
// Trả về mảng các result set (thủ tục có SELECT) hoặc ResultSetHeader.
// Tên thủ tục được kiểm tra chặt vì không thể truyền tên bằng dấu ?.
async function goiThuTuc(ten, params = []) {
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(ten)) throw new Error('Ten thu tuc khong hop le: ' + ten);
  const cho = params.map(() => '?').join(', ');
  const [ketQua] = await pool.query(`CALL ${ten}(${cho})`, params);
  return ketQua;
}

// Gọi hàm vô hướng: goiHam('fn_lay_tham_so', ['SO_NGAY_MUON', 'sinh viên']) -> '14'
async function goiHam(ten, params = []) {
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(ten)) throw new Error('Ten ham khong hop le: ' + ten);
  const cho = params.map(() => '?').join(', ');
  const [rows] = await pool.query(`SELECT ${ten}(${cho}) AS kq`, params);
  return rows[0].kq;
}

// Đổi lỗi MySQL thành câu hiển thị cho người dùng.
// Lỗi nghiệp vụ do SIGNAL SQLSTATE '45000' có MESSAGE_TEXT bắt đầu bằng mã BR
// (ví dụ 'BR10: ...') nên hiện nguyên văn để cô thấy trigger/thủ tục chặn đúng.
function thongBaoLoi(err) {
  if (!err) return 'Loi khong xac dinh';
  if (err.sqlState === '45000') return err.sqlMessage;
  switch (err.code) {
    case 'ER_DUP_ENTRY':
      return 'Du lieu bi trung (UNIQUE/khoa chinh): ' + err.sqlMessage;
    case 'ER_CHECK_CONSTRAINT_VIOLATED':
      return 'Vi pham rang buoc CHECK: ' + err.sqlMessage;   // tên chk_<bang>_<y_nghia>
    case 'ER_NO_REFERENCED_ROW_2':
      return 'Tham chieu khong ton tai (khoa ngoai): ' + err.sqlMessage;
    case 'ER_ROW_IS_REFERENCED_2':
      return 'Khong xoa duoc vi dang duoc tham chieu (BR19): ' + err.sqlMessage;
    case 'ER_BAD_NULL_ERROR':
      return 'Thieu du lieu bat buoc: ' + err.sqlMessage;
    case 'ECONNREFUSED':
      return 'Khong ket noi duoc MySQL. Kiem tra MySQL dang chay va file .env.';
    case 'ER_ACCESS_DENIED_ERROR':
      return 'Sai tai khoan/mat khau MySQL trong file .env.';
    case 'ER_BAD_DB_ERROR':
      return 'Chua co database libms. Chay run_all_mysql.sql truoc.';
    default:
      console.error(err);
      return 'Loi he thong: ' + (err.sqlMessage || err.message);
  }
}

module.exports = { pool, truyVan, goiThuTuc, goiHam, thongBaoLoi };
