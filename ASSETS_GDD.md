# 🎮 Game Design Document (GDD) & Asset List: Gameseed

Dokumen ini berisi penjelasan konsep permainan serta daftar kebutuhan aset (**Art, UI, SFX, dan BGM**) bertema **Part Mainan Anak** untuk dibagikan dan dikoordinasikan bersama tim pengembangan Anda.

---

## 📝 Ringkasan Konsep Game
* **Judul Projek**: Gameseed (bisa disesuaikan nanti)
* **Genre**: 2D Physics-based Build & Play Puzzle / Side-Scroller Scavenger
* **Target Loop Permainan**:
  1. **Fase Eksplorasi (Explore)**: Pemain mengendalikan seorang anak kecil (side-scroller) berlari mengelilingi rumah untuk mengumpulkan barang-barang bekas dan mainan yang letaknya acak sebelum waktu habis.
  2. **Fase Perakitan (Build)**: Pemain merakit kendaraan mainan di atas meja kamar tidur menggunakan mainan yang berhasil dikumpulkan tadi ke dalam sistem grid (gaya *Bad Piggies*).
  3. **Fase Pengejaran (Chase)**: Kendaraan dilepas menuruni meja belajar menuju papan pelontar. Pemain mengaktifkan dorongan petasan/kunci putar di udara untuk menyesuaikan arah terbang mobil demi menangkap Peri Gigi.
* **Tema Estetika**: Cozy, kekanak-kanakan, penuh warna (*colorful*), sedikit retro/misterius (tema acara TV cuci otak anak kecil).

---

## 🎨 Daftar Kebutuhan Art (2D)

### A. Karakter & Animasi
1. **Bocil (Player - Fase Eksplorasi)**:
   - Sprite sheet atau animasi terpisah:
     - *Idle* (diam/bernafas)
     - *Run* (berlari terburu-buru mencari mainan)
     - *Jump & Fall* (melompati rintangan/perabot rumah)
2. **Peri Gigi (Garis Finish - Fase Chase)**:
   - Sprite melayang (*floating animation*) dengan kepakan sayap kecil.
   - Efek kerlipan/debu peri (*fairy dust*).

### B. Latar Belakang (Backgrounds)
1. **Explore Phase (Interior Rumah)**:
   - Background parallax (dinding rumah, lemari, lampu gantung, pintu kamar).
   - Platform perabot yang bisa dipijak (sofa, meja makan, kulkas, tangga).
2. **Build/Chase Phase (Kamar Tidur & Luar Ruangan)**:
   - Wallpaper kamar anak, kasur, jendela besar di background.
   - Pemandangan luar jendela (malam hari, langit berbintang).

### C. Komponen Kendaraan & Barang Koleksi (Tema: Mainan)
Setiap barang membutuhkan **Sprite Dunia 2D** (saat diletakkan/didrag) dan **Sprite UI (Grid/Palette)**:
1. **Balok Lego / Balok Kayu (Chassis Utama)**:
   - Blok Lego plastik persegi (warna merah, biru, kuning) atau balok kayu mainan anak bermotif huruf/angka. Bisa disambung-sambung di grid.
2. **Roda Mobil Mainan / Yo-Yo (Wheels)**:
   - Roda plastik hitam kecil dengan velg kuning menyala (seperti roda Lego/Hotwheels), yo-yo kayu bekas, atau tutup botol plastik.
3. **Petasan Roket Cilik / Kunci Putar (Thruster)**:
   - Roket kembang api mainan kecil yang diikat lakban menghadap ke belakang (mengeluarkan percikan api saat aktif) ATAU kunci putar mainan plastik (wind-up key) yang berputar kencang.
4. **Balon Karakter Foil / Baling-Baling Kertas (Lifter)**:
   - Balon gas helium berbentuk binatang (seperti balon anjing/dinosaurus tiup) ATAU baling-baling mainan helikopter plastik yang ditarik benang.

---

## 🖥️ Daftar Kebutuhan User Interface (UI)

### A. Menu Utama (Main Menu)
- Judul game bergaya kartun/coretan krayon bocah.
- Tombol Start, Options, Exit.
- Frame TV jadul (CRT) dengan efek berkedip/brainwash di latar belakang.

### B. HUD Fase Eksplorasi (Explore HUD)
- Indikator sisa waktu (timer melingkar atau bar waktu yang menyusut).
- Inventori cepat di pojok layar (menunjukkan jumlah Balok Lego, Roda Mainan, Petasan, Balon Karakter yang terkumpul).
- Teks penunjuk tombol kontrol (A-D untuk gerak, W/Spasi untuk lompat).

### C. UI Layar Transisi (Transition Screen)
- Layar rangkuman setelah waktu eksplorasi habis.
- Menampilkan daftar barang terkumpul dengan check-mark lucu bergaya coretan krayon.
- Tombol: "Mulai Merakit!".

### D. HUD Fase Perakitan (Build HUD)
- Grid tempat perakitan (transparan/kotak-kotak garis biru tipis).
- **Panel Inventory (Palette bawah)**: Panel laci mainan/kotak mainan solid tempat menyeret barang.
- Tombol **"ENTER / PLAY"** besar di pojok kanan bawah bergaya tombol plastik mainan anak yang menyala.

---

## 🔊 Daftar Kebutuhan Sound Effects (SFX)

### A. Fase Eksplorasi
- Langkah kaki bocil (cepat dan terburu-buru).
- Suara lompat dan mendarat (suara khas sepatu anak kecil mencicit).
- Suara mengambil barang (suara khas mainan jatuh/koin terkumpul).

### B. Fase Perakitan
- Suara menyeret barang (*drag sound*).
- Suara mengunci mainan (*snapping/clack/Lego click sound*).
- Suara mencopot mainan dari grid (*pop / plastic click sound*).

### C. Fase Chase & Fisika
- Suara roda plastik berputar di lantai kayu/karpet (*rolling plastic wheel sound*).
- Suara desisan kembang api menyala (*fizzing rocket fuse sound*).
- Suara balon tergesek/melayang (*balloon squeak/rubbing*).
- Suara tabrakan plastik/kayu jika mobil menabrak dinding/tanah (*toy crashing sound*).
- Suara ledakan magis/bintang saat berhasil menangkap Peri Gigi (*sparkle victory chime*).
- Suara bel gagal/buzzer kecewa saat mobil terjebak/kalah.

---

## 🎵 Kebutuhan Musik (BGM)
1. **BGM Eksplorasi (Explore Phase)**: Musik bertempo cepat (*upbeat*), sedikit misterius/sembunyi-sembunyi (gaya detektif cilik atau pencuri mainan).
2. **BGM Perakitan (Build Phase)**: Musik santai, bertema kreativitas/puzzle (gaya musik instrumen akustik atau sirkus santai ala *Angry Birds/Bad Piggies*).
3. **BGM Pengejaran (Chase Phase)**: Musik dramatis namun lucu, memberikan rasa urgensi/kemenangan saat mobil meluncur deras ke arah Peri Gigi.
