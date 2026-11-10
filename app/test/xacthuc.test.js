// Chạy: cd app && npm test   (không cần cài thư viện ngoài)
const test = require('node:test');
const assert = require('node:assert');
const { bamMatKhau, khopMatKhau, tinhVaiTro, hoTen } = require('../lib/xacthuc');
const { duocVao, menuCho, MAN_HINH } = require('../menu');

test('bam SHA-256 khop SHA2(...,256) cua MySQL (tieng Viet khong anh huong vi mat khau mau la ASCII)', () => {
  assert.strictEqual(bamMatKhau('abc'), 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
  assert.strictEqual(bamMatKhau('LibMS@2026').length, 64);
});

test('khopMatKhau dung/sai/rong/null', () => {
  const h = bamMatKhau('LibMS@2026');
  assert.ok(khopMatKhau('LibMS@2026', h));
  assert.ok(!khopMatKhau('libms@2026', h));
  assert.ok(!khopMatKhau('', h));
  assert.ok(!khopMatKhau('LibMS@2026', null));
  assert.ok(!khopMatKhau('LibMS@2026', 'abc'));
});

test('tinhVaiTro: quan tri vien, can bo, doc gia, nhan vien da nghi', () => {
  assert.deepStrictEqual(tinhVaiTro({ chuc_vu: 'quản trị viên', trang_thai_lam_viec: 'đang làm', la_doc_gia: 0 }), ['can_bo', 'quan_tri']);
  assert.deepStrictEqual(tinhVaiTro({ chuc_vu: 'cán bộ thư viện', trang_thai_lam_viec: 'đang làm', la_doc_gia: 1 }), ['can_bo', 'doc_gia']);
  assert.deepStrictEqual(tinhVaiTro({ chuc_vu: null, trang_thai_lam_viec: null, la_doc_gia: 1 }), ['doc_gia']);
  assert.deepStrictEqual(tinhVaiTro({ chuc_vu: 'cán bộ thư viện', trang_thai_lam_viec: 'nghỉ việc', la_doc_gia: 0 }), []);
  assert.deepStrictEqual(tinhVaiTro({ chuc_vu: 'cán bộ thư viện', trang_thai_lam_viec: 'nghỉ việc', la_doc_gia: '1' }), ['doc_gia']);
});

test('hoTen bo ten dem NULL', () => {
  assert.strictEqual(hoTen({ ho: 'Huỳnh', ten_dem: null, ten: 'Bình' }), 'Huỳnh Bình');
});

test('menu theo vai tro', () => {
  assert.ok(duocVao(['can_bo'], ['can_bo']));
  assert.ok(!duocVao(['doc_gia'], ['can_bo']));
  assert.ok(!duocVao(undefined, ['can_bo']));
  const quanTri = menuCho(['can_bo', 'quan_tri']).map((m) => m.ma);
  assert.ok(quanTri.includes('M11') && quanTri.includes('M05'));
  const docGia = menuCho(['doc_gia']).map((m) => m.ma);
  assert.deepStrictEqual(docGia, ['M02', 'M04']);
  const urls = MAN_HINH.map((m) => m.url);
  assert.strictEqual(new Set(urls).size, urls.length);
});
