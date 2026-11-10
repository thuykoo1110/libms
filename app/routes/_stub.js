// =====================================================================
// LibMS app | routes/_stub.js  (mảng A: Thùy)
// Trang tạm cho mọi màn trong menu.js chưa có route thật, để menu không
// bị 404 khi demo thử. Được nạp CUỐI CÙNG trong server.js nên khi bạn tạo
// route thật cho cùng đường dẫn thì route thật tự thắng, không cần xóa gì ở đây.
// =====================================================================
const express = require('express');
const { MAN_HINH } = require('../menu');
const { canDangNhap, canQuyen } = require('../middleware');

const router = express.Router();
MAN_HINH.forEach((m) => {
  router.get(m.url, canDangNhap, canQuyen(...m.quyen), (req, res) => {
    res.render('chua-lam', { tieuDe: `${m.ma} ${m.ten}`, man: m });
  });
});

module.exports = router;
