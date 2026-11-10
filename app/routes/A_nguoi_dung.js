// =====================================================================
// LibMS app | routes/A_nguoi_dung.js
// Mảng A (Thùy): M01 Đăng nhập (FR01), trang chủ, đổi mật khẩu.
// Còn lại của mảng A: M11 Cấu hình (FR37), M12 Đăng ký độc giả (FR02).
//   -> chưa làm: đang là trang tạm trong routes/_stub.js. Làm xong thì thêm
//      route /cau-hinh, /dang-ky-doc-gia vào file này.
// =====================================================================
const express = require('express');
const { truyVan, thongBaoLoi } = require('../db');
const { khopMatKhau, bamMatKhau, tinhVaiTro, hoTen } = require('../lib/xacthuc');
const { canDangNhap, datThongBao } = require('../middleware');

const router = express.Router();

// Một câu lấy đủ: tài khoản, vai trò nhân viên, và độc giả thuộc lớp con nào.
const SQL_DANG_NHAP = `
  SELECT nd.ma_nguoi_dung, nd.ho, nd.ten_dem, nd.ten,
         nd.mat_khau_ma_hoa, nd.trang_thai_tai_khoan,
         nv.chuc_vu, nv.trang_thai_lam_viec,
         (dg.ma_nguoi_dung IS NOT NULL) AS la_doc_gia,
         CASE WHEN sv.ma_nguoi_dung IS NOT NULL THEN 'sinh viên'
              WHEN gv.ma_nguoi_dung IS NOT NULL THEN 'giảng viên'
              WHEN cb.ma_nguoi_dung IS NOT NULL THEN 'cán bộ trường'
         END AS loai_doc_gia
    FROM NGUOI_DUNG nd
    LEFT JOIN NHAN_VIEN     nv ON nv.ma_nguoi_dung = nd.ma_nguoi_dung
    LEFT JOIN DOC_GIA       dg ON dg.ma_nguoi_dung = nd.ma_nguoi_dung
    LEFT JOIN SINH_VIEN     sv ON sv.ma_nguoi_dung = nd.ma_nguoi_dung
    LEFT JOIN GIANG_VIEN    gv ON gv.ma_nguoi_dung = nd.ma_nguoi_dung
    LEFT JOIN CAN_BO_TRUONG cb ON cb.ma_nguoi_dung = nd.ma_nguoi_dung
   WHERE nd.ten_dang_nhap = ?`;

router.get('/', (req, res) => res.redirect(req.session.user ? '/trang-chu' : '/dang-nhap'));

// ---- M01 Đăng nhập (FR01) -------------------------------------------------
router.get('/dang-nhap', (req, res) => {
  if (req.session.user) return res.redirect('/trang-chu');
  res.render('dang-nhap', { tenDangNhap: '' });
});

router.post('/dang-nhap', async (req, res) => {
  const tenDangNhap = String(req.body.ten_dang_nhap || '').trim();
  const matKhau = String(req.body.mat_khau || '');
  const loi = (noiDung) => res.status(401).render('dang-nhap', { tenDangNhap, loi: noiDung });
  try {
    if (!tenDangNhap || !matKhau) return loi('Nhập tên đăng nhập và mật khẩu.');
    const [dong] = await truyVan(SQL_DANG_NHAP, [tenDangNhap]);
    // Cùng một thông báo cho "không có tài khoản" và "sai mật khẩu" để không lộ tài khoản nào tồn tại.
    if (!dong || !khopMatKhau(matKhau, dong.mat_khau_ma_hoa)) return loi('Sai tên đăng nhập hoặc mật khẩu.');
    if (dong.trang_thai_tai_khoan === 'khóa') return loi('Tài khoản đang bị khóa. Liên hệ thư viện (BR05, BR21).');

    const vaiTro = tinhVaiTro(dong);
    if (vaiTro.length === 0) return loi('Tài khoản không còn quyền sử dụng hệ thống.');

    // Cấp phiên mới sau khi đăng nhập để tránh session fixation.
    req.session.regenerate((err) => {
      if (err) return loi('Không tạo được phiên đăng nhập.');
      req.session.user = {
        ma: dong.ma_nguoi_dung,
        hoTen: hoTen(dong),
        vaiTro,
        loaiDocGia: dong.loai_doc_gia || null,
        chucVu: dong.chuc_vu || null,
      };
      res.redirect('/trang-chu');
    });
  } catch (err) {
    loi(thongBaoLoi(err));
  }
});

router.post('/dang-xuat', (req, res) => {
  req.session.destroy(() => res.redirect('/dang-nhap'));
});

// ---- Trang chủ theo vai trò -----------------------------------------------
router.get('/trang-chu', canDangNhap, (req, res) => {
  res.render('trang-chu', { tieuDe: 'Trang chủ' });
});

// ---- Đổi mật khẩu (M01 ghi chú: LibMS có thêm đổi mật khẩu) ----------------
router.get('/doi-mat-khau', canDangNhap, (req, res) => {
  res.render('doi-mat-khau', { tieuDe: 'Đổi mật khẩu' });
});

router.post('/doi-mat-khau', canDangNhap, async (req, res) => {
  const { mat_khau_cu: cu = '', mat_khau_moi: moi = '', nhap_lai: lai = '' } = req.body;
  try {
    if (moi.length < 8) throw new Error('Mật khẩu mới tối thiểu 8 ký tự.');
    if (moi !== lai) throw new Error('Nhập lại mật khẩu mới chưa khớp.');
    const [dong] = await truyVan('SELECT mat_khau_ma_hoa FROM NGUOI_DUNG WHERE ma_nguoi_dung = ?', [req.session.user.ma]);
    if (!dong || !khopMatKhau(cu, dong.mat_khau_ma_hoa)) throw new Error('Mật khẩu hiện tại không đúng.');
    await truyVan('UPDATE NGUOI_DUNG SET mat_khau_ma_hoa = ? WHERE ma_nguoi_dung = ?', [bamMatKhau(moi), req.session.user.ma]);
    datThongBao(req, 'ok', 'Đã đổi mật khẩu.');
    res.redirect('/trang-chu');
  } catch (err) {
    datThongBao(req, 'loi', err.sqlState ? thongBaoLoi(err) : err.message);
    res.redirect('/doi-mat-khau');
  }
});

module.exports = router;
