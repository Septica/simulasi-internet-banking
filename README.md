### Tugas Besar IF1210/Dasar Pemrograman sem. 2 2016/2017
# Simulasi Internet banking
Versi Custom
## Deskripsi Persoalan
Sebuah bank XYZ menyediakan sebuah program Internet Banking untuk nasabahnya agar dapat mengakses layanan perbankan melalui internet. Untuk dapat mengakses layanan internet banking, nasabah diharuskan login dengan menggunakan username dan password yang diberikan. Nasabah dapat memiliki beberapa rekening yang dapat diakses menggunakan username yang sama. Sebuah rekening hanya memiliki satu pemilik saja. Setelah login, nasabah dapat membuat rekening online baru, melihat saldo yang dimiliki pada rekening yang dimiliki, serta melakukan berbagai transaksi. Selain itu, dia juga dapat melihat daftar transaksi terakhir yang dilakukan dalam kurun waktu maksimal 3 bulan terakhir. Ada 3 jenis rekening online, yaitu: tabungan mandiri, deposito, dan tabungan rencana.

Untuk pembuatan rekening tabungan mandiri, nasabah harus memberikan setoran minimum sebesar 50.000 rupiah. Tabungan mandiri hanya disediakan untuk mata uang Rupiah (IDR).

Untuk pembuatan deposito baru, nasabah harus mendaftarkan mata uang yang akan digunakan dalam penyimpanan deposito. Ada 3 mata uang yang ditentukan, yaitu Rupiah (IDR), US Dollar (USD), dan euro (EUR). Selanjutnya, nasabah menentukan setoran awal deposito yang minimum harus memenuhi ketentuan berikut: untuk IDR minimum 8.000.000 rupiah, untuk USD minimum 600 US Dollar, dan untuk EUR minimum 550 euro. Nasabah juga diminta menentukan rentang waktu deposito, yaitu 1 bulan, 3 bulan, 6 bulan, atau 12 bulan. Harus dicatat pula, tanggal pertama kali memulai deposito. Jika nasabah sudah memiliki tabungan mandiri, maka dapat didefinisikan rekening autodebet dari salah satu rekening tabungan mandiri.

Tabungan rencana hanya disediakan untuk mata uang Rupiah (IDR). Untuk pembuatan rekening online jenis tabungan rencana baru, tidak ada ketentuan khusus terkait setoran awal (nasabah bisa memberikan setoran awal 0 rupiah, bisa juga lebih). Namun nasabah harus menentukan jumlah setoran rutin bulanan dan besarnya minimum 500.000 rupiah. Nasabah juga harus menentukan jangka waktu tabungan, yaitu minimum 1 tahun dan maksimum 20 tahun. Harus dicatat juga tanggal pembuatan tabungan rencana ini. Jika nasabah sudah memiliki tabungan mandiri, maka dapat didefinisikan rekening autodebet dari salah satu rekening tabungan mandiri.

Nasabah dapat melakukan berbagai transaksi dengan menggunakan rekening-rekeningnya. Beberapa jenis transaksi yang dapat dilakukan: setoran/penarikan, transfer, pembayaran, dan pembelian.

Nasabah dapat memberikan setoran tunai yang dapat dilakukan kapan pun. Nasabah dapat melakukan penarikan asalkan sudah memenuhi waktu jatuh tempo (jika berlaku). Untuk deposito dan tabungan rencana, waktu jatuh tempo dihitung dari tanggal pembuatan rekening ke jangka waktu yang ditentukan untuk rekening tersebut. Jika waktu jatuh tempo belum dipenuhi, maka penarikan ditolak. Tabungan mandiri tidak memiliki waktu jatuh tempo sehingga dapat ditarik kapan pun. Penarikan juga ditolak untuk jumlah penarikan yang lebih besar dari jumlah dana yang ada di dalam rekening.

Nasabah dapat melakukan transfer uang dari rekeningnya sendiri, baik itu transfer ke sesama rekening bank XYZ (termasuk ke rekeningnya sendiri) maupun transfer ke rekening di bank lain. Ketentuan transfer mengikuti ketentuan yang sama dengan transaksi penarikan (lihat penjelasan di atas).

Selain itu, nasabah juga dapat melakukan pembayaran listrik, BPJS, PDAM, telepon, TV kabel, internet, kartu kredit, pajak, dan biaya pendidikan dengan menggunakan dana yang tersimpan dalam rekeningnya dengan memeriksa ketentuan yang sama dengan transaksi penarikan. Pembayaran listrik, BPJS, PDAM, telepon, TV kabel, internet dilakukan paling lambat pada tanggal 15 setiap bulannya. Jika melebihi, maka dikenakan denda per hari.

Nasabah juga dapat melakukan pembelian voucher HP, listrik pra bayar, dan taksi online. Untuk tiap barang yang bisa dibeli ada kategori/harga tertentu yang harus dibayar.

Selain melakukan transaksi, nasabah dapat memeriksa saldo terakhir pada rekeningnya. Selain itu, dia juga dapat melihat aktivitas transaksi bank online pada rekeningnya mulai dari 1 hari s.d. 3 bulan terakhir. Data yang dapat dilihat meliputi tanggal, waktu, jenis transaksi, mata uang, rekening yang terlibat dalam transaksi, dan rekening tujuan transaksi.

Nasabah dapat juga mengubah data-data pribadinya, yaitu mengubah nama, alamat, kota, e-mail, nomor telepon, dan password. Nasabah dapat juga membatalkan suatu rekening yang dimilikinya. Untuk rekening deposito dan tabungan rencana, jika penutupan dilakukan sebelum tanggal jatuh tempo, maka akan dikenakan biaya tambahan/penalti.

## Struktur Data File Eksternal
Program untuk mengakses layanan Internet Banking tersebut membaca beberapa data dari file eksternal sbb.

File eksternal berisi data **nasabah** (termasuk username dan password untuk akses) sebagai berikut
```
Nomor Nasabah | Nama Nasabah | Alamat | Kota | Email | Nomor Telp | Username | Password | Status
```
Catatan: Field `Status` bernilai `aktif` atau `inaktif`. Jika status `inaktif`, maka nasabah tidak dapat menggunakan akun internet bankingnya.

Contoh:
```
BUD389 | Budi | Cibeunying | Bandung | budi@budi.org | 087201877837 | budi | budi2016! | aktif
IRN387 | Masha | Perum Bumi Indah Blok F1-19 Dago, Coblong | Bandung | masha@bear.com | 086425796324 | masha | masha2016# | aktif
```

File eksternal berisi data **rekening online** dengan format sebagai berikut:
```
Nomor Akun | Nomor Nasabah | Jenis Rekening | Mata Uang | Saldo | Setoran Rutin | Rekening Autodebet | Jangka Waktu | Tanggal Mulai
```
Catatan: `Nomor Nasabah` yang ada di daftar rekening online harus merupakan salah satu `Nomor Nasabah` di data nasabah. Field ini digunakan untuk menyatakan bahwa akun rekening online tersebut adalah milik dari nasabah dengan nomor tersebut. Field `Rekening Autodebet`, jika tidak kosong, berisi nomor rekening yang berjenis tabungan mandiri.

Contoh:
```
2HE297 | BUD389 | deposito | USD | 1500 | 0 | IXY789 | 3 bulan | 25-10-2015
1XY789 | BUD389 | tabungan mandiri | IDR | 4500000 | 0 | - | - | 28-10-2015
4ER789 | IRN387 | tabungan rencana | IDR | 1500000 | 500000 | - | 1 tahun | 24-10-2015
```

File eksternal berisi data **transaksi setoran/penarikan** dengan format sebagai berikut:
```
Nomor Akun | Jenis Transaksi | Mata Uang | Jumlah | Saldo | Tanggal Transaksi
```
Catatan: `Nomor Akun` yang ada di daftar transaksi harus merupakan salah satu `Nomor Akun` di data rekening online. Field ini digunakan untuk menyatakan bahwa nomor akun tersebut adalah yang terlibat dalam transaksi. Field `Saldo` berisi saldo rekening asal setelah terjadi transaksi.

Contoh:
```
1XY789 | setoran | IDR | 900000 | 5900000 | 20-09-2016
4ER789 | setoran | IDR | 500000 | 1000000 | 28-11-2016
2HE297 | penarikan | USD | 500 | 8000 | 25-10-2016
```

File eksternal berisi data **transaksi transfer** dengan format sebagai berikut:
```
Nomor Akun Asal | Nomor Akun Tujuan | Jenis Transfer | Nama Bank Luar | Mata Uang | Jumlah | Saldo | Tanggal Transaksi
```
Catatan: `Nomor Akun Asal` yang ada di daftar transaksi harus merupakan salah satu `Nomor Akun` di data rekening online. Field ini digunakan untuk menyatakan bahwa nomor akun tersebut adalah yang terlibat dalam transaksi. Field `Jenis Transfer` menyatakan apakah transfer ini `dalam bank` (rekening tujuan adalah rekening bank XYZ) atau `antar bank` (rekening tujuan adalah rekening bank lain). Field `Nomor Akun Tujuan` digunakan untuk menyimpan nomor rekening tujuan. Jika `Jenis Transfer` adalah `dalam bank`, maka harus diperiksa apakah rekening tujuan tersebut ada dalam daftar rekening online atau tidak. Jika tidak ada, maka transaksi ditolak. Untuk transfer ke bank lain, diasumsikan nomor rekening yang diberikan adalah benar dan field `Nama Bank Luar` harus diisi. Field `Saldo` berisi saldo rekening asal setelah terjadi transaksi.

Contoh:
```
1XY789 | 2HE297 | dalam bank | - | IDR | 500000 | 5310000| 23-09-2016
1XY789 | DFTR23 | antar bank | Bank PQR | IDR | 500000 | 4910000| 24-09-2016
```

File eksternal berisi data **transaksi pembayaran** dengan format sebagai berikut:
```
Nomor Akun | Jenis Transaksi | Rekening Bayar | Mata Uang | Jumlah | Saldo | Tanggal Transaksi
```
Catatan: `Nomor Akun` yang ada di daftar transaksi harus merupakan salah satu `Nomor Akun` di data rekening online. Field ini digunakan untuk menyatakan bahwa nomor akun tersebut adalah yang terlibat dalam tranasksi. Field `Rekening Bayar` digunakan untuk menyimpan data nomor-nomor rekening tujuan yang terlibat, misalnya nomor kartu kredit, nomor rekening listrik, PDAM, dsb. Field `Saldo` berisi saldo rekening setelah terjadi transaksi.

Contoh:
```
1XY789 | telepon | 022649564 | IDR | 100000 | 5810000 | 22-09-2016
4ER789 | pendidikan | 21998998e9r | IDR | 5000000 | 1000000 | 24-11-2016
```

File eksternal berisi data **transaksi pembelian** dengan format sebagai berikut:
```
Nomor Akun | Jenis Barang | Penyedia | Nomor Tujuan | Mata Uang | Jumlah | Saldo | Tanggal Transaksi
```
Catatan: `Nomor Akun` yang ada di daftar transaksi harus merupakan salah satu `Nomor Akun` di data rekening online. Field ini digunakan untuk menyatakan bahwa nomor akun tersebut adalah yang terlibat dalam transaksi. Field Nomor Tujuan digunakan untuk mencatat nomor telepon, nomor rekening listrik, atau nomor rekening taksi online. Field `Saldo` berisi saldo rekening setelah terjadi transaksi.

Contoh:
```
1XY789 | Voucher HP | Indonesia Cellular | 0813567649564 | IDR | 10000 | 5810000 | 22-09-2016
1XY789 | Taksi Online | My-Ride | 2998398| IDR | 500000 | 5310000| 23-09-2016
```

File eksternal yang berisi data **nilai tukar antar mata uang** adalah sebagai berikut:
```
Nilai Kurs Asal | Kurs Asal | Nilai Kurs Tujuan | Kurs Tujuan
```
Contoh:
```
1 | USD | 13300 | IDR
1 | USD | 0.94 | EUR
```

File eksternal yang berisi data **barang yang dapat dibeli melalui Internet Banking** adalah sebagai berikut:
```
Jenis Barang | Penyedia | Harga
```
Contoh:
```
Voucher HP | Indonesia Cellular | 10000
Voucher HP | Indonesia Cellular | 50000
Voucher HP | Indonesia Cellular | 100000
Voucher HP | Indonesia Cellular | 1000000
Voucher HP | Cell-My | 100000
Voucher HP | Cell-My | 200000
Listrik | PLN | 10000
Listrik | PLN | 50000
Listrik | PLN | 100000
Taksi Online | My-Ride | 100000
```

## Tugas
Buatlah sebuah program dengan bahasa Pascal yang mengelola simulasi internet banking dengan fitur-fitur
sebagai berikut:
1. **F1-load**: membaca semua data dari file dan load ke dalam struktur data internal (array).
2. **F2-login**: memasukkan username dan password lalu mencari apakah username tersebut ada dan apakah password sesuai. Login salah hanya dapat dilakukan 3 kali berturut-turut. Jika tidak berhasil, maka program keluar dan status nasabah menjadi `inaktif` . Tanggal login digunakan sebagai tanggal transaksi yang akan dilakukan selanjutnya (setelah login).
3. **F3-lihatRekening**: menampilkan daftar rekening online yang dimiliki oleh nasabah.
4. **F4-informasiSaldo**: menampilkan informasi saldo dari suatu rekening. Nasabah dapat memilih dari daftar rekening yang dimilikinya, baik rekening tabungan mandiri, deposito, atau pun tabungan rencana.
5. **F5-lihatAktivitasTransaksi**: menampilkan aktivitas transaksi online pada suatu rekening tertentu berdasarkan periode aktifitas yang diinginkan, minimum 1 hari dan maksimum 3 bulan terakhir.
6. **F6-pembuatanRekening**: membuat rekening online sesuai ketentuan pada penjelasan di atas. Nasabah memilih terlebih dahulu akan membuat rekening tabungan mandiri, deposito, atau tabungan rencana.
7. **F7-setoran**: menyetor sejumlah uang secara tunai ke suatu rekening tertentu.
8. **F8-penarikan**: menarik sejumlah uang secara tunai dari suatu rekening tertentu. Untuk deposito dan tabungan rencana, penarikan hanya dapat dilakukan jika tanggal jatuh tempo sudah terpenuhi. Lihat kembali penjelasan di atas.
9. **F9-transfer**: transfer dana ke rekening atau bank lain. Transfer ke sesama rekening Bank XYZ tidak dikenakan biaya. Transfer antar bank akan dikenakan biaya administrasi sebesar 5.000 rupiah. Jika rekening bank lain tersebut dalam mata uang asing, yaitu USD dan EUR, maka dikenakan biaya masing-masing 2 US Dollar dan 2 Euro. Transfer antar rekening dapat dilakukan antara rekening dengan mata uang berbeda dan nilai mata uang dihitung berdasarkan data nilai tukar mata uang. Transfer hanya dapat dilakukan jika memenuhi ketentuan penarikan tabungan. Lihat kembali penjelasan di atas.
10. **F10-pembayaran**: pembayaran listrik, BPJS, PDAM, telepon, TV kabel, internet, kartu kredit, pajak, dan biaya pendidikan. Listrik, BPJS, PDAM, telepon, TV kabel, dan internet tiap bulan harus dibayarkan sebelum tanggal 15. Bila lewat, maka akan ditambahkan denda rupiah 10.000/hari. Pembayaran hanya dapat dilakukan jika memenuhi ketentuan penarikan tabungan. Lihat kembali penjelasan di atas.
11. **F11-pembelian**: pembelian voucher HP, listrik dan taksi online. Nasabah memilih dahulu dari daftar barang yang disediakan, lalu memasukkan nomor tujuan (nomor HP, rekening listrik, atau rekening taksi online). Pembayaran hanya dapat dilakukan jika memenuhi ketentuan penarikan tabungan. Lihat kembali penjelasan di atas.
12. **F12-penutupanRekening**: nasabah dapat menutup rekening yang telah dibukanya. Dana dari rekening online yang ditutup dapat dipindahkan ke rekening lain yang dimilikinya atau diambil secara tunai. Penutupan rekening dikenakan biaya 25.000 rupiah yang diambil dari dana rekening ditutup yang akan dikembalikan ke nasabah. Jika rekening yang ditutup adalah deposito dan penutupan dilakukan sebelum tanggal jatuh tempo, maka dikenakan penalti sebesar adalah 10.000 rupiah/sisa hari menuju tanggal jatuh tempo. Untuk tabungan rencana, penutupan sebelum tanggal jatuh tempo dikenakan biaya tambahan yang dipukul rata sebesar 200.000 rupiah. Rekening yang ditutup kemudian dihapus dari data rekening online.
13. **F13-perubahanDataNasabah**: mengubah profile data nasabah, kecuali untuk nomor nasabah dan username (tidak boleh diubah).
14. **F14-penambahanAutoDebet**: mengubah rekening autodebet untuk rekening jenis deposito dan tabungan rencana dari salah satu rekening tabungan mandiri (jika ada).
15. **F15-exit**: keluar dari program, dan menyimpan semua perubahan data ke file eksternal.

Catatan:
1. Pembagian fitur/fungsionalitas di atas tidak merepresentasikan dekomposisi modul, fungsi, dan prosedur yang sesungguhnya.
2. Semua masukan program, kecuali disebutkan secara khusus, tidak perlu dilakukan validasi.
3. Untuk tanggal pembuatan rekening dan tanggal transaksi dapat (tidak wajib) menggunakan fungsi untuk mendapatkan current date yang dimiliki Pascal.

## Bonus
Fitur berikut tidak harus diimplementasikan dalam program Anda, tetapi apabila diimplementasikan akan menambah nilai tugas anda maksimum 10% dari skala penilaian normal.
1. **B1-checkErrorLoading**: mengecek jika ada format file eksternal yang salah pada saat loading, atau pemberian perintah yang salah pada antarmuka dan memberikan error message (buatlah spesifikasinya secara lebih persis).
2. **B2-validasi**: menambahkan fitur untuk melakukan melakukan validasi terhadap berbagai hal yang membutuhkan pengecekan (buatlah spesifikasinya secara lebih persis).
3. **B3-unit**: Program dibuat dengan memanfaatkan unit dalam Pascal. Struktur modul/unit yang dipakai harus dideskripsikan dalam laporan.
