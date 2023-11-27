# Planet Buku 🌍📚

Tugas Kelompok Akhir Semester PBP E05

Deployed on : http://planetbuku-e05-tk.pbp.cs.ui.ac.id

# Anggota Kelompok 👥

1. Alma Laras Bestari (2206082303)
2. Clara Sista Widhiastuti (2206825782)
3. Muhammad Fachrudin Firdaus (2206819331)
4. Marsya Rahmadani (2206028642)
5. Naufal Mahdy Hanif (2206082335)

# Cerita Aplikasi 📖🌐

Aplikasi yang kami kembangkan adalah Planet Buku (e-perpus). Yaitu aplikasi untuk melihat informasi buku dan melakukan peminjaman buku secara online. Aplikasi ini dibuat agar peminjam dapat mengetahui ketersediaan buku dan dapat melihat review dari buku yang ingin dipinjam sebelum datang ke perpustakaan. Dengan mengetahui ketersediaan dan review dari buku sebelum menghabiskan waktu dan energi untuk ke perpustakaan, diharapkan masyarakat bisa jadi lebih tertarik untuk membaca buku.

# Daftar Modul & Integrasi Web Service 🖥️

## Daftar peminjam buku (Admin) 📋👩‍💼
Pada modul ini admin dapat melihat daftar dari para peminjam buku dan mengedit detail peminjam buku seperti mengcancel peminjaman yang dilakukan oleh peminjam buku.

## Edit informasi buku (Admin) 📚✏️
Admin dapat mengubah detail dari buku, seperti menambah atau mengurangi stok buku, mengubah properti dari buku, dan menambah buku baru atau menghapus buku.

## Lihat deskripsi buku (User) 🔍📖
User dapat mencari dan melihat detail dari informasi buku dan melakukan peminjaman, user juga dapat melihat review dan memberikan review pada buku tersebut.

Proses pengolahan buku akan dilakukan dengan merequest data object Book dari Webserver Django dalam bentuk JSON. Hal serupa juga dilakukan untuk melihat review dan pemberian review. Review akan ditampilkan dengan merequest data object Review dari Webserver dalam bentuk JSON. Form review akan diubah dalam bentuk JSON sehingga terhubung dengan database Django. Peminjaman buku juga akan terhubung dengan database Django melalui konversi data ke bentuk JSON. 

## Homepage (User) 🏠📱
User dapat mendaftarkan akun baru atau login dengan akun yang sudah ada. Pada homepage, user dapat melihat waktu terdekat dari deadline pengembalian buku yang ada. User juga dapat membuka keranjang dari buku yang belum finalisasi peminjaman dan mengedit detail peminjaman pada keranjang.

Proses autentikasi dan Autorisasi user dilakukan melalui backend webserver, Bagian app hanya menerima variabel-variabel yang akan dilanjutkan ke endpoint webserver lalu diautentikasi oleh fungsi pada backend webserver. 

Proses pengolahan cart juga dilakukan dengan merequest data object cart dari webserver dalam bentuk JSON yang lalu diparse oleh aplikasi menjadi string. Perubahan pada status cart seperti object difinalisasi atau dikeluarkan dari cart juga akan dikirim ke endpoint webserver dan webserver akan melakukan pengelolaan pada object di database.


## Daftar buku yang sedang atau sudah dipinjam (User) 📚🔄
User dapat melihat daftar buku yang sedang dipinjam atau sudah dipinjam. User juga dapat memberikan review buku atau memperpendek durasi peminjaman buku yang sedang dipinjam.

# Sumber dataset katalog buku 🌐📚
https://www.kaggle.com/datasets/saurabhbagchi/books-dataset

# Role atau peran 👤

## User 👩‍💻
Pengguna yang terautentikasi dan dapat melihat informasi buku, melakukan peminjaman buku, memberi review pada buku, dan melihat halaman-halaman yang tersedia untuk umum.

## Admin 👨‍💼
Pengguna yang memiliki akses ke seluruh page, dapat mengedit buku yang dipinjam oleh user, dapat mengedit buku yang ada.

## Guest 👥🚫
User yang belum melakukan registrasi/login dapat mengakses fitur Register/Login

## Link Tautan Berita Acara
https://docs.google.com/spreadsheets/d/1a4qiDsroPt03P-hFrFFFYoMr1ZF1c-CBWBh9ApLa2BE/edit#gid=0