const pool = require('../config/db');

const SELECT_ANAK = `
  SELECT a.*, i.nama AS nama_ibu, p.nama AS nama_posyandu
  FROM anak a
  JOIN ibu i ON i.id = a.ibu_id
  JOIN posyandu p ON p.id = i.posyandu_id`;

const errStatus = (err) =>
  err.code === '23505' ? 409 : ['23503', '23502', '23514', '22P02'].includes(err.code) ? 400 : 500;

// GET /api/anak -> semua data
exports.getAll = async (req, res) => {
  try {
    const { rows } = await pool.query(`${SELECT_ANAK} ORDER BY a.id`);
    res.json({ success: true, data: rows });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/anak/:id -> berdasarkan ID
exports.getById = async (req, res) => {
  try {
    const { rows } = await pool.query(`${SELECT_ANAK} WHERE a.id = $1`, [req.params.id]);
    if (rows.length === 0)
      return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    res.json({ success: true, data: rows[0] });
  } catch (err) {
    res.status(errStatus(err)).json({ success: false, message: err.message });
  }
};

// POST /api/anak -> buat data baru
exports.create = async (req, res) => {
  const { ibu_id, nama, jenis_kelamin, tanggal_lahir, berat_lahir, panjang_lahir } = req.body;
  if (!ibu_id || !nama || !jenis_kelamin || !tanggal_lahir)
    return res.status(400).json({
      success: false,
      message: 'ibu_id, nama, jenis_kelamin, tanggal_lahir wajib diisi',
    });
  try {
    const { rows } = await pool.query(
      `INSERT INTO anak (ibu_id, nama, jenis_kelamin, tanggal_lahir, berat_lahir, panjang_lahir)
       VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`,
      [ibu_id, nama, jenis_kelamin, tanggal_lahir, berat_lahir, panjang_lahir]
    );
    res.status(201).json({ success: true, message: 'Data berhasil dibuat', data: rows[0] });
  } catch (err) {
    res.status(errStatus(err)).json({ success: false, message: err.message });
  }
};

// PUT /api/anak/:id -> update data
exports.update = async (req, res) => {
  const { ibu_id, nama, jenis_kelamin, tanggal_lahir, berat_lahir, panjang_lahir } = req.body;
  try {
    const { rows } = await pool.query(
      `UPDATE anak
       SET ibu_id = $1, nama = $2, jenis_kelamin = $3, tanggal_lahir = $4,
           berat_lahir = $5, panjang_lahir = $6
       WHERE id = $7 RETURNING *`,
      [ibu_id, nama, jenis_kelamin, tanggal_lahir, berat_lahir, panjang_lahir, req.params.id]
    );
    if (rows.length === 0)
      return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    res.json({ success: true, message: 'Data berhasil diperbarui', data: rows[0] });
  } catch (err) {
    res.status(errStatus(err)).json({ success: false, message: err.message });
  }
};

// DELETE /api/anak/:id -> hapus data
exports.remove = async (req, res) => {
  try {
    const { rows } = await pool.query('DELETE FROM anak WHERE id = $1 RETURNING *', [req.params.id]);
    if (rows.length === 0)
      return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    res.json({ success: true, message: 'Data berhasil dihapus', data: rows[0] });
  } catch (err) {
    res.status(errStatus(err)).json({ success: false, message: err.message });
  }
};
