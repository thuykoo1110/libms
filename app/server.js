// =====================================================================
// LibMS app | server.js  (mảng A: Thùy)
// Kiến trúc: trình duyệt -> Express (route) -> pool mysql2 -> MySQL.
// Mọi file trong routes/ (không bắt đầu bằng _) được nạp tự động, nên mỗi
// người chỉ thêm file route của mảng mình, không phải sửa file này.
// =====================================================================
require('dotenv').config();
const fs = require('fs');
const path = require('path');
const express = require('express');
const session = require('express-session');
const { menuCho } = require('./menu');

const app = express();
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));
app.use(session({
  secret: process.env.SESSION_SECRET || 'libms-dev-only',
  resave: false,
  saveUninitialized: false,          // MemoryStore: đủ cho demo, mất phiên khi tắt server
  cookie: { httpOnly: true, sameSite: 'lax', maxAge: 2 * 60 * 60 * 1000 },
}));

// Biến dùng chung cho mọi view: người đang đăng nhập, menu theo vai trò, thông báo 1 lần.
app.use((req, res, next) => {
  const user = req.session.user || null;
  res.locals.user = user;
  res.locals.menu = user ? menuCho(user.vaiTro) : [];
  res.locals.duongDan = req.path;
  res.locals.thongBao = req.session.flash || null;
  delete req.session.flash;
  next();
});

// Nạp route thật theo thứ tự tên file: A_..., B_..., C_..., D_..., E_...
const thuMucRoute = path.join(__dirname, 'routes');
fs.readdirSync(thuMucRoute)
  .filter((f) => f.endsWith('.js') && !f.startsWith('_'))
  .sort()
  .forEach((f) => app.use(require(path.join(thuMucRoute, f))));

// Trang tạm cho màn chưa làm: nạp SAU CÙNG nên route thật luôn thắng.
app.use(require('./routes/_stub'));

app.use((req, res) => {
  res.status(404).render('loi', { tieuDe: 'Không tìm thấy', noiDungLoi: 'Đường dẫn ' + req.path + ' không tồn tại.' });
});

// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  const { thongBaoLoi } = require('./db');
  res.status(500).render('loi', { tieuDe: 'Lỗi', noiDungLoi: thongBaoLoi(err) });
});

const cong = Number(process.env.PORT || 3000);
app.listen(cong, () => console.log(`LibMS chay tai http://localhost:${cong}`));
