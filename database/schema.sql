-- ============================================================
-- SIPOSYANDU: Web App Monitoring Kesehatan Ibu & Anak
-- serta Jadwal Posyandu  |  PostgreSQL
-- ============================================================

DROP TABLE IF EXISTS riwayat_imunisasi CASCADE;
DROP TABLE IF EXISTS vaksin CASCADE;
DROP TABLE IF EXISTS pemeriksaan_anak CASCADE;
DROP TABLE IF EXISTS pemeriksaan_ibu CASCADE;
DROP TABLE IF EXISTS jadwal_layanan CASCADE;
DROP TABLE IF EXISTS layanan CASCADE;
DROP TABLE IF EXISTS jadwal_posyandu CASCADE;
DROP TABLE IF EXISTS anak CASCADE;
DROP TABLE IF EXISTS data_kesehatan_ibu CASCADE;
DROP TABLE IF EXISTS ibu CASCADE;
DROP TABLE IF EXISTS posyandu CASCADE;

-- 1. Posyandu
CREATE TABLE posyandu (
    id            SERIAL PRIMARY KEY,
    nama          VARCHAR(100) NOT NULL UNIQUE,
    alamat        TEXT NOT NULL,
    ketua_kader   VARCHAR(100)
);

-- 2. Ibu (One to Many: posyandu -> ibu)
CREATE TABLE ibu (
    id             SERIAL PRIMARY KEY,
    posyandu_id    INT NOT NULL REFERENCES posyandu(id) ON DELETE RESTRICT,
    nik            CHAR(16) NOT NULL UNIQUE,
    nama           VARCHAR(100) NOT NULL,
    tanggal_lahir  DATE NOT NULL,
    alamat         TEXT,
    no_hp          VARCHAR(20),
    created_at     TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 3. Data Kesehatan Ibu (One to One: ibu <-> data_kesehatan_ibu)
CREATE TABLE data_kesehatan_ibu (
    id                SERIAL PRIMARY KEY,
    ibu_id            INT NOT NULL UNIQUE REFERENCES ibu(id) ON DELETE CASCADE,
    golongan_darah    VARCHAR(3),
    tinggi_badan      NUMERIC(4,1),
    riwayat_alergi    TEXT,
    hpht              DATE,            -- hari pertama haid terakhir
    taksiran_persalinan DATE
);

-- 4. Anak (One to Many: ibu -> anak)
CREATE TABLE anak (
    id              SERIAL PRIMARY KEY,
    ibu_id          INT NOT NULL REFERENCES ibu(id) ON DELETE CASCADE,
    nama            VARCHAR(100) NOT NULL,
    jenis_kelamin   CHAR(1) NOT NULL CHECK (jenis_kelamin IN ('L','P')),
    tanggal_lahir   DATE NOT NULL,
    berat_lahir     NUMERIC(4,2),     -- kg
    panjang_lahir   NUMERIC(4,1),     -- cm
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 5. Jadwal Posyandu (One to Many: posyandu -> jadwal_posyandu)
CREATE TABLE jadwal_posyandu (
    id            SERIAL PRIMARY KEY,
    posyandu_id   INT NOT NULL REFERENCES posyandu(id) ON DELETE CASCADE,
    tanggal       DATE NOT NULL,
    jam_mulai     TIME NOT NULL,
    jam_selesai   TIME,
    lokasi        VARCHAR(150) NOT NULL,
    keterangan    TEXT
);

-- 6. Layanan
CREATE TABLE layanan (
    id             SERIAL PRIMARY KEY,
    nama_layanan   VARCHAR(80) NOT NULL UNIQUE,
    deskripsi      TEXT
);

-- 7. Jadwal Layanan (Many to Many: jadwal_posyandu <-> layanan)
CREATE TABLE jadwal_layanan (
    jadwal_id    INT NOT NULL REFERENCES jadwal_posyandu(id) ON DELETE CASCADE,
    layanan_id   INT NOT NULL REFERENCES layanan(id) ON DELETE CASCADE,
    PRIMARY KEY (jadwal_id, layanan_id)
);

-- 8. Pemeriksaan Ibu (One to Many: ibu -> pemeriksaan_ibu)
CREATE TABLE pemeriksaan_ibu (
    id                     SERIAL PRIMARY KEY,
    ibu_id                 INT NOT NULL REFERENCES ibu(id) ON DELETE CASCADE,
    jadwal_id              INT REFERENCES jadwal_posyandu(id) ON DELETE SET NULL,
    tanggal_periksa        DATE NOT NULL,
    usia_kehamilan_minggu  SMALLINT CHECK (usia_kehamilan_minggu BETWEEN 0 AND 45),
    berat_badan            NUMERIC(4,1),
    tekanan_darah          VARCHAR(7),   -- contoh: 120/80
    lila                   NUMERIC(3,1), -- lingkar lengan atas (cm)
    keluhan                TEXT
);

-- 9. Pemeriksaan Anak (One to Many: anak -> pemeriksaan_anak)
CREATE TABLE pemeriksaan_anak (
    id               SERIAL PRIMARY KEY,
    anak_id          INT NOT NULL REFERENCES anak(id) ON DELETE CASCADE,
    jadwal_id        INT REFERENCES jadwal_posyandu(id) ON DELETE SET NULL,
    tanggal_periksa  DATE NOT NULL,
    berat_badan      NUMERIC(4,1) NOT NULL,   -- kg
    tinggi_badan     NUMERIC(4,1) NOT NULL,   -- cm
    lingkar_kepala   NUMERIC(4,1),            -- cm
    status_gizi      VARCHAR(10) NOT NULL DEFAULT 'Baik'
                     CHECK (status_gizi IN ('Baik','Kurang','Buruk','Lebih')),
    catatan          TEXT
);

-- 10. Vaksin
CREATE TABLE vaksin (
    id                   SERIAL PRIMARY KEY,
    nama_vaksin          VARCHAR(80) NOT NULL UNIQUE,
    usia_anjuran_bulan   SMALLINT NOT NULL
);

-- 11. Riwayat Imunisasi (Many to Many: anak <-> vaksin)
CREATE TABLE riwayat_imunisasi (
    anak_id            INT NOT NULL REFERENCES anak(id) ON DELETE CASCADE,
    vaksin_id          INT NOT NULL REFERENCES vaksin(id) ON DELETE RESTRICT,
    jadwal_id          INT REFERENCES jadwal_posyandu(id) ON DELETE SET NULL,
    tanggal_imunisasi  DATE NOT NULL,
    PRIMARY KEY (anak_id, vaksin_id)
);

CREATE INDEX idx_ibu_posyandu ON ibu(posyandu_id);
CREATE INDEX idx_anak_ibu ON anak(ibu_id);
CREATE INDEX idx_jadwal_tanggal ON jadwal_posyandu(tanggal);
CREATE INDEX idx_periksa_anak_tgl ON pemeriksaan_anak(anak_id, tanggal_periksa);
