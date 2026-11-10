// =====================================================================
// LibMS app | middleware.js  (mảng A: Thùy)
// Dùng trong route: router.get('/x', canDangNhap, canQuyen('can_bo'), handler)
// =====================================================================
const { duocVao } = require('./menu');

function datThongBao(req, loai, noiDung) {
  req.session.flash = { loai, noiDung };   // loai: 'ok' | 'loi'
}

function canDangNhap(req, res, next) {
  if (req.session && req.session.user) return next();
  datThongBao(req, 'loi', 'Vui lòng đăng nhập.');
  return res.redirect('/dang-nhap');
}

// canQuyen('can_bo') hoặc canQuyen('quan_tri', 'doc_gia'): đủ MỘT trong các vai trò.
function canQuyen(...quyen) {
  return (req, res, next) => {
    if (duocVao(req.session.user && req.session.user.vaiTro, quyen)) return next();
    return res.status(403).render('loi', { tieuDe: 'Không có quyền', noiDungLoi: 'Tài khoản của bạn không được vào màn hình này.' });
  };
}

module.exports = { canDangNhap, canQuyen, datThongBao };
