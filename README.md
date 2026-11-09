# SIPOSYANDU - Monitoring Kesehatan Ibu & Anak serta Jadwal Posyandu

REST API (Express.js + PostgreSQL) untuk data anak.

## Setup
1. Buat database `siposyandu`
2. Jalankan `database/schema.sql` lalu `database/seed.sql`
3. Salin `.env.example` menjadi `.env`, isi kredensial
4. `npm install` lalu `npm run dev`

## Endpoint
| Method | URL | Keterangan |
|---|---|---|
| GET | /api/anak | Semua data |
| GET | /api/anak/:id | Berdasarkan ID |
| POST | /api/anak | Tambah data |
| PUT | /api/anak/:id | Perbarui data |
| DELETE | /api/anak/:id | Hapus data |

Body contoh (POST/PUT, JSON):
```json
{
  "ibu_id": 1,
  "nama": "Alya Zahra",
  "jenis_kelamin": "P",
  "tanggal_lahir": "2026-03-08",
  "berat_lahir": 3.0,
  "panjang_lahir": 49.5
}
```
