INSERT INTO posyandu (nama, alamat, ketua_kader) VALUES
 ('Posyandu Melati', 'Balai RW 03, Kel. Sukamaju', 'Bu Rina'),
 ('Posyandu Mawar',  'Balai RW 05, Kel. Sukamaju', 'Bu Dewi');

INSERT INTO ibu (posyandu_id, nik, nama, tanggal_lahir, alamat, no_hp) VALUES
 (1, '3201015505920001', 'Siti Aminah',  '1992-05-15', 'Jl. Melati No. 5',  '081234567801'),
 (1, '3201014408950002', 'Dewi Lestari', '1995-08-04', 'Jl. Melati No. 9',  '081234567802'),
 (2, '3201016003900003', 'Ratna Sari',   '1990-03-20', 'Jl. Mawar No. 12',  '081234567803');

INSERT INTO data_kesehatan_ibu (ibu_id, golongan_darah, tinggi_badan, riwayat_alergi, hpht, taksiran_persalinan) VALUES
 (1, 'O',  158.0, 'Tidak ada', NULL, NULL),
 (2, 'A',  160.5, 'Debu',      '2026-07-10', '2027-04-16');

INSERT INTO anak (ibu_id, nama, jenis_kelamin, tanggal_lahir, berat_lahir, panjang_lahir) VALUES
 (1, 'Rafi Pratama',  'L', '2025-06-12', 3.10, 49.0),
 (1, 'Nayla Putri',   'P', '2023-02-01', 2.90, 48.0),
 (3, 'Arka Wijaya',   'L', '2026-01-20', 3.30, 50.0);

INSERT INTO jadwal_posyandu (posyandu_id, tanggal, jam_mulai, jam_selesai, lokasi, keterangan) VALUES
 (1, '2026-11-12', '08:00', '11:00', 'Balai RW 03', 'Posyandu bulanan November'),
 (2, '2026-11-13', '08:00', '11:00', 'Balai RW 05', 'Posyandu bulanan November');

INSERT INTO layanan (nama_layanan, deskripsi) VALUES
 ('Penimbangan', 'Penimbangan berat dan pengukuran tinggi balita'),
 ('Imunisasi', 'Pemberian imunisasi dasar'),
 ('Pemeriksaan Ibu Hamil', 'Cek tekanan darah, berat badan, dan LILA'),
 ('Pemberian Vitamin A', 'Vitamin A untuk balita');

INSERT INTO jadwal_layanan (jadwal_id, layanan_id) VALUES
 (1,1),(1,2),(1,3),(2,1),(2,4);

INSERT INTO pemeriksaan_ibu (ibu_id, jadwal_id, tanggal_periksa, usia_kehamilan_minggu, berat_badan, tekanan_darah, lila, keluhan) VALUES
 (2, 1, '2026-11-12', 17, 58.5, '110/70', 25.5, 'Mual ringan');

INSERT INTO pemeriksaan_anak (anak_id, jadwal_id, tanggal_periksa, berat_badan, tinggi_badan, lingkar_kepala, status_gizi) VALUES
 (1, 1, '2026-11-12',  9.2, 73.0, 45.0, 'Baik'),
 (2, 1, '2026-11-12', 12.0, 90.0, 48.0, 'Baik'),
 (3, 2, '2026-11-13',  7.0, 66.0, 42.5, 'Baik');

INSERT INTO vaksin (nama_vaksin, usia_anjuran_bulan) VALUES
 ('Hepatitis B', 0), ('BCG', 1), ('Polio', 2), ('DPT-HB-Hib', 2), ('Campak', 9);

INSERT INTO riwayat_imunisasi (anak_id, vaksin_id, jadwal_id, tanggal_imunisasi) VALUES
 (1, 1, NULL, '2025-06-12'),
 (1, 2, NULL, '2025-07-10'),
 (1, 5, 1,    '2026-11-12'),
 (3, 1, NULL, '2026-01-20');
