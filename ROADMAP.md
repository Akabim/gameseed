# 🗺️ Roadmap & Progress Checklist: Gameseed

Berikut adalah rangkuman dari konsep game *Gameseed* yang kita diskusikan, membandingkan apa yang sudah diimplementasikan (Done) dan apa saja yang masih kurang atau perlu ditambahkan (Pending) untuk melengkapi prototype ini.

---

## 1. Narasi & Tema (TV Brainwash)
* **Konsep**: Bocil kena cuci otak oleh acara TV misterius yang menjanjikan hadiah jika berhasil menangkap Peri Gigi.
* **Status**:
  - [ ] **Pending**: Pengantar/Intro cerita (misal: layar TV jadul berkedip dengan teks provokatif saat game pertama kali dijalankan).
  - [ ] **Pending**: CRT Shader / Glitch Effect (opsional, untuk memperkuat estetika TV tabung/brainwash).

---

## 2. Sesi 1: Explore Phase (Eksplorasi Rumah)
* **Konsep**: 2D Side-Scroller (gaya Little Misfortune) untuk mengumpulkan barang dalam batas waktu tertentu di dalam rumah (posisi barang acak).
* **Status**:
  - [x] **Done**: Gerakan player 2D (WASD/Tombol Arah + Lompat).
  - [x] **Done**: Spawn barang acak (`BOX`, `WHEEL`, `FAN`, `BALLOON`) lengkap dengan label teks nama melayang di atasnya.
  - [x] **Done**: Sistem inventory global yang mencatat barang terkumpul.
  - [ ] **Pending**: Desain Rumah (Level Map) – Saat ini lantai masih berupa garis lurus panjang flat. Idealnya ada rintangan rumah seperti melompati meja, kolong tempat tidur, atau rak buku.
  - [ ] **Pending**: Durasi Asli – Saat ini diset 20 detik (untuk testing). Versi aslinya direncanakan 5 menit.

---

## 3. Layar Transisi Antar Fase (Transition Screen)
* **Konsep**: Jeda setelah eksplorasi untuk merangkum hasil barang yang didapatkan sebelum masuk ke kamar untuk merakit.
* **Status**:
  - [ ] **Pending**: Layar rangkuman ("Waktu Habis! Kamu mengumpulkan 3 Roda, 2 Kardus..."). Saat ini game langsung berpindah scene secara mendadak begitu timer eksplorasi habis.

---

## 4. Sesi 2: Build Phase (Perakitan di Kamar)
* **Konsep**: Merakit kendaraan di grid dalam kamar tidur anak dengan batas waktu 1 menit.
* **Status**:
  - [x] **Done**: Grid snapping perakitan dengan drag & drop dari panel tombol UI bawah (ala Bad Piggies).
  - [x] **Done**: Visual ruangan kamar (wallpaper, meja belajar, kasur, jendela).
  - [ ] **Pending**: Timer Perakitan – Saat ini belum ada batas waktu 15 detik/1 menit. Pemain masih bisa merakit tanpa batas waktu sebelum menekan ENTER.
  - [ ] **Pending**: Tombol Reset Perakitan – Tombol UI untuk mengembalikan semua barang di grid langsung ke tas (tas kosong) secara instan.

---

## 5. Sesi 3: Chase / Test Phase (Pengejaran Peri Gigi)
* **Konsep**: Kendaraan meluncur turun dan terbang menggunakan dorongan kipas/balon untuk menangkap Peri Gigi yang melayang.
* **Status**:
  - [x] **Done**: Level physics (Meja $\rightarrow$ Papan Turun $\rightarrow$ Lantai Karpet $\rightarrow$ Papan Pelontar).
  - [x] **Done**: Mekanik berkendara (Kipas menyala dengan SPASI, Balon mengangkat otomatis).
  - [x] **Done**: stuck & out-of-bounds detection (auto-restart 3 detik jika gagal).
  - [x] **Done**: Garis finish bintang emas Peri Gigi (auto-loop 4 detik jika menang).
  - [ ] **Pending**: AI/Gerakan Peri Gigi – Saat ini Peri Gigi hanya melayang naik-turun lambat di satu tempat. Bisa dibuat terbang berputar atau kabur saat didekati.
  - [ ] **Pending**: Integrasi Aset Gambar – Menggunakan gambar `kardus.png` dan `papan.png` yang sudah ada di folder `assets/` sebagai tekstur visual bagian kendaraan (saat ini masih berupa kotak warna polos).
