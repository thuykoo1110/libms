// =====================================================================
// LibMS app | lib/xacthuc.js  (mảng A: Thùy)
// Băm mật khẩu và tính vai trò. Tách riêng, không phụ thuộc thư viện ngoài
// để kiểm thử được (xem test/xacthuc.test.js).
//
// Băm: SHA-256 dạng hex thường, khớp SHA2('...', 256) trong seed/A_nguoi_dung.sql.
// ĐÂY LÀ CÁCH ĐƠN GIẢN CHO BÀI TẬP: hệ thống thật phải dùng bcrypt/argon2 có salt.
// =====================================================================
const crypto = require('crypto');

function bamMatKhau(matKhau) {
  return crypto.createHash('sha256').update(String(matKhau), 'utf8').digest('hex');
}

// So sánh thời gian không đổi để không lộ thông tin qua thời gian phản hồi.
function khopMatKhau(matKhauNhap, daBam) {
  const a = Buffer.from(bamMatKhau(matKhauNhap), 'utf8');
  const b = Buffer.from(String(daBam || ''), 'utf8');
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

// Vai trò từ một dòng kết quả đăng nhập.
//   can_bo   : nhân viên ĐANG LÀM (cán bộ thư viện hoặc quản trị viên), BR21
//   quan_tri : nhân viên đang làm có chuc_vu = quản trị viên
//   doc_gia  : có bản ghi DOC_GIA (nhân viên cũng có thể là độc giả, BR04/BR34)
function tinhVaiTro(dong) {
  const vaiTro = [];
  if (dong.chuc_vu && dong.trang_thai_lam_viec === 'đang làm') {
    vaiTro.push('can_bo');
    if (dong.chuc_vu === 'quản trị viên') vaiTro.push('quan_tri');
  }
  if (Number(dong.la_doc_gia) === 1) vaiTro.push('doc_gia');
  return vaiTro;
}

function hoTen(dong) {
  return [dong.ho, dong.ten_dem, dong.ten].filter(Boolean).join(' ');
}

module.exports = { bamMatKhau, khopMatKhau, tinhVaiTro, hoTen };
