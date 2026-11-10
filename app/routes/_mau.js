// =====================================================================
// MẪU route cho mảng của bạn. Sao chép thành routes/C_muon_tra.js (đổi tên
// theo mảng: B_tai_lieu.js, C_muon_tra.js, D_dat_truoc_phat.js, E_ca_truc_thong_ke.js).
// File bắt đầu bằng _ KHÔNG được nạp, nên file mẫu này không chạy.
//
// Ví dụ M05 Quầy mượn trả gọi sp_lap_phieu_muon của mảng C.
// Nguyên tắc: logic nghiệp vụ nằm trong thủ tục/hàm/trigger (SQL), route chỉ
// nhận form, gọi thủ tục, hiện kết quả hoặc hiện nguyên thông báo lỗi BR.
// =====================================================================
const express = require('express');
const { truyVan, goiThuTuc, thongBaoLoi } = require('../db');
const { canDangNhap, canQuyen, datThongBao } = require('../middleware');

const router = express.Router();

// Hiện form + danh sách (SELECT bằng ?, không nối chuỗi).
router.get('/quay-muon-tra', canDangNhap, canQuyen('can_bo'), async (req, res, next) => {
  try {
    const dongDangMuon = await truyVan(
      'SELECT * FROM PHIEU_MUON WHERE ma_doc_gia = ? ORDER BY ma_phieu_muon DESC LIMIT 20',
      [String(req.query.ma_doc_gia || '')]
    );
    res.render('ten-view-cua-ban', { tieuDe: 'Quầy mượn trả', dongDangMuon });   // tạo views/ten-view-cua-ban.ejs
  } catch (err) { next(err); }
});

// Gọi thủ tục. Lỗi SIGNAL 'BR10: ...' hiện nguyên văn lên màn hình.
router.post('/quay-muon-tra/muon', canDangNhap, canQuyen('can_bo'), async (req, res) => {
  try {
    // Người xử lý lấy từ PHIÊN ĐĂNG NHẬP (req.session.user.ma), không lấy từ form (BR21, BR34).
    await goiThuTuc('sp_lap_phieu_muon', [req.session.user.ma, req.body.ma_doc_gia /*, ... */]);
    datThongBao(req, 'ok', 'Đã lập phiếu mượn.');
  } catch (err) {
    datThongBao(req, 'loi', thongBaoLoi(err));
  }
  res.redirect('/quay-muon-tra');
});

module.exports = router;
