# 🎮 Gameseed: Toy-Building Physics Puzzle Game

Prototype game 2D berbasis fisika dan rakit-bangun (*build and play*) yang dikembangkan menggunakan **Godot 4.6**. 

Pemain mengumpulkan part-part mainan di dalam rumah, merakitnya di kamar tidur (gaya *Bad Piggies*), lalu meluncurkannya menuruni meja belajar dan terbang melewati pelontar untuk menangkap **Peri Gigi**.

---

## 📝 Ringkasan Konsep Game & Loop Gameplay

* **Tema Estetika**: Cozy, kekanak-kanakan, penuh warna (*colorful*), dengan nuansa misterius (cuci otak lewat acara TV jadul).
* **Loop Gameplay**:
  1. **Fase Eksplorasi (Explore)**: Pemain mengendalikan karakter bocil (side-scroller gaya *Little Misfortune*) berlari mengelilingi rumah untuk mengumpulkan part mainan yang tersebar secara acak sebelum waktu habis.
  2. **Fase Perakitan (Build)**: Pemain merakit kendaraan mainan di atas meja kamar tidur menggunakan barang-barang yang terkumpul dengan sistem grid drag-and-drop.
  3. **Fase Pengejaran (Chase)**: Kendaraan meluncur turun bebas akibat gravitasi menuju papan pelontar. Pemain mengaktifkan dorongan petasan/balon di udara untuk mengarahkan mobil menabrak Peri Gigi yang melayang.

---

## 🎨 Kebutuhan Aset Tim (Art, UI, SFX, BGM)

### A. Art (2D) & Animasi
* **Bocil (Player - Explore Phase)**: Sprite sheet animasi *Idle* (diam), *Run* (lari terburu-buru), dan *Jump/Fall* (lompat rintangan).
* **Peri Gigi (Finish Line - Chase Phase)**: Sprite melayang dengan kepakan sayap kecil + efek kerlipan debu peri (*fairy dust*).
* **Explore Background**: Interior rumah parallax (lemari, lampu gantung, sofa, meja makan untuk dipanjat).
* **Build/Chase Background**: Kamar tidur anak (kasur, jendela besar berlatar langit malam berbintang).
* **Komponen Kendaraan (Barang Koleksi)**:
  - **Balok Lego / Balok Kayu** (Chassis Utama): Blok plastik berwarna cerah merah/biru/kuning atau balok kayu mainan alfabet.
  - **Roda Mobil Mainan / Yo-Yo** (Roda): Roda plastik velg kuning (gaya Lego/Hotwheels) atau yo-yo kayu bekas.
  - **Petasan Cilik / Kunci Putar** (Pendorong): Kembang api roket kecil dengan lakban (mengeluarkan percikan api) atau kunci putar mainan plastik.
  - **Balon Karakter Foil / Baling Kertas** (Pengangkat): Balon helium berbentuk anjing/dinosaurus tiup atau baling-baling helikopter plastik.

### B. User Interface (UI)
* **Main Menu**: Judul game bergaya coretan krayon + frame TV tabung jadul (CRT) berkedip.
* **Explore HUD**: Indikator timer menyusut + inventori cepat koleksi barang di sudut layar.
* **Layar Transisi**: Rangkuman barang yang berhasil dikumpulkan dengan centang krayon lucu + tombol "Mulai Merakit!".
* **Build HUD**: Panel kotak mainan solid di bawah untuk menampung inventory + grid perakitan transparan biru.

### C. Sound Effects (SFX)
* **Explore**: Langkah kaki bocil, suara sepatu mencicit saat lompat, dan denting manis saat mengumpulkan barang.
* **Build**: Suara seret barang (*drag*), suara Lego mengunci (*clack/Lego click*), dan suara mencopot part (*pop/plastic click*).
* **Chase**: Desisan kembang api roket (*rocket fuse*), derit roda plastik, suara balon tergesek (*balloon squeak*), suara tabrakan plastik/kayu saat mobil jatuh (*toy crash*), suara kemenangan magis saat menangkap Peri Gigi, dan bel kegagalan saat terjebak.

### D. Musik Latar (BGM)
* **BGM Explore**: Musik bertempo cepat (*upbeat*) bernuansa misterius/sembunyi-sembunyi (gaya detektif cilik).
* **BGM Build**: Musik santai bertema kreativitas/puzzle (gaya instrumen akustik ala *Bad Piggies*).
* **BGM Chase**: Musik lucu bernuansa tegang/urgensi saat mobil meluncur ke Peri Gigi.

---

## 🗺️ Roadmap & Progress Checklist Program

### 1. Narasi & Tema (TV Brainwash)
- [ ] **Pending**: Layar cutscene pembuka (TV CRT jadul berkedip dengan teks brainwash provokatif).
- [ ] **Pending**: CRT Shader / Glitch Effect (efek TV tabung opsional).

### 2. Sesi 1: Explore Phase (Eksplorasi Rumah)
- [x] **Done**: Gerakan player 2D (WASD/Tombol Arah + Lompat).
- [x] **Done**: Spawn barang acak lengkap dengan label nama melayang di atasnya.
- [x] **Done**: Sistem inventory global yang mencatat barang terkumpul.
- [x] **Done**: Desain Rumah (Level Map) – Membuat layout rintangan perabot rumah asli di `Explore.tscn` (meja, tangga, lemari, kasur di lantai dua, dan steps melayang).
- [ ] **Pending**: Durasi Asli – Menyesuaikan durasi eksplorasi asli (saat ini 20 detik untuk testing).

### 3. Layar Transisi Antar Fase (Transition Screen)
- [x] **Done**: Layar jeda rangkuman barang terkumpul sebelum masuk ke kamar (`Transition.tscn` dengan visual checklist kertas krayon, visual hover anim, dan integrasi inventory).

### 4. Sesi 2: Build Phase (Perakitan di Kamar)
- [x] **Done**: Grid snapping perakitan dengan drag & drop dari panel tombol UI bawah (menggunakan sistem `GridDrawer` agar tidak tertutup background).
- [x] **Done**: Visual ruangan kamar tidur (kasur, meja belajar, jendela).
- [x] **Done**: Timer Perakitan – Batas waktu perakitan 60 detik (countdown aktif setelah part pertama dipasang, auto-launch saat habis).
- [x] **Done**: Tombol Reset Perakitan – Menghapus seluruh rakitan di grid langsung ke tas secara instan (QoL button "Reset" & "Luncurkan!").

### 5. Sesi 3: Chase / Test Phase (Pengejaran Peri Gigi)
- [x] **Done**: Level physics (Meja $\rightarrow$ Papan Turun $\rightarrow$ Lantai Karpet $\rightarrow$ Papan Pelontar).
- [x] **Done**: Mekanik berkendara (Kipas menyala dengan SPASI, Balon mengangkat otomatis).
- [x] **Done**: Stuck & out-of-bounds detection (auto-restart 3 detik jika gagal).
- [x] **Done**: Garis finish Peri Gigi (auto-loop 4 detik jika menang).
- [ ] **Pending**: AI/Gerakan Peri Gigi – Membuat Peri Gigi bergerak terbang berputar/menghindar.
- [ ] **Pending**: Integrasi Aset Gambar – Menggunakan gambar `kardus.png` dan `papan.png` asli sebagai tekstur bagian kendaraan.

---

## 🛠️ Cara Menjalankan Project di Godot 4
1. Clone repositori ini: `git clone https://github.com/Akabim/gameseed.git`
2. Buka **Godot Engine (versi 4.0 ke atas)**.
3. Klik **Import**, lalu pilih file `project.godot` di dalam folder ini.
4. Tekan **F5** atau klik tombol Play di pojok kanan atas untuk mencoba game prototype.
