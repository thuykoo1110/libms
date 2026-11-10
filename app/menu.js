// =====================================================================
// LibMS app | menu.js  (mảng A: Thùy)
// Danh sách màn hình M01-M12 theo đặc tả giao diện BTL1.
//   quyen : vai trò được vào (xem lib/xacthuc.js: can_bo, quan_tri, doc_gia)
//   mang  : mảng (A-E) và người phụ trách màn hình
//   uuTien: bat_buoc / nen_co / neu_kip (bảng trong README ở thư mục gốc)
// Màn nào chưa có route thật thì routes/_stub.js hiện trang "chưa làm".
// Khi làm xong màn của mình: tạo routes/<Mang>_<ten>.js, KHÔNG sửa file này
// trừ khi đổi đường dẫn. Route thật luôn được ưu tiên hơn trang tạm.
// =====================================================================
const MAN_HINH = [
  { ma: 'M02', ten: 'Tra cứu tài liệu',     url: '/tra-cuu',          quyen: ['doc_gia', 'can_bo'], mang: 'B (Phát)',  fr: 'FR06, FR07',        uuTien: 'nen_co' },
  { ma: 'M04', ten: 'Trang cá nhân',        url: '/ca-nhan',          quyen: ['doc_gia'],           mang: 'D (Kỳ)',    fr: 'FR04, FR09, FR12, FR20', uuTien: 'nen_co' },
  { ma: 'M05', ten: 'Quầy mượn trả',        url: '/quay-muon-tra',    quyen: ['can_bo'],            mang: 'C (Nhiên)', fr: 'FR10, FR11, FR13',  uuTien: 'bat_buoc' },
  { ma: 'M06', ten: 'Tài liệu và bản sao',  url: '/quan-ly-tai-lieu', quyen: ['can_bo'],            mang: 'B (Phát)',  fr: 'FR23, FR24',        uuTien: 'bat_buoc' },
  { ma: 'M07', ten: 'Phiếu nhập',           url: '/phieu-nhap',       quyen: ['can_bo'],            mang: 'B (Phát)',  fr: 'FR27, FR28',        uuTien: 'neu_kip' },
  { ma: 'M08', ten: 'Phiếu phạt',           url: '/phieu-phat',       quyen: ['can_bo'],            mang: 'D (Kỳ)',    fr: 'FR18, FR19',        uuTien: 'nen_co' },
  { ma: 'M09', ten: 'Xếp lịch trực',        url: '/xep-lich-truc',    quyen: ['quan_tri'],          mang: 'E (Linh)',  fr: 'FR29',              uuTien: 'neu_kip' },
  { ma: 'M10', ten: 'Báo cáo thống kê',     url: '/bao-cao',          quyen: ['quan_tri'],          mang: 'E (Linh)',  fr: 'FR31-FR36',         uuTien: 'bat_buoc' },
  { ma: 'M11', ten: 'Cấu hình quy định',    url: '/cau-hinh',         quyen: ['quan_tri'],          mang: 'A (Thùy)',  fr: 'FR37',              uuTien: 'nen_co' },
  { ma: 'M12', ten: 'Đăng ký độc giả',      url: '/dang-ky-doc-gia',  quyen: ['can_bo'],            mang: 'A (Thùy)',  fr: 'FR02',              uuTien: 'nen_co' },
];

// Người có ít nhất một vai trò trong quyen thì được vào.
function duocVao(vaiTro, quyen) {
  return Array.isArray(vaiTro) && quyen.some((q) => vaiTro.includes(q));
}

function menuCho(vaiTro) {
  return MAN_HINH.filter((m) => duocVao(vaiTro, m.quyen));
}

module.exports = { MAN_HINH, duocVao, menuCho };
