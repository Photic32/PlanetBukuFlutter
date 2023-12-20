# Planet Buku 🌍📚 [![Build status](https://build.appcenter.ms/v0.1/apps/24a6aaf4-0af3-4a8e-ae1e-3d0bcad4ce76/branches/main/badge)](https://appcenter.ms)

Tugas Kelompok Akhir Semester PBP E05

Deployed on : https://planetbuku1.firdausfarul.repl.co/ (main deployment), https://planetbukutes-95487a8dd763.herokuapp.com/ (backup deployment)

Donwload on : https://install.appcenter.ms/orgs/photic32/apps/planet-buku-rev/distribution_groups/public


# Anggota Kelompok 👥

1. Alma Laras Bestari (2206082303)
2. Clara Sista Widhiastuti (2206825782)
3. Muhammad Fachrudin Firdaus (2206819331)
4. Marsya Rahmadani (2206028642)
5. Naufal Mahdy Hanif (2206082335)

# Cerita Aplikasi 📖🌐

Aplikasi yang kami kembangkan adalah Planet Buku (e-perpus). Yaitu aplikasi untuk melihat informasi buku dan melakukan peminjaman buku secara online. Aplikasi ini dibuat agar peminjam dapat mengetahui ketersediaan buku dan dapat melihat review dari buku yang ingin dipinjam sebelum datang ke perpustakaan. Dengan mengetahui ketersediaan dan review dari buku sebelum menghabiskan waktu dan energi untuk ke perpustakaan, diharapkan masyarakat bisa jadi lebih tertarik untuk membaca buku.

# Daftar Modul & Integrasi Web Service 🖥️

## Daftar peminjam buku (Admin) 📋👩‍💼 (Fahrul)
Pada modul ini admin dapat melihat daftar dari para peminjam buku dan mengedit detail peminjam buku seperti mengcancel peminjaman yang dilakukan oleh peminjam buku.

Proses pengolahan peminjam akan dilakukan dengan merequest data object Peminjam dari Webserver Django dalam bentuk JSON lalu mengolahnya ke objek Flutter. Hal yang serupa juga akan dilakukan untuk daftar buku yang dipinjam oleh suatu peminjam, akan direquest ke endpoint json lalu akan dijadikan objek Flutter. Endpoint search sama dengan endpoint daftar buku yang dipinjam oleh suatu peminjam sehingga implementasinya sama. Untuk bagian form perpanjang deadline kita tinggal melakukan POST request ke endpoint terkait. Untuk tombol pengembalian buku hanyalah GET request biasa. Karena pada modul ini hanya admin yang bisa mengaksesnya, untuk setiap request kita perlu mengirim cookies yang berisi session id dari admin yang sedang login.

**Endpoint yang digunakan**
  1. `/adminbooks/kembali_buku/<int:id_buku>/` untuk mengembalikan buku. Method `GET`
  2. `/adminbooks/search_book/` untuk mencari buku. Method `GET` 
  3. `/adminbooks/edit_peminjaman/<int:id_peminjaman>/` untuk mengedit peminjaman. Method `POST`
  4. `/adminbooks/all_user_json/` untuk mendapatkan semua data user. Method `GET`
  5. `/adminbooks/pinjaman_json/<int:id>/` untuk mendapatkan detail masing-masing pinjaman. Method `GET`
     
## Edit informasi buku (Admin) 📚✏️ (Marsya)
Admin dapat mengubah detail dari buku, seperti menambah atau mengurangi stok buku, mengubah properti dari buku, dan menambah buku baru atau menghapus buku.

Alur pengeditan informasi buku dilakukan dengan mengirim request data Object Book yang diperlukan untuk menambah, menguraing stock, menghapus dan mengedit buku. 
Untuk menambahkan dan mengedit informasi buku menggunakan Form, akan dikirimkan request dari webserver Django dalam bentuk JSON, kemudian data akan diubah dalam bentuk JSON agar dapat terhubung dengan database. Kemudian akan diatur autentikasi agar hanya admin yang dapat mengedit informasi buku.

## Lihat deskripsi buku (User) 🔍📖 (Alma)
User dapat mencari dan melihat detail dari informasi buku dan melakukan peminjaman, user juga dapat melihat review dan memberikan review pada buku tersebut.

Proses pengolahan buku akan dilakukan dengan merequest data object Book dari Webserver Django dalam bentuk JSON. Hal serupa juga dilakukan untuk melihat review dan pemberian review. Review akan ditampilkan dengan merequest data object Review dari Webserver dalam bentuk JSON. Form review akan diubah dalam bentuk JSON sehingga terhubung dengan database Django. Peminjaman buku juga akan terhubung dengan database Django melalui konversi data ke bentuk JSON.

**Endpoint yang digunakan**
1. `/adminbook/get_books_json/'` untuk mendapatkan semua data buku. Method `GET`
2. `/browse/get-review-json/<int:book_pk>/'` untuk mendapatkan data review sesuai buku yang dilihat. Method `GET`
3. `/browse/add-to-cart-flutter/<int:book_pk>` untuk menambahkan buku pada cart. Method `GET`
4. `/browse/give-review-flutter/<int:book_pk>/` untuk memberikan review. Method `POST`

