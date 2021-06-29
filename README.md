# Pencatat Keuangan - Flutter Project

Aplikasi sederhana untuk mencatat aktivitas keuangan sehari-hari.
Diketik menggunakan Flutter dengan penuh :strong:.

Dapat digunakan secara offline.

## Fitur
- [x] Catat transaksi harian
- [x] Rekap transaksi bulanan
- [x] Simpan transaksi secara offline
- [ ] Backup transaksi di awan
- [ ] Cetak daftar transaksi

## Mengkompilasi Aplikasi Ini
Kamu membutuhkan komputer yang sudah dipasangi program Flutter (versi 2.0.3 atau diatasnya) dan Dart (versi 2.12.2 atau diatasnya).
serta Android SDK dan perangkat Android dengan minimal API versi 21 ya!
1. Lakukan klon aplikasi ini di komputermu dengan
   `git clone https://github.com/artemtech/pencatat_keuangan`
   atau klik tombol ---> [Download](https://github.com/artemtech/pencatat_keuangan/archive/refs/heads/master.zip) <----
2. Unzip dan masuk ke direktori `pencatat_keuangan`
3. lakukan get paket dengan cara:
   `flutter pub get`
4. lakukan perintah kompilasi dengan cara:
   `flutter build apk`
5. Hasil build apk berada di folder `build/app/outputs/flutter-apk/app-release.apk`
6. Sambungkan gawai Android dengan komputermu dengan kabel USB, lalu salin ke media penyimpanan.
   Atau bisa juga menggunakan adb untuk langsung memasang ke gawai Android:
   `adb install build/app/outputs/flutter-apk/app-release.apk`

## Lisensi
Aplikasi Pencatat Keuangan ini berlisensi MIT.