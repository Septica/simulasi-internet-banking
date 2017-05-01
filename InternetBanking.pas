program InternetBanking;
(* UNIT *)
uses
    sysutils, dateutils;

(* KAMUS GLOBAL *)
const
    NMax = 10;

type
    TNasabah = record
        nomorNasabah, namaNasabah, alamat, kota, email, nomorTelp, username, password, status : string;
    end;
    TRekeningOnline = record
        nomorAkun, nomorNasabah, jenisRekening, mataUang, rekeningAutodebet : string;
        saldo, setoranRutin : longint;
        jangkaWaktu : double;
        tanggalMulai : TDateTime;
    end;
    TTransaksiSetoranPenarikan = record
        nomorAkun, jenisTransaksi, mataUang : string;
        jumlah, saldo : longint;
        tanggalTransaksi : TDateTime;
    end;
    TTransaksiTransfer = record
        nomorAkunAsal, nomorAkunTujuan, jenisTransfer, namaBankLuar, mataUang : string;
        jumlah, saldo : longint;
        tanggalTransaksi : TDateTime;
    end;
    TPembayaran = record
        nomorAkun, jenisTransaksi, rekeningBayar, mataUang : string;
        jumlah, saldo : longint;
        tanggalTransaksi : TDateTime;
    end;
    TPembelian = record
        nomorAkun, jenisBarang, penyedia, nomorTujuan, mataUang : string;
        jumlah, saldo : longint;
        tanggalTransaksi : TDateTime;
    end;
    TNilaiTukarAntarMataUang = record
        nilaiKursAsal, nilaiKursTujuan : real;
        kursAsal, kursTujuan : string;
    end;
    TBarang = record
        jenisBarang : string;
        penyedia : string;
        harga : longint;
    end;

    TNasabahArray = record
        T : array[1..NMax] of TNasabah;
        Neff : integer;
    end;
    TRekeningOnlineArray = record
        T : array[1..NMax] of TRekeningOnline;
        Neff : integer;
    end;
    TTransaksiSetoranPenarikanArray = record
        T : array[1..NMax] of TTransaksiSetoranPenarikan;
        Neff : integer;
    end;
    TTransaksiTransferArray = record
        T : array[1..NMax] of TTransaksiTransfer;
        Neff : integer;
    end;
    TPembayaranArray = record
        T : array[1..NMax] of TPembayaran;
        Neff : integer;
    end;
    TPembelianArray = record
        T : array[1..NMax] of TPembelian;
        Neff : integer;
    end;
    TNilaiTukarAntarMataUangArray = record
        T : array[1..NMax] of TNilaiTukarAntarMataUang;
        Neff : integer;
    end;
    TBarangArray = record
        T : array[1..NMax] of TBarang;
        Neff : integer;
    end;

var
    nasabahArray : TNasabahArray;
    rekeningOnlineArray : TRekeningOnlineArray;
    transaksiSetoranPenarikanArray : TTransaksiSetoranPenarikanArray;
    transaksiTransferArray : TTransaksiTransferArray;
    pembayaranArray : TPembayaranArray;
    pembelianArray : TPembelianArray;
    nilaiTukarAntarMataUangArray : TNilaiTukarAntarMataUangArray;
    barangArray : TBarangArray;

    nasabahFile : file of TNasabah;
    rekeningOnlineFile : file of TRekeningOnline;
    transaksiSetoranPenarikanFile : file of TTransaksiSetoranPenarikan;
    transaksiTransferFile : file of TTransaksiTransfer;
    pembayaranFile : file of TPembayaran;
    pembelianFile : file of TPembelian;
    nilaiTukarAntarMataUangFile : file of TNilaiTukarAntarMataUang;
    barangFile : file of TBarang;

    triesArray : array[1..NMax] of integer;
    index_nasabah : integer = 0;
    current_nasabah : string = '';

    command : string;

procedure WriteRekening(rekeningOnlineArray : TRekeningOnlineArray);
(* KAMUS LOKAL *)
var
    i : integer;

(* ALGORITMA *)
begin
    for i := 1 to rekeningOnlineArray.Neff do
        writeln(i, '. ', rekeningOnlineArray.T[i].nomorAkun);
end;

procedure DeleteRekening(i : integer; var rekeningOnlineArray : TRekeningOnlineArray);
(* ALGORITMA *)
begin
    if i > 0 then
    begin
        rekeningOnlineArray.Neff := rekeningOnlineArray.Neff - 1;
        for i := i to rekeningOnlineArray.Neff do
            rekeningOnlineArray.T[i] := rekeningOnlineArray.T[i+1];
    end;
end;

function getIndexRekening(nomorAkun : string; rekeningOnlineArray : TRekeningOnlineArray) : integer;
(* KAMUS LOKAL *)
var
    i : integer = 0;

(* ALGORITMA *)
begin
    if rekeningOnlineArray.Neff > 0 then
    begin
        repeat
            i := i + 1;
        until (i >= rekeningOnlineArray.Neff) or (rekeningOnlineArray.T[i].nomorAkun = nomorAkun);
        if rekeningOnlineArray.T[i].nomorAkun = nomorAkun then
            getIndexRekening := i
        else
            getIndexRekening := 0;
    end;
end;

function getRekening(nasabah : string; tabunganMandiri, tabunganRencana, deposito : boolean) : TRekeningOnlineArray;
(* KAMUS LOKAL *)
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    i : integer;

(* ALGORITMA *)
begin
    temp_rekeningOnlineArray.Neff := 0;
    for i := 1 to rekeningOnlineArray.Neff do
        if  (rekeningOnlineArray.T[i].nomorNasabah = nasabah) 
            and
            (   
                (   (rekeningOnlineArray.T[i].jenisRekening = 'Tabungan Mandiri') and tabunganMandiri) 
                or 
                (   (rekeningOnlineArray.T[i].jenisRekening = 'Tabungan Rencana') and tabunganRencana) 
                or 
                (   (rekeningOnlineArray.T[i].jenisRekening = 'Deposito') and deposito)
            )
        then
        begin
            temp_rekeningOnlineArray.Neff := temp_rekeningOnlineArray.Neff + 1;
            temp_rekeningOnlineArray.T[temp_rekeningOnlineArray.Neff] := rekeningOnlineArray.T[i];
        end;
    getRekening := temp_rekeningOnlineArray;
end;

function getKurs(kursAsal, kursTujuan : string; nilai : longint) : longint;
(* KAMUS LOKAL *)
var
    i : integer = 0;

(* ALGORITMA *)
begin
    if (nilaiTukarAntarMataUangArray.Neff > 0) and (kursAsal <> kursTujuan) then
    begin
        repeat
            i := i + 1;
        until   (nilaiTukarAntarMataUangArray.T[i].kursAsal = kursAsal)
                and
                (nilaiTukarAntarMataUangArray.T[i].kursTujuan = kursTujuan);
        getKurs := round(nilai * nilaiTukarAntarMataUangArray.T[i].nilaiKursTujuan / nilaiTukarAntarMataUangArray.T[i].nilaiKursAsal);
    end else getKurs := nilai;
end;

function generateNomorAkun(i, n : integer; t : string) : string;
(* ALGORITMA *)
begin
    if t = '1' then t := 'DP' else
    if t = '2' then t := 'TR' else
    if t = '3' then t := 'TM' else
        t := 'UK';
    generateNomorAkun := IntToStr(i mod 10) + t + Format('%.2d', [n]) + IntToStr((i * n) mod 10);
end;

function isOwner(indexRekening : integer; nomorNasabah : string) : boolean;
(* ALGORITMA *)
begin
    isOwner := rekeningOnlineArray.T[indexRekening].nomorNasabah = nomorNasabah;
end;

function defineRekeningAutoDebet() : string;
(* KAMUS LOKAL *)
var
    tabunganMandiri_rekeningOnlineArray : TRekeningOnlineArray;
    indexRekening : integer;

    nomorAkun : string;

(* ALGORITMA *)
begin
    tabunganMandiri_rekeningOnlineArray := getRekening(current_nasabah, true, false, false);
    if tabunganMandiri_rekeningOnlineArray.Neff > 0 then
        repeat
            writeln('Pilih rekening Autodebet Anda:');
            WriteRekening(tabunganMandiri_rekeningOnlineArray);
            writeln(tabunganMandiri_rekeningOnlineArray.Neff + 1, '. -');

            readln(nomorAkun);

            if nomorAkun = '-' then
                defineRekeningAutoDebet := '-'
            else
            begin
                indexRekening := GetIndexRekening(nomorAkun, tabunganMandiri_rekeningOnlineArray);
                if indexRekening > 0 then
                    if isOwner(indexRekening, current_nasabah) then
                        defineRekeningAutoDebet := nomorAkun
                    else
                        writeln('Anda tidak mempunyai rekening ', nomorAkun, '.')
                else 
                    writeln('Rekening tidak ada dalam daftar rekening online.');
            end;
        until (nomorAkun = '-') or (indexRekening > 0)
    else
        defineRekeningAutoDebet := '-';
end;

procedure LoadAll();
begin
    assign(nasabahFile, 'nasabah.bin');
    reset(nasabahFile);
    while not Eof(nasabahFile) do
    begin
        nasabahArray.Neff := nasabahArray.Neff + 1;
        read(nasabahFile, nasabahArray.T[nasabahArray.Neff]);
    end;
    close(nasabahFile);

    assign(rekeningOnlineFile, 'rekeningonline.bin');
    reset(rekeningOnlineFile);
    while not Eof(rekeningOnlineFile) do
    begin
        rekeningOnlineArray.Neff := rekeningOnlineArray.Neff + 1;
        read(rekeningOnlineFile, rekeningOnlineArray.T[rekeningOnlineArray.Neff]);
    end;
    close(rekeningOnlineFile);

    assign(transaksiSetoranPenarikanFile, 'transaksisetoranpenarikan.bin');
    reset(transaksiSetoranPenarikanFile);
    while not Eof(transaksiSetoranPenarikanFile) do
    begin
        transaksiSetoranPenarikanArray.Neff := transaksiSetoranPenarikanArray.Neff + 1;
        read(transaksiSetoranPenarikanFile, transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff]);
    end;
    close(transaksiSetoranPenarikanFile);

    assign(transaksiTransferFile, 'transaksitransfer.bin');
    reset(transaksiTransferFile);
    while not Eof(transaksiTransferFile) do
    begin
        transaksiTransferArray.Neff := transaksiTransferArray.Neff + 1;
        read(transaksiTransferFile, transaksiTransferArray.T[transaksiTransferArray.Neff]);
    end;
    close(transaksiTransferFile);

    assign(pembayaranFile, 'pembayaran.bin');
    reset(pembayaranFile);
    while not Eof(pembayaranFile) do
    begin
        pembayaranArray.Neff := pembayaranArray.Neff + 1;
        read(pembayaranFile, pembayaranArray.T[pembayaranArray.Neff]);
    end;
    close(pembayaranFile);

    assign(pembelianFile, 'pembelian.bin');
    reset(pembelianFile);
    while not Eof(pembelianFile) do
    begin
        pembelianArray.Neff := pembelianArray.Neff + 1;
        read(pembelianFile, pembelianArray.T[pembelianArray.Neff]);
    end;
    close(pembelianFile);

    assign(nilaiTukarAntarMataUangFile, 'nilaitukarantarmatauang.bin');
    reset(nilaiTukarAntarMataUangFile);
    while not Eof(nilaiTukarAntarMataUangFile) do
    begin
        nilaiTukarAntarMataUangArray.Neff := nilaiTukarAntarMataUangArray.Neff + 1;
        read(nilaiTukarAntarMataUangFile, nilaiTukarAntarMataUangArray.T[nilaiTukarAntarMataUangArray.Neff]);
    end;
    close(nilaiTukarAntarMataUangFile);

    assign(barangFile, 'barang.bin');
    reset(barangFile);
    while not Eof(barangFile) do
    begin
        barangArray.Neff := barangArray.Neff + 1;
        read(barangFile, barangArray.T[barangArray.Neff]);
    end;
    close(barangFile);
end;

(* Tugas *)

procedure Load();
(* KAMUS LOKAL *)
var
    fileName : string;

(* ALGORITMA *)
begin
    write('nama file: ');
    readln(fileName);

    if fileName = 'nasabah.bin' then
    begin
        assign(nasabahFile, 'nasabah.bin');
        reset(nasabahFile);
        while not Eof(nasabahFile) do
        begin
            nasabahArray.Neff := nasabahArray.Neff + 1;
            read(nasabahFile, nasabahArray.T[nasabahArray.Neff]);
        end;
        close(nasabahFile);
    end else
    if fileName = 'rekeningonline.bin' then
    begin
        assign(rekeningOnlineFile, 'rekeningonline.bin');
        reset(rekeningOnlineFile);
        while not Eof(rekeningOnlineFile) do
        begin
            rekeningOnlineArray.Neff := rekeningOnlineArray.Neff + 1;
            read(rekeningOnlineFile, rekeningOnlineArray.T[rekeningOnlineArray.Neff]);
        end;
        close(rekeningOnlineFile);
    end else
    if fileName = 'transaksisetoranpenarikan.bin' then
    begin
        assign(transaksiSetoranPenarikanFile, 'transaksisetoranpenarikan.bin');
        reset(transaksiSetoranPenarikanFile);
        while not Eof(transaksiSetoranPenarikanFile) do
        begin
            transaksiSetoranPenarikanArray.Neff := transaksiSetoranPenarikanArray.Neff + 1;
            read(transaksiSetoranPenarikanFile, transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff]);
        end;
        close(transaksiSetoranPenarikanFile);
    end else
    if fileName = 'transaksitransfer.bin' then
    begin
        assign(transaksiTransferFile, 'transaksitransfer.bin');
        reset(transaksiTransferFile);
        while not Eof(transaksiTransferFile) do
        begin
            transaksiTransferArray.Neff := transaksiTransferArray.Neff + 1;
            read(transaksiTransferFile, transaksiTransferArray.T[transaksiTransferArray.Neff]);
        end;
        close(transaksiTransferFile);
    end else
    if fileName = 'pembayaran.bin' then
    begin
        assign(pembayaranFile, 'pembayaran.bin');
        reset(pembayaranFile);
        while not Eof(pembayaranFile) do
        begin
            pembayaranArray.Neff := pembayaranArray.Neff + 1;
            read(pembayaranFile, pembayaranArray.T[pembayaranArray.Neff]);
        end;
        close(pembayaranFile);
    end else
    if fileName = 'pembelian.bin' then
    begin
        assign(pembelianFile, 'pembelian.bin');
        reset(pembelianFile);
        while not Eof(pembelianFile) do
        begin
            pembelianArray.Neff := pembelianArray.Neff + 1;
            read(pembelianFile, pembelianArray.T[pembelianArray.Neff]);
        end;
        close(pembelianFile);
    end else
    if fileName = 'nilaitukarantarmatauang.bin' then
    begin
        assign(nilaiTukarAntarMataUangFile, 'nilaitukarantarmatauang.bin');
        reset(nilaiTukarAntarMataUangFile);
        while not Eof(nilaiTukarAntarMataUangFile) do
        begin
            nilaiTukarAntarMataUangArray.Neff := nilaiTukarAntarMataUangArray.Neff + 1;
            read(nilaiTukarAntarMataUangFile, nilaiTukarAntarMataUangArray.T[nilaiTukarAntarMataUangArray.Neff]);
        end;
        close(nilaiTukarAntarMataUangFile);
    end else
    if fileName = 'barang.bin' then
    begin
        assign(barangFile, 'barang.bin');
        reset(barangFile);
        while not Eof(barangFile) do
        begin
            barangArray.Neff := barangArray.Neff + 1;
            read(barangFile, barangArray.T[barangArray.Neff]);
        end;
        close(barangFile);
    end;

    writeln('Pembacaan file berhasil');
end;

procedure Login();
(* KAMUS LOKAL *)
const
    MaxTries = 3;
var
    username : string;
    password : string;
    i : integer = 0;
    found : boolean = false;

(* ALGORITMA *)
begin
    write('username: ');
    readln(username);

    while (i < nasabahArray.Neff) and not found do
    begin
        i := i + 1;
        if nasabahArray.T[i].username = username then found := true;
    end;
    
    if found then
        if nasabahArray.T[i].status = 'aktif' then
        begin
            write('password: ');
            readln(password);

            if nasabahArray.T[i].password = password then
            begin
                index_nasabah := i;
                current_nasabah := nasabahArray.T[i].nomorNasabah;
                writeln('Login berhasil. Selamat datang ', nasabahArray.T[i].username,'!');
            end else
            begin
                triesArray[i] := triesArray[i] + 1;
                writeln('Username atau password tidak tepat. Silakan coba lagi. Anda hanya memiliki ', MaxTries - triesArray[i], ' kesempatan lagi.');
                if triesArray[i] >= MaxTries then
                begin
                    nasabahArray.T[i].status := 'inaktif';
                    Exit();
                end;
            end
        end else
            writeln('Status nasabah inaktif.')
    else
        writeln('Username atau password tidak tepat. Silakan coba lagi.');
end;

procedure LihatRekening();
(* ALGORITMA *)
begin
    WriteRekening(getRekening(current_nasabah, true, true, true));
end;

procedure InformasiSaldo();
(* KAMUS LOKAL *)
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    yy, mm, dd : Word;

    input : string;
    i : integer;
    isValid : boolean = true;

(* ALGORITMA *)
begin
    writeln('Pilih jenis rekening:');
    writeln('1. Deposito');
    writeln('2. Tabungan Rencana');
    writeln('3. Tabungan Mandiri');

    write('Jenis rekening: ');
    readln(input);
    if input = '1' then
    begin
        input := 'Deposito';
        temp_rekeningOnlineArray := getRekening(current_nasabah, false, false, true);
    end else if input = '2' then
    begin
        input := 'Tabungan Rencana';
        temp_rekeningOnlineArray := getRekening(current_nasabah, false, true, false);
    end else if input = '3' then
    begin
        input := 'Tabungan Mandiri';
        temp_rekeningOnlineArray := getRekening(current_nasabah, true, false, false);
    end else
        isValid := false;

    if isValid then
        if temp_rekeningOnlineArray.Neff > 0 then
        begin
            writeln('Pilih rekening ', input, ' Anda:');
            for i := 1 to temp_rekeningOnlineArray.Neff do writeln(i, '. ', temp_rekeningOnlineArray.T[i].nomorAkun);

            write('Rekening ', input, ': ');
            readln(input);

            i := getIndexRekening(input, temp_rekeningOnlineArray);
            if i > 0 then
                if isOwner(i, current_nasabah) then
                begin
                    writeln('Nomor rekening: ', temp_rekeningOnlineArray.T[i].nomorAkun);
                    DeCodeDate(temp_rekeningOnlineArray.T[i].tanggalMulai, yy, mm, dd);
                    writeln(format('Tanggal mulai: %d-%d-%d', [dd,mm,yy]));
                    writeln('Mata uang: ', temp_rekeningOnlineArray.T[i].mataUang);
                    writeln('Jangka waktu: ', temp_rekeningOnlineArray.T[i].jangkaWaktu:0:0, ' hari');
                    writeln('Setoran rutin: ', temp_rekeningOnlineArray.T[i].setoranRutin);
                    writeln('Saldo: ', temp_rekeningOnlineArray.T[i].saldo);
                end else
                    writeln('Anda tidak mempunyai rekening ', input, '.')
            else
                writeln('Rekening tidak ada dalam daftar rekening online.');
        end else
            writeln('Anda tidak mempunyai ', input, '.')
    else
        writeln('Input tidak valid.');
end;

procedure LihatAktivitasTransaksi();
(* KAMUS LOKAL *)
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    periode : double;
    yy, mm, dd : Word;

    unitOfTime : string;
    value : real;
    i, j : integer;
    isValid : boolean = true;

(* ALGORITMA *)
begin
    temp_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);

    writeln('Periode aktivitas: ');
    readln(value, unitOfTime);
    if unitOfTime = ' tahun' then periode := round(value * 365) else
    if unitOfTime = ' bulan' then periode := round(value * 30) else
    if unitOfTime = ' hari' then periode := round(value) else isValid := false;

    if isValid then
        if (1 <= periode) and (periode <= 90) then
            for i := 1 to temp_rekeningOnlineArray.Neff do
            begin
                for j := 1 to transaksiSetoranPenarikanArray.Neff do
                begin
                    if temp_rekeningOnlineArray.T[i].nomorAkun = transaksiSetoranPenarikanArray.T[j].nomorAkun then
                        if Date - periode <= transaksiSetoranPenarikanArray.T[j].tanggalTransaksi then
                        begin
                            write('Nomor akun: ', transaksiSetoranPenarikanArray.T[j].nomorAkun, ' | ');
                            write('Jenis transaksi: ', transaksiSetoranPenarikanArray.T[j].jenisTransaksi, ' | ');
                            write('Mata uang: ', transaksiSetoranPenarikanArray.T[j].mataUang, ' | ');
                            write('Jumlah: ', transaksiSetoranPenarikanArray.T[j].jumlah, ' | ');
                            write('Saldo: ', transaksiSetoranPenarikanArray.T[j].saldo, ' | ');
                            DeCodeDate(transaksiSetoranPenarikanArray.T[j].tanggalTransaksi, yy, mm, dd);
                            writeln(format('Tanggal transaksi: %d-%d-%d', [dd,mm,yy]));
                        end;
                end;

                for j := 1 to transaksiTransferArray.Neff do
                begin
                    if temp_rekeningOnlineArray.T[i].nomorAkun = transaksiTransferArray.T[j].nomorAkunAsal then
                        if Date - periode <= transaksiTransferArray.T[j].tanggalTransaksi then
                        begin
                            write('Nomor akun asal: ', transaksiTransferArray.T[j].nomorAkunAsal, ' | ');
                            write('Nomor akun tujuan: ', transaksiTransferArray.T[j].nomorAkunTujuan, ' | ');
                            write('Jenis transfer: ', transaksiTransferArray.T[j].jenisTransfer, ' | ');
                            write('Nama bank luar: ', transaksiTransferArray.T[j].namaBankLuar, ' | ');
                            write('Mata uang: ', transaksiTransferArray.T[j].mataUang, ' | ');
                            write('Jumlah: ', transaksiTransferArray.T[j].jumlah, ' | ');
                            write('Saldo: ', transaksiTransferArray.T[j].saldo, ' | ');
                            DeCodeDate(transaksiTransferArray.T[j].tanggalTransaksi, yy, mm, dd);
                            writeln(format('Tanggal transaksi: %d-%d-%d', [dd,mm,yy]));
                        end;
                end;

                for j := 1 to pembayaranArray.Neff do
                begin
                    if temp_rekeningOnlineArray.T[i].nomorAkun = pembayaranArray.T[j].nomorAkun then
                    begin
                        if Date - periode <= pembayaranArray.T[j].tanggalTransaksi then
                        begin
                            write('Nomor akun: ', pembayaranArray.T[j].nomorAkun, ' | ');
                            write('Jenis transaksi: ', pembayaranArray.T[j].jenisTransaksi, ' | ');
                            write('Rekening bayar: ', pembayaranArray.T[j].rekeningBayar, ' | ');
                            write('Mata uang: ', pembayaranArray.T[j].mataUang, ' | ');
                            write('Jumlah: ', pembayaranArray.T[j].jumlah, ' | ');
                            write('Saldo: ', pembayaranArray.T[j].saldo, ' | ');
                            DeCodeDate(pembayaranArray.T[j].tanggalTransaksi, yy, mm, dd);
                            writeln(format('Tanggal transaksi: %d-%d-%d', [dd,mm,yy]));
                        end;
                    end;
                end;

                for j := 1 to pembelianArray.Neff do
                begin
                    if temp_rekeningOnlineArray.T[i].nomorAkun = pembelianArray.T[j].nomorAkun then
                        if Date - periode <= pembelianArray.T[j].tanggalTransaksi then
                        begin
                            write('Nomor akun: ', pembelianArray.T[j].nomorAkun, ' | ');
                            write('Jenis barang: ', pembelianArray.T[j].jenisBarang, ' | ');
                            write('Penyedia: ', pembelianArray.T[j].penyedia, ' | ');
                            write('Nomor tujuan: ', pembelianArray.T[j].nomorTujuan, ' | ');
                            write('Mata uang: ', pembelianArray.T[j].mataUang, ' | ');
                            write('Jumlah: ', pembelianArray.T[j].jumlah, ' | ');
                            write('Saldo: ', pembelianArray.T[j].saldo, ' | ');
                            DeCodeDate(pembelianArray.T[j].tanggalTransaksi, yy, mm, dd);
                            writeln(format('Tanggal transaksi: %d-%d-%d', [dd,mm,yy]));
                        end;
                end;
            end
        else
            writeln('Periode aktivitas minimum 1 hari dan maksimum 3 bulan terakhir.')
    else
        writeln('Input tidak valid');
end;

procedure PembuatanRekening();
(* KAMUS LOKAL *)
const
    minimumDepositoIDR = 8000000;
    minimumDepositoUSD = 600;
    minimumDepositoEUR = 550;

    minimumSetoranRutin = 500000;

    minimumTabunganMandiri = 50000;

var
    temp_rekeningOnline : TRekeningOnline;

    unitOfTime : string;
    value : integer;
    input : string;
    isValid : boolean = true;

(* ALGORITMA *)
begin
    if rekeningOnlineArray.Neff < NMax then
    begin
        temp_rekeningOnline.nomorNasabah := current_nasabah;

        writeln('Pilih jenis rekening:');
        writeln('1. Deposito');
        writeln('2. Tabungan Rencana');
        writeln('3. Tabungan Mandiri');

        readln(input);
        temp_rekeningOnline.nomorAkun := generateNomorAkun(index_nasabah, rekeningOnlineArray.Neff, input);
        if (input = '1') or (input = 'Deposito') then
        begin
            temp_rekeningOnline.jenisRekening := 'Deposito';

            writeln('Pilih mata uang: ');
            writeln('1. Rupiah (IDR)');
            writeln('2. US Dollar (USD)');
            writeln('3. Euro (EUR)');

            readln(input);
            if (input = '1') or (input = 'Rupiah') or (input = 'IDR') then
            begin
                temp_rekeningOnline.mataUang := 'IDR';
                repeat
                    writeln('Masukkan setoran awal deposito minimum ', minimumDepositoIDR, ' IDR!');
                    write('Saldo: '); readln(temp_rekeningOnline.saldo);
                until (temp_rekeningOnline.saldo >= minimumDepositoIDR);
            end else
            if (input = '2') or (input = 'US Dollar') or (input = 'USD') then
            begin
                temp_rekeningOnline.mataUang := 'USD';
                repeat
                    writeln('Masukkan setoran awal deposito minimum ', minimumDepositoUSD, ' USD!');
                    write('Saldo: '); readln(temp_rekeningOnline.saldo);
                until (temp_rekeningOnline.saldo >= minimumDepositoUSD);
            end else
            if (input = '3') or (input = 'Euro') or (input = 'EUR') then
            begin
                temp_rekeningOnline.mataUang := 'EUR';
                repeat
                    writeln('Masukkan setoran awal deposito minimum ', minimumDepositoEUR, ' EUR!');
                    write('Saldo: '); readln(temp_rekeningOnline.saldo);
                until (temp_rekeningOnline.saldo >= minimumDepositoEUR);
            end else
                isValid := false;
            
            if isValid then
            begin
                temp_rekeningOnline.setoranRutin := 0;

                writeln('Masukkan rentang waktu deposito! (1 bulan/3 bulan/6 bulan/12 bulan)');
                readln(value, unitOfTime);
                if (unitOfTime = ' bulan') and ((value = 1) or (value = 3) or (value = 6) or (value = 12)) then
                begin
                    temp_rekeningOnline.jangkaWaktu := value * 30;
                    temp_rekeningOnline.rekeningAutodebet := defineRekeningAutoDebet();
                end else
                    isValid := false;
            end;
        end else
        if (input = '2') or (input = 'Tabungan Rencana') then
        begin
            temp_rekeningOnline.jenisRekening := 'Tabungan Rencana';
            temp_rekeningOnline.mataUang := 'IDR';

            repeat
                writeln('Masukkan setoran awal tabungan rencana minimum 0 IDR!');
                readln(temp_rekeningOnline.saldo);
            until (temp_rekeningOnline.saldo >= 0);

            repeat
                writeln('Masukkan setoran rutin tabungan rencana minimum ', minimumSetoranRutin, ' IDR!');
                readln(temp_rekeningOnline.setoranRutin);
            until (temp_rekeningOnline.setoranRutin >= minimumSetoranRutin);

            writeln('Masukkan jangka waktu tabungan rencana minimum 1 tahun dan maksimum 20 tahun!');
            readln(value, unitOfTime);
            if (unitOfTime = ' tahun') and (1 <= value) and (value <= 20) then
            begin
                temp_rekeningOnline.jangkaWaktu := value * 365;
                temp_rekeningOnline.rekeningAutodebet := defineRekeningAutoDebet();
            end else
                isValid := false;
            
        end else
        if (input = '3') or (input = 'Tabungan Mandiri') then
        begin
            temp_rekeningOnline.jenisRekening := 'Tabungan Mandiri';
            temp_rekeningOnline.mataUang := 'IDR';

            repeat
                writeln('Masukkan setoran awal tabungan mandiri minimum ', minimumTabunganMandiri, ' IDR!');
                readln(temp_rekeningOnline.saldo);
            until (temp_rekeningOnline.saldo >= minimumTabunganMandiri);

            temp_rekeningOnline.setoranRutin := 0;
            temp_rekeningOnline.jangkaWaktu := 0;
            temp_rekeningOnline.rekeningAutodebet := '-';
        end else
            isValid := false;

        temp_rekeningOnline.tanggalMulai := Date;

        if isValid then
        begin
            rekeningOnlineArray.Neff := rekeningOnlineArray.Neff + 1;
            rekeningOnlineArray.T[RekeningOnlineArray.Neff] := temp_rekeningOnline;
        end else
            writeln('Input tidak valid.');
    end else
        writeln('Array penuh.');
end;

procedure Setoran();
(* KAMUS LOKAL *)
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    indexRekening : integer;

    nomorAkun : string;
    setoran : longint;

(* ALGORITMA *)
begin
    if transaksiSetoranPenarikanArray.Neff < NMax then
    begin
        temp_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);
        if temp_rekeningOnlineArray.Neff > 0 then
        begin
            writeln('Pilih rekening Anda:');
            WriteRekening(temp_rekeningOnlineArray);

            write('Rekening: ');
            readln(nomorAkun);

            indexRekening := getIndexRekening(nomorAkun, rekeningOnlineArray);
            if indexRekening > 0 then
                if isOwner(indexRekening, current_nasabah) then
                begin
                    repeat
                        writeln('Masukkan setoran diatas 0 ', rekeningOnlineArray.T[indexRekening].mataUang, '!');
                        write('Setoran: ');
                        readln(setoran);
                    until (setoran > 0);
                    
                    rekeningOnlineArray.T[indexRekening].saldo := rekeningOnlineArray.T[indexRekening].saldo + setoran;

                    transaksiSetoranPenarikanArray.Neff := transaksiSetoranPenarikanArray.Neff + 1;

                    transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff].nomorAkun := nomorAkun;
                    transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff].jenisTransaksi := 'setoran';
                    transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff].mataUang := rekeningOnlineArray.T[indexRekening].mataUang;
                    transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff].jumlah := setoran;
                    transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff].saldo := rekeningOnlineArray.T[indexRekening].saldo;
                    transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff].tanggalTransaksi := Date;
                end else
                    writeln('Anda tidak mempunyai rekening ', nomorAkun, '.')
            else
                writeln('Rekening tidak ada dalam daftar rekening online.');
        end else
            writeln('Anda tidak mempunyai rekening.');
    end else
        writeln('Array penuh.');
end;

procedure Penarikan();
(* KAMUS LOKAL *)
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    temp_transaksiSetoranPenarikan : TTransaksiSetoranPenarikan;
    indexRekening : integer;

(* ALGORITMA *)
begin
    if transaksiSetoranPenarikanArray.Neff < NMax then
    begin
        temp_transaksiSetoranPenarikan.jenisTransaksi := 'penarikan';

        temp_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);
        if temp_rekeningOnlineArray.Neff > 0 then
        begin
            writeln('Pilih rekening Anda:');
            WriteRekening(temp_rekeningOnlineArray);

            write('Rekening: ');
            readln(temp_transaksiSetoranPenarikan.nomorAkun);

            indexRekening := getIndexRekening(temp_transaksiSetoranPenarikan.nomorAkun, rekeningOnlineArray);
            if indexRekening > 0 then
                if isOwner(indexRekening, current_nasabah) then
                begin
                    temp_transaksiSetoranPenarikan.mataUang := rekeningOnlineArray.T[indexRekening].mataUang;

                    if rekeningOnlineArray.T[indexRekening].tanggalMulai + rekeningOnlineArray.T[indexRekening].jangkaWaktu <= Date then
                    begin
                        repeat
                            writeln('Masukkan penarikan diatas 0 ', temp_transaksiSetoranPenarikan.mataUang, '!');
                            write('Penarikan: ');
                            readln(temp_transaksiSetoranPenarikan.jumlah);
                        until (temp_transaksiSetoranPenarikan.jumlah > 0);
                        
                        if rekeningOnlineArray.T[indexRekening].saldo - temp_transaksiSetoranPenarikan.jumlah >= 0 then
                        begin
                            rekeningOnlineArray.T[indexRekening].saldo := rekeningOnlineArray.T[indexRekening].saldo - temp_transaksiSetoranPenarikan.jumlah;
                            
                            temp_transaksiSetoranPenarikan.saldo := rekeningOnlineArray.T[indexRekening].saldo;
                            temp_transaksiSetoranPenarikan.tanggalTransaksi := Date;

                            transaksiSetoranPenarikanArray.Neff := transaksiSetoranPenarikanArray.Neff + 1;
                            transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff] := temp_transaksiSetoranPenarikan;
                        end else
                            writeln('Penarikan ditolak. Jumlah penarikan lebih besar dari jumlah dana yang ada di dalam rekening.');
                    end else
                        writeln('Penarikan ditolak. Tanggal jatuh tempo belum terpenuhi.');
                end else
                    writeln('Anda tidak mempunyai rekening ', temp_transaksiSetoranPenarikan.nomorAkun, '.')
            else
                writeln('Rekening tidak ada dalam daftar rekening online.');
        end else
            writeln('Anda tidak mempunyai rekening.');
    end else
        writeln('Array penuh.');
end;

procedure Transfer();
(* KAMUS LOKAL *)
const
    BiayaAdministrasiIDR = 5000;
    BiayaAdministrasiUSD = 2;
    BiayaAdministrasiEUR = 2;
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    temp_transaksiTransfer : TTransaksiTransfer;
    indexRekeningAsal : integer;
    indexRekeningTujuan : integer;
    biayaAdministrasi : longint = 0;

    input : string;
    isValid : boolean = true;

(* ALGORITMA *)
begin
    temp_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);
    if temp_rekeningOnlineArray.Neff > 0 then
    begin
        writeln('Pilih rekening Anda:');
        WriteRekening(temp_rekeningOnlineArray);

        write('Rekening: ');
        readln(temp_transaksiTransfer.nomorAkunAsal);

        indexRekeningAsal := getIndexRekening(temp_transaksiTransfer.nomorAkunAsal, rekeningOnlineArray);

        if indexRekeningAsal > 0 then
            if isOwner(indexRekeningAsal, current_nasabah) then
            begin
                temp_transaksiTransfer.mataUang := rekeningOnlineArray.T[indexRekeningAsal].mataUang;

                if rekeningOnlineArray.T[indexRekeningAsal].tanggalMulai + rekeningOnlineArray.T[indexRekeningAsal].jangkaWaktu <= Date then
                begin
                    writeln('Pilih jenis transfer:');
                    writeln('1. Dalam bank');
                    writeln('2. Antar bank');
                    readln(input);

                    if (input = '1') or (input = 'Dalam bank') or (input = 'dalam bank') then
                    begin
                        temp_transaksiTransfer.jenisTransfer := 'dalam bank';
                        temp_transaksiTransfer.namaBankLuar := '-';

                        writeln('Nomor akun tujuan: ');
                        readln(temp_transaksiTransfer.nomorAkunTujuan);

                        indexRekeningTujuan := getIndexRekening(temp_transaksiTransfer.nomorAkunTujuan, rekeningOnlineArray);

                        if not(indexRekeningTujuan > 0) then
                        begin
                            isValid := false;
                            writeln('Rekening tujuan tidak ada dalam daftar rekening online.');
                        end;
                    end else
                    if (input = '2') or (input = 'Antar bank') or (input = 'antar bank') then
                    begin
                        temp_transaksiTransfer.jenisTransfer := 'antar bank';

                        writeln('Nama bank luar: ');
                        readln(temp_transaksiTransfer.namaBankLuar);

                        writeln('Nomor akun tujuan: ');
                        readln(temp_transaksiTransfer.nomorAkunTujuan);

                        writeln('Mata uang akun tujuan: ');
                        readln(input);

                        if input = 'IDR' then biayaAdministrasi := getKurs('IDR', temp_transaksiTransfer.mataUang, BiayaAdministrasiIDR) else
                        if input = 'USD' then biayaAdministrasi := getKurs('USD', temp_transaksiTransfer.mataUang, BiayaAdministrasiUSD) else
                        if input = 'EUR' then biayaAdministrasi := getKurs('EUR', temp_transaksiTransfer.mataUang, BiayaAdministrasiEUR) else
                        begin
                           isValid := false;
                           writeln('Mata uang tidak tersedia.');
                        end;
                    end else
                    begin
                        isValid := false;
                        writeln('Input tidak valid.');
                    end;

                    if isValid then
                    begin
                        repeat
                            writeln('Masukkan transfer diatas ', biayaAdministrasi, ' ', temp_transaksiTransfer.mataUang, '!');
                            write('Transfer: ');
                            readln(temp_transaksiTransfer.jumlah);
                        until (temp_transaksiTransfer.jumlah > biayaAdministrasi);

                        if rekeningOnlineArray.T[indexRekeningAsal].saldo - temp_transaksiTransfer.jumlah >= 0 then
                        begin
                            rekeningOnlineArray.T[indexRekeningAsal].saldo := rekeningOnlineArray.T[indexRekeningAsal].saldo - temp_transaksiTransfer.jumlah;
                            
                            if temp_transaksiTransfer.jenisTransfer = 'dalam bank' then
                                rekeningOnlineArray.T[indexRekeningTujuan].saldo := rekeningOnlineArray.T[indexRekeningTujuan].saldo + getKurs(rekeningOnlineArray.T[indexRekeningAsal].mataUang, rekeningOnlineArray.T[indexRekeningTujuan].mataUang, temp_transaksiTransfer.jumlah - biayaAdministrasi);
                            
                            temp_transaksiTransfer.saldo := rekeningOnlineArray.T[indexRekeningAsal].saldo;
                            temp_transaksiTransfer.tanggalTransaksi := Date;

                            transaksiTransferArray.Neff := transaksiTransferArray.Neff + 1;
                            transaksiTransferArray.T[transaksiTransferArray.Neff] := temp_transaksiTransfer;
                        end else
                            writeln('Penarikan ditolak. Jumlah transfer lebih besar dari jumlah dana yang ada di dalam rekening.');
                    end;
                end else
                    writeln('Penarikan ditolak. Tanggal jatuh tempo belum terpenuhi.');
            end else
                writeln('Anda tidak mempunyai rekening ', temp_transaksiTransfer.nomorAkunAsal, '.')
        else
            writeln('Rekening asal tidak ada dalam daftar rekening online.');
    end else
        writeln('Anda tidak mempunyai rekening.');
end;

procedure Pembayaran();
(* KAMUS LOKAL *)
const
    DendaPerHari = 10000;
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    temp_pembayaran : TPembayaran;
    indexRekening : integer;
    denda : longint = 0;
    yy, mm, dd : Word;

    jenisPembayaran : integer;
    isValid : boolean = true;

(* ALGORITMA *)
begin
    if pembayaranArray.Neff < NMax then
    begin
        temp_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);
        if temp_rekeningOnlineArray.Neff > 0 then
        begin
            writeln('Pilih rekening Anda:');
            WriteRekening(temp_rekeningOnlineArray);

            write('Rekening: ');
            readln(temp_pembayaran.nomorAkun);

            indexRekening := getIndexRekening(temp_pembayaran.nomorAkun, rekeningOnlineArray);
            if indexRekening > 0 then
                if isOwner(indexRekening, current_nasabah) then
                begin
                    temp_pembayaran.mataUang := rekeningOnlineArray.T[indexRekening].mataUang;

                    if rekeningOnlineArray.T[indexRekening].tanggalMulai + rekeningOnlineArray.T[indexRekening].jangkaWaktu <= Date then
                    begin
                        writeln('Pilih jenis transaksi:');
                        writeln('1. Listrik');
                        writeln('2. BPJS');
                        writeln('3. PDAM');
                        writeln('4. Telepon');
                        writeln('5. TV kabel');
                        writeln('6. Internet');
                        writeln('7. Kartu kredit');
                        writeln('8. Pajak');
                        writeln('9. Pendidikan');

                        readln(jenisPembayaran);
                        if jenisPembayaran = 1 then temp_pembayaran.jenisTransaksi := 'listrik' else
                        if jenisPembayaran = 2 then temp_pembayaran.jenisTransaksi := 'BPJS' else
                        if jenisPembayaran = 3 then temp_pembayaran.jenisTransaksi := 'PDAM' else
                        if jenisPembayaran = 4 then temp_pembayaran.jenisTransaksi := 'telepon' else
                        if jenisPembayaran = 5 then temp_pembayaran.jenisTransaksi := 'TV kabel' else
                        if jenisPembayaran = 6 then temp_pembayaran.jenisTransaksi := 'internet' else
                        if jenisPembayaran = 7 then temp_pembayaran.jenisTransaksi := 'kartu kredit' else
                        if jenisPembayaran = 8 then temp_pembayaran.jenisTransaksi := 'pajak' else
                        if jenisPembayaran = 9 then temp_pembayaran.jenisTransaksi := 'pendidikan' else
                            isValid := false;

                        if isValid then
                        begin
                            if jenisPembayaran <= 6 then
                            begin
                                DeCodeDate(Date, yy, mm, dd);
                                if dd >= 15 then
                                    denda := getKurs('IDR', temp_pembayaran.mataUang, DendaPerHari * (dd - 14));
                            end;

                            repeat
                                writeln('Masukkan pembayaran minimal ', denda, ' ', temp_pembayaran.mataUang,'!');
                                write('Pembayaran: ');
                                readln(temp_pembayaran.jumlah);
                            until (temp_pembayaran.jumlah > denda);
                            
                            if rekeningOnlineArray.T[indexRekening].saldo - temp_pembayaran.jumlah >= 0 then
                            begin
                                write('Rekening bayar: ');
                                readln(temp_pembayaran.rekeningBayar);

                                rekeningOnlineArray.T[indexRekening].saldo := rekeningOnlineArray.T[indexRekening].saldo - temp_pembayaran.jumlah;
                                
                                temp_pembayaran.saldo := rekeningOnlineArray.T[indexRekening].saldo;
                                temp_pembayaran.tanggalTransaksi := Date;

                                pembayaranArray.Neff := pembayaranArray.Neff + 1;
                                pembayaranArray.T[pembayaranArray.Neff] := temp_pembayaran;
                            end else
                                writeln('Penarikan ditolak. Jumlah pembayaran lebih besar dari jumlah dana yang ada di dalam rekening.');
                        end else
                            writeln('Input tidak valid.');
                    end else
                        writeln('Penarikan ditolak. Tanggal jatuh tempo belum terpenuhi.');
                end else
                    writeln('Anda tidak mempunyai rekening ', temp_pembayaran.nomorAkun, '.')
            else
                writeln('Rekening tidak ada dalam daftar rekening online.');
        end else
            writeln('Anda tidak mempunyai rekening.');
    end else
        writeln('Array penuh');