## Homepage (User) 🏠📱 (Mahdy)
User dapat mendaftarkan akun baru atau login dengan akun yang sudah ada. Pada homepage, user dapat melihat waktu terdekat dari deadline pengembalian buku yang ada. User juga dapat membuka keranjang dari buku yang belum finalisasi peminjaman dan mengedit detail peminjaman pada keranjang.

**Endpoint yang digunakan**
  1. `/auth/login/` untuk login. Method `POST`
  2. `/auth/register/` untuk mendaftarkan akun. Method `GET` 
  3. `/cancel-cart/<id_buku>/` untuk remove buku dari cart cart. Method `POST`
  4. `/add-cart/<id_buku>/` untuk finalisasi peminjaman buku. Method `POST`

Proses autentikasi dan Autorisasi user dilakukan melalui backend webserver, Bagian app hanya menerima variabel-variabel yang akan dilanjutkan ke endpoint webserver lalu diautentikasi oleh fungsi pada backend webserver. 

Proses pengolahan cart juga dilakukan dengan merequest data object cart dari webserver dalam bentuk JSON yang lalu diparse oleh aplikasi menjadi string. Perubahan pada status cart seperti object difinalisasi atau dikeluarkan dari cart juga akan dikirim ke endpoint webserver dan webserver akan melakukan pengelolaan pada object di database.


## Daftar buku yang sedang atau sudah dipinjam (User) 📚🔄 (Clara)
User dapat melihat daftar buku yang sedang dipinjam atau sudah dipinjam. User juga dapat mengembalikan buku yang sedang dipinjam atau memberikan review pada buku.

Proses pengintegrasian diawal dengan pengambilan object buku dengan endpoint JSON untuk mengetahui buku apa saja yang telah dipinjam atau dikembalikan oleh user. Daftar buku yang sedang dipinjam dan telah dikembalikan kemudian akan di tampilkan sesuai respon JSON. Buku yang sedang dipinjam kemudian dapat dikembalikan lalu mengirimkan request ke endpoint json. kemudian web service akan mengupdate data buku. Buku yang telah dikembalikan user dapat menambahkan kesan pada buku tersebut. Form kesan diubah kedalam JSON sehingga terhubung dengan database Django. Untuk menampilkan kesan perlu merequest data object kesan dari webserver.

# Sumber dataset katalog buku 🌐📚
https://www.kaggle.com/datasets/saurabhbagchi/books-dataset

# Role atau peran 👤

## User 👩‍💻
Pengguna yang terautentikasi dan dapat melihat informasi buku, melakukan peminjaman buku, memberi review pada buku, dan melihat halaman-halaman yang tersedia untuk umum.

## Admin 👨‍💼
Pengguna yang memiliki akses ke seluruh page, dapat mengedit buku yang dipinjam oleh user, dapat mengedit buku yang ada.

## Guest 👥🚫
User yang belum melakukan registrasi/login dapat mengakses fitur Register/Login

# Panduan Build
1. Lakukan instalasi flutter pada perangkat anda
  MAC OS: https://docs.flutter.dev/get-started/install/macos 
  Windows: https://docs.flutter.dev/get-started/install/windows 
  Linux: https://docs.flutter.dev/get-started/install/linux 
  Pastikan anda menginstal flutter versi terkini.
2. Instal IDE pilihan anda untuk mengembangkan aplikasi Flutter seperti Visual Studio Code atau Android Studio.
3. Lakukan clone repositori proyek flutter anda.
4. Untuk menjalankan proyek flutter, masuk ke direktori anda menyimpan proyek flutter, kemudian jalankan perintah flutter run pada terminal.
5. Lakukan deployment aplikasi flutter ke AppCenter.
6. Buat key untuk aplikasi dan mengatur automasi agar skrip CI/CD dengan menjalankan perintah berikut

  MAC OS: 
  `keytool -genkey -v -keystore ~/release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release`

  Windows: 
  `keytool -genkey -v -keystore %userprofile%\release-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias release`

7. Pembuatan skrip github action dengan buat sebuah base64 string sebagai representasi dari keystore file yang akan kita simpan.
8. Buat repository secrets pada repository Github, berisi 
  `GH_TOKEN`
, 
  `KEY_JKS`
, dan 
  `KEY_PASSWORD`
9. Tambahkan 
  `staging.yml`
, 
  `pre-release.yml`
, dan 
  `realease.yml`
10. Lakukan penambahan skrip CI/CD untuk App Center, dan lakukan konfigurasi lanjutan pada App Center.
11. Save & build
12. Download hasil build langsung atau melalui link distribution group pada HP anda.
13. jalankan APK pada HP anda.

## Link Tautan Berita Acara
https://docs.google.com/spreadsheets/d/1a4qiDsroPt03P-hFrFFFYoMr1ZF1c-CBWBh9ApLa2BE/edit#gid=0