end;

procedure Pembelian();
(* KAMUS LOKAL *)
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    temp_pembelian : TPembelian;
    indexRekening : integer;

    indexPembelian : integer;
    i : integer;

(* ALGORITMA *)
begin
    if pembelianArray.Neff < NMax then
    begin
        temp_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);
        if temp_rekeningOnlineArray.Neff > 0 then
            if barangArray.Neff > 0 then
            begin
                writeln('Pilih rekening Anda:');
                WriteRekening(temp_rekeningOnlineArray);

                write('Rekening: ');
                readln(temp_pembelian.nomorAkun);

                indexRekening := getIndexRekening(temp_pembelian.nomorAkun, rekeningOnlineArray);
                if indexRekening > 0 then
                    if isOwner(indexRekening, current_nasabah) then
                    begin
                        temp_pembelian.mataUang := rekeningOnlineArray.T[indexRekening].mataUang;

                        if rekeningOnlineArray.T[indexRekening].tanggalMulai + rekeningOnlineArray.T[indexRekening].jangkaWaktu <= Date then
                        begin
                            writeln('Pilih jenis barang:');
                            for i := 1 to barangArray.Neff do
                                writeln(i, '. ', barangArray.T[i].jenisBarang, ' ', barangArray.T[i].penyedia, ' ', getKurs('IDR', rekeningOnlineArray.T[indexRekening].mataUang, barangArray.T[i].harga));

                            readln(indexPembelian);

                            if (0 < indexPembelian) and (indexPembelian <= barangArray.Neff) then
                            begin
                                temp_pembelian.jenisBarang := barangArray.T[indexPembelian].jenisBarang;
                                temp_pembelian.penyedia := barangArray.T[indexPembelian].penyedia;
                                temp_pembelian.jumlah := getKurs('IDR', rekeningOnlineArray.T[indexRekening].mataUang, barangArray.T[indexPembelian].harga);

                                if rekeningOnlineArray.T[indexRekening].saldo - temp_pembelian.jumlah >= 0 then
                                begin
                                    writeln('Nomor tujuan: ');
                                    readln(temp_pembelian.nomorTujuan);

                                    rekeningOnlineArray.T[indexRekening].saldo := rekeningOnlineArray.T[indexRekening].saldo - temp_pembelian.jumlah;
                                    
                                    temp_pembelian.saldo := rekeningOnlineArray.T[indexRekening].saldo;
                                    temp_pembelian.tanggalTransaksi := Date;

                                    pembelianArray.Neff := pembelianArray.Neff + 1;
                                    pembelianArray.T[pembelianArray.Neff] := temp_pembelian;
                                end else
                                    writeln('Penarikan ditolak. Jumlah pembelian lebih besar dari jumlah dana yang ada di dalam rekening.');
                            end else
                                writeln('Input tidak valid.');
                        end else
                            writeln('Penarikan ditolak. Tanggal jatuh tempo belum terpenuhi.');
                    end else
                        writeln('Anda tidak mempunyai rekening ', temp_pembelian.nomorAkun, '.')
                else
                    writeln('Rekening tidak ada dalam daftar rekening online.');
            end else
                writeln('Barang tidak ada.')
        else
            writeln('Anda tidak mempunyai rekening.');
    end else
        writeln('Array penuh.');
end;

procedure PenutupanRekening();
(* KAMUS LOKAL *)
const
    Biaya = 25000;
    PenaltiPerHari = 10000;
    BiayaTambahan = 200000;

var
    tutup_rekeningOnlineArray : TRekeningOnlineArray;
    pindah_rekeningOnlineArray : TRekeningOnlineArray;
    indexRekeningTutup, indexRekeningPindah : integer;
    hariJatuhTempo : TDateTime;

    input : string;

(* ALGORITMA *)
begin
    tutup_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);
    if tutup_rekeningOnlineArray.Neff > 0 then
    begin
        writeln('Pilih rekening Anda:');
        WriteRekening(tutup_rekeningOnlineArray);

        write('Rekening: ');
        readln(input);

        indexRekeningTutup := GetIndexRekening(input, rekeningOnlineArray);
        if indexRekeningTutup > 0 then
            if isOwner(indexRekeningTutup, current_nasabah) then
            begin
                writeln('Dana:');
                writeln('1. Pindahkan ke rekening lain');
                writeln('2. Ambil secara tunai');

                readln(input);

                if input = '1' then
                begin
                    pindah_rekeningOnlineArray := getRekening(current_nasabah, true, true, true);
                    DeleteRekening(GetIndexRekening(rekeningOnlineArray.T[indexRekeningTutup].nomorAkun, pindah_rekeningOnlineArray), pindah_rekeningOnlineArray);

                    if pindah_rekeningOnlineArray.Neff > 0 then
                    begin
                        writeln('Pilih rekening Anda:');
                        WriteRekening(pindah_rekeningOnlineArray);

                        write('Rekening: ');
                        readln(input);

                        indexRekeningPindah := GetIndexRekening(input, rekeningOnlineArray);
                        if indexRekeningPindah > 0 then
                            if isOwner(indexRekeningPindah, current_nasabah) then
                            begin
                                hariJatuhTempo := rekeningOnlineArray.T[indexRekeningTutup].tanggalMulai + rekeningOnlineArray.T[indexRekeningTutup].jangkaWaktu;
                                if Date < hariJatuhTempo then
                                begin
                                    if rekeningOnlineArray.T[indexRekeningTutup].jenisRekening = 'Tabungan Rencana' then
                                        rekeningOnlineArray.T[indexRekeningTutup].saldo := rekeningOnlineArray.T[indexRekeningTutup].saldo - Biaya - BiayaTambahan
                                    else
                                    if rekeningOnlineArray.T[indexRekeningTutup].jenisRekening = 'Deposito' then
                                        rekeningOnlineArray.T[indexRekeningTutup].saldo := rekeningOnlineArray.T[indexRekeningTutup].saldo - getKurs('IDR', rekeningOnlineArray.T[indexRekeningTutup].mataUang, Biaya + PenaltiPerhari * daysBetween(hariJatuhTempo, Date));
                                end else
                                    rekeningOnlineArray.T[indexRekeningTutup].saldo := rekeningOnlineArray.T[indexRekeningTutup].saldo - getKurs('IDR', rekeningOnlineArray.T[indexRekeningTutup].mataUang, Biaya);
                                if rekeningOnlineArray.T[indexRekeningTutup].saldo < 0 then rekeningOnlineArray.T[indexRekeningTutup].saldo := 0;

                                rekeningOnlineArray.T[indexRekeningPindah].saldo := rekeningOnlineArray.T[indexRekeningPindah].saldo + getKurs(rekeningOnlineArray.T[indexRekeningTutup].mataUang, rekeningOnlineArray.T[indexRekeningPindah].mataUang, rekeningOnlineArray.T[indexRekeningTutup].saldo);
                                rekeningOnlineArray.T[indexRekeningTutup].saldo := 0;

                                DeleteRekening(indexRekeningTutup, rekeningOnlineArray);
                            end else
                                writeln('Anda tidak mempunyai rekening ', input, '.')
                        else
                            writeln('Rekening tidak ada dalam daftar rekening online.');
                    end else
                        writeln('Anda tidak mempunyai rekening pindah.');
                end else
                if input = '2' then
                begin
                    rekeningOnlineArray.T[indexRekeningTutup].saldo := 0;
                    DeleteRekening(indexRekeningTutup, rekeningOnlineArray);
                end else
                    writeln('Input tidak valid');
            end else
                writeln('Anda tidak mempunyai rekening ', input, '.')
        else
            writeln('Rekening tidak ada dalam daftar rekening online.');
    end else
        writeln('Anda tidak mempunyai rekening.');
end;

procedure PerubahanDataNasabah();
(* ALGORITMA *)
begin
    if index_nasabah > 0 then
    begin
        write('Nama nasabah: '); readln(nasabahArray.T[index_nasabah].namaNasabah);
        write('Alamat: '); readln(nasabahArray.T[index_nasabah].alamat);
        write('Kota: '); readln(nasabahArray.T[index_nasabah].kota);
        write('Email: '); readln(nasabahArray.T[index_nasabah].email);
        write('Nomor Telp: '); readln(nasabahArray.T[index_nasabah].nomorTelp);
        write('Password: '); readln(nasabahArray.T[index_nasabah].password);
    end else
        writeln('Anda belum login.');
end;

procedure PenambahanAutoDebet();
(* KAMUS LOKAL *)
var
    temp_rekeningOnlineArray : TRekeningOnlineArray;
    tabunganMandiri_rekeningOnlineArray : TRekeningOnlineArray;

    input : string;
    i, j : integer;

(* ALGORITMA *)
begin 
    temp_rekeningOnlineArray := getRekening(current_nasabah, false, true, true);
    if temp_rekeningOnlineArray.Neff > 0 then
    begin
        tabunganMandiri_rekeningOnlineArray := getRekening(current_nasabah, true, false, false);
        if tabunganMandiri_rekeningOnlineArray.Neff > 0 then
        begin
            writeln('Pilih rekening Tabungan Rencana atau Deposito Anda:');
            WriteRekening(temp_rekeningOnlineArray);

            readln(input);

            i := getIndexRekening(input, rekeningOnlineArray);
            if i > 0 then
                if isOwner(i, current_nasabah) then
                begin
                    writeln('Pilih rekening Autodebet Anda:');
                    WriteRekening(tabunganMandiri_rekeningOnlineArray);

                    write('Rekening Autodebet: ');
                    readln(input);

                    j := getIndexRekening(input, rekeningOnlineArray);
                    if j > 0 then
                        if isOwner(j, current_nasabah) then
                            rekeningOnlineArray.T[i].rekeningAutodebet := input
                        else
                            writeln('Anda tidak mempunyai rekening ', input, '.')
                    else 
                        writeln('Rekening tidak ada dalam daftar rekening online.');
                end else
                    writeln('Anda tidak mempunyai rekening ', input, '.')
            else
                writeln('Rekening tidak ada dalam daftar rekening online.');
        end else
            writeln('Anda tidak mempunyai Tabungan Mandiri.');       
    end else
        writeln('Anda tidak mempunyai Tabungan Rencana.');
end;

procedure Exit();
(* KAMUS LOKAL *)
var
    i : integer;

(* ALGORITMA *)
begin
    assign(nasabahFile, 'nasabah.bin');
    rewrite(nasabahFile);
    for i := 1 to nasabahArray.Neff do
        write(nasabahFile, nasabahArray.T[i]);
    close(nasabahFile);

    assign(rekeningOnlineFile, 'rekeningonline.bin');
    rewrite(rekeningOnlineFile);
    for i := 1 to rekeningOnlineArray.Neff do
        write(rekeningOnlineFile, rekeningOnlineArray.T[i]);
    close(rekeningOnlineFile);   

    assign(transaksiSetoranPenarikanFile, 'transaksisetoranpenarikan.bin');
    rewrite(transaksiSetoranPenarikanFile);
    for i := 1 to transaksiSetoranPenarikanArray.Neff do
        write(transaksiSetoranPenarikanFile, transaksiSetoranPenarikanArray.T[i]);
    close(transaksiSetoranPenarikanFile);

    assign(transaksiTransferFile, 'transaksitransfer.bin');
    rewrite(transaksiTransferFile);
    for i := 1 to transaksiTransferArray.Neff do
        write(transaksiTransferFile, transaksiTransferArray.T[i]);
    close(transaksiTransferFile);

    assign(pembayaranFile, 'pembayaran.bin');
    rewrite(pembayaranFile);
    for i := 1 to pembayaranArray.Neff do
        write(pembayaranFile, pembayaranArray.T[i]);
    close(pembayaranFile);

    assign(pembelianFile, 'pembelian.bin');
    rewrite(pembelianFile);
    for i := 1 to pembelianArray.Neff do
        write(pembelianFile, pembelianArray.T[i]);
    close(pembelianFile);
end;

begin
    nasabahArray.Neff := 0;
    rekeningOnlineArray.Neff := 0;
    transaksiSetoranPenarikanArray.Neff := 0;
    transaksiTransferArray.Neff := 0;
    pembayaranArray.Neff := 0;
    pembelianArray.Neff := 0;
    nilaiTukarAntarMataUangArray.Neff := 0;
    barangArray.Neff := 0;

    repeat
        write('> ');
        readln(command);
        if command = 'loadall' then LoadAll() else
        if command = 'load' then Load() else
        if command = 'login' then if index_nasabah = 0 then Login() else writeln('Anda telah login.') else
        if command = 'lihatRekening' then LihatRekening() else
        if command = 'informasiSaldo' then InformasiSaldo() else
        if command = 'lihatAktivitasTransaksi' then LihatAktivitasTransaksi() else
        if command = 'pembuatanRekening' then PembuatanRekening() else
        if command = 'setoran' then Setoran() else
        if command = 'penarikan' then Penarikan() else
        if command = 'transfer' then Transfer() else
        if command = 'pembayaran' then Pembayaran() else
        if command = 'pembelian' then Pembelian() else
        if command = 'penutupanRekening' then PenutupanRekening() else
        if command = 'perubahanDataNasabah' then PerubahanDataNasabah() else
        if command = 'penambahanAutoDebet' then PenambahanAutoDebet() else
        if command = 'exit' then Exit() else
            writeln('Pemberian perintah salah')
    until command = 'exit';
end.
