unit ibutils;
{$mode objfpc}
interface
    const
        NMax = 10;

    type
        TNasabah = record
            nomorNasabah, namaNasabah, alamat, kota, email, nomorTelp, username, password, status : string;
        end;
        TRekeningOnline = record
            nomorAkun, nomorNasabah, jenisRekening, mataUang, rekeningAutodebet : string;
            saldo, setoranRutin : longint;
            jangkaWaktu : integer;
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
            jenisBarang, penyedia : string;
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
    
    procedure LoadNasabah(namaFile : string; var nasabahArray : TNasabahArray);

    procedure LoadRekeningOnline(namaFile : string; var rekeningOnlineArray : TRekeningOnlineArray);

    procedure LoadTransaksiSetoranPenarikan(namaFile : string; var transaksiSetoranPenarikanArray : TTransaksiSetoranPenarikanArray);

    procedure LoadTransaksiTransfer(namaFile : string; var transaksiTransferArray : TTransaksiTransferArray);

    procedure LoadPembayaran(namaFile : string; var pembayaranArray : TPembayaranArray);

    procedure LoadPembelian(namaFile : string; var pembelianArray : TPembelianArray);

    procedure LoadNilaiTukarAntarMataUang(namaFile : string; var nilaiTukarAntarMataUangArray : TNilaiTukarAntarMataUangArray);

    procedure LoadBarang(namaFile : string; var barangArray : TBarangArray);

    procedure SaveNasabah(namaFile : string; nasabahArray : TNasabahArray);

    procedure SaveRekeningOnline(namaFile : string; rekeningOnlineArray : TRekeningOnlineArray);

    procedure SaveTransaksiSetoranPenarikan(namaFile : string; transaksiSetoranPenarikanArray : TTransaksiSetoranPenarikanArray);

    procedure SaveTransaksiTransfer(namaFile : string; transaksiTransferArray : TTransaksiTransferArray);

    procedure SavePembayaran(namaFile : string; pembayaranArray : TPembayaranArray);

    procedure SavePembelian(namaFile : string; pembelianArray : TPembelianArray);

    procedure SaveNilaiTukarAntarMataUang(namaFile : string; nilaiTukarAntarMataUangArray : TNilaiTukarAntarMataUangArray);

    procedure SaveBarang(namaFile : string; barangArray : TBarangArray);

    procedure WriteRekening(rekeningOnlineArray : TRekeningOnlineArray);

    procedure DeleteRekening(i : integer; var rekeningOnlineArray : TRekeningOnlineArray);

    function getIndexRekening(nomorAkun : string; rekeningOnlineArray : TRekeningOnlineArray) : integer;

    function getRekening(nasabah : string; rekeningOnlineArray : TRekeningOnlineArray; tabunganMandiri, tabunganRencana, deposito : boolean) : TRekeningOnlineArray;

    function getKurs(kursAsal, kursTujuan : string; nilai : longint; nilaiTukarAntarMataUangArray : TNilaiTukarAntarMataUangArray) : longint;

    function generateNomorAkun(i, n : integer; t : string) : string;

    function isOwner(nomorNasabah : string; indexRekening : integer; rekeningOnlineArray : TRekeningOnlineArray) : boolean;

implementation
    uses
        sysutils, dateutils;

    var
        nasabahFile : file of TNasabah;
        rekeningOnlineFile : file of TRekeningOnline;
        transaksiSetoranPenarikanFile : file of TTransaksiSetoranPenarikan;
        transaksiTransferFile : file of TTransaksiTransfer;
        pembayaranFile : file of TPembayaran;
        pembelianFile : file of TPembelian;
        nilaiTukarAntarMataUangFile : file of TNilaiTukarAntarMataUang;
        barangFile : file of TBarang;

    procedure LoadNasabah(namaFile : string; var nasabahArray : TNasabahArray);
    begin
        try
            assign(nasabahFile, namaFile);
            reset(nasabahFile);
            while not Eof(nasabahFile) do
            begin
                nasabahArray.Neff := nasabahArray.Neff + 1;
                read(nasabahFile, nasabahArray.T[nasabahArray.Neff]);
            end;
            close(nasabahFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure LoadRekeningOnline(namaFile : string; var rekeningOnlineArray : TRekeningOnlineArray);
    begin
        try
            assign(rekeningOnlineFile, namaFile);
            reset(rekeningOnlineFile);
            while not Eof(rekeningOnlineFile) do
            begin
                rekeningOnlineArray.Neff := rekeningOnlineArray.Neff + 1;
                read(rekeningOnlineFile, rekeningOnlineArray.T[rekeningOnlineArray.Neff]);
            end;
            close(rekeningOnlineFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure LoadTransaksiSetoranPenarikan(namaFile : string; var transaksiSetoranPenarikanArray : TTransaksiSetoranPenarikanArray);
    begin
        try
            assign(transaksiSetoranPenarikanFile, namaFile);
            reset(transaksiSetoranPenarikanFile);
            while not Eof(transaksiSetoranPenarikanFile) do
            begin
                transaksiSetoranPenarikanArray.Neff := transaksiSetoranPenarikanArray.Neff + 1;
                read(transaksiSetoranPenarikanFile, transaksiSetoranPenarikanArray.T[transaksiSetoranPenarikanArray.Neff]);
            end;
            close(transaksiSetoranPenarikanFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure LoadTransaksiTransfer(namaFile : string; var transaksiTransferArray : TTransaksiTransferArray);
    begin
        try
            assign(transaksiTransferFile, namaFile);
            reset(transaksiTransferFile);
            while not Eof(transaksiTransferFile) do
            begin
                transaksiTransferArray.Neff := transaksiTransferArray.Neff + 1;
                read(transaksiTransferFile, transaksiTransferArray.T[transaksiTransferArray.Neff]);
            end;
            close(transaksiTransferFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure LoadPembayaran(namaFile : string; var pembayaranArray : TPembayaranArray);
    begin
        try
            assign(pembayaranFile, namaFile);
            reset(pembayaranFile);
            while not Eof(pembayaranFile) do
            begin
                pembayaranArray.Neff := pembayaranArray.Neff + 1;
                read(pembayaranFile, pembayaranArray.T[pembayaranArray.Neff]);
            end;
            close(pembayaranFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure LoadPembelian(namaFile : string; var pembelianArray : TPembelianArray);
    begin
        try
            assign(pembelianFile, namaFile);
            reset(pembelianFile);
            while not Eof(pembelianFile) do
            begin
                pembelianArray.Neff := pembelianArray.Neff + 1;
                read(pembelianFile, pembelianArray.T[pembelianArray.Neff]);
            end;
            close(pembelianFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure LoadNilaiTukarAntarMataUang(namaFile : string; var nilaiTukarAntarMataUangArray : TNilaiTukarAntarMataUangArray);
    begin
        try
            assign(nilaiTukarAntarMataUangFile, namaFile);
            reset(nilaiTukarAntarMataUangFile);
            while not Eof(nilaiTukarAntarMataUangFile) do
            begin
                nilaiTukarAntarMataUangArray.Neff := nilaiTukarAntarMataUangArray.Neff + 1;
                read(nilaiTukarAntarMataUangFile, nilaiTukarAntarMataUangArray.T[nilaiTukarAntarMataUangArray.Neff]);
            end;
            close(nilaiTukarAntarMataUangFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure LoadBarang(namaFile : string; var barangArray : TBarangArray);
    begin
        try
            assign(barangFile, namaFile);
            reset(barangFile);
            while not Eof(barangFile) do
            begin
                barangArray.Neff := barangArray.Neff + 1;
                read(barangFile, barangArray.T[barangArray.Neff]);
            end;
            close(barangFile);
            writeln('Pembacaan ', namaFile, ' berhasil');
        except
            writeln('Pembacaan ', namaFile, ' gagal');
        end;
    end;

    procedure SaveNasabah(namaFile : string; nasabahArray : TNasabahArray);
    var
        i : integer;
    begin
        try
            assign(nasabahFile, namaFile);
            rewrite(nasabahFile);
            for i := 1 to nasabahArray.Neff do
                write(nasabahFile, nasabahArray.T[i]);
            close(nasabahFile);
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure SaveRekeningOnline(namaFile : string; rekeningOnlineArray : TRekeningOnlineArray);
    var
        i : integer;
    begin
        try
            assign(rekeningOnlineFile, namaFile);
            rewrite(rekeningOnlineFile);
            for i := 1 to rekeningOnlineArray.Neff do
                write(rekeningOnlineFile, rekeningOnlineArray.T[i]);
            close(rekeningOnlineFile);  
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure SaveTransaksiSetoranPenarikan(namaFile : string; transaksiSetoranPenarikanArray : TTransaksiSetoranPenarikanArray);
    var
        i : integer;
    begin
        try
            assign(transaksiSetoranPenarikanFile, namaFile);
            rewrite(transaksiSetoranPenarikanFile);
            for i := 1 to transaksiSetoranPenarikanArray.Neff do
                write(transaksiSetoranPenarikanFile, transaksiSetoranPenarikanArray.T[i]);
            close(transaksiSetoranPenarikanFile);
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure SaveTransaksiTransfer(namaFile : string; transaksiTransferArray : TTransaksiTransferArray);
    var
        i : integer;
    begin
        try
            assign(transaksiTransferFile, namaFile);
            rewrite(transaksiTransferFile);
            for i := 1 to transaksiTransferArray.Neff do
                write(transaksiTransferFile, transaksiTransferArray.T[i]);
            close(transaksiTransferFile);
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure SavePembayaran(namaFile : string; pembayaranArray : TPembayaranArray);
    var
        i : integer;
    begin
        try
            assign(pembayaranFile, namaFile);
            rewrite(pembayaranFile);
            for i := 1 to pembayaranArray.Neff do
                write(pembayaranFile, pembayaranArray.T[i]);
            close(pembayaranFile);
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure SavePembelian(namaFile : string; pembelianArray : TPembelianArray);
    var
        i : integer;
    begin
        try
            assign(pembelianFile, namaFile);
            rewrite(pembelianFile);
            for i := 1 to pembelianArray.Neff do
                write(pembelianFile, pembelianArray.T[i]);
            close(pembelianFile);
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure SaveNilaiTukarAntarMataUang(namaFile : string; nilaiTukarAntarMataUangArray : TNilaiTukarAntarMataUangArray);
    var
        i : integer;
    begin
        try
            assign(nilaiTukarAntarMataUangFile, namaFile);
            rewrite(nilaiTukarAntarMataUangFile);
            for i := 1 to nilaiTukarAntarMataUangArray.Neff do
                write(nilaiTukarAntarMataUangFile, nilaiTukarAntarMataUangArray.T[i]);
            close(nilaiTukarAntarMataUangFile);
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure SaveBarang(namaFile : string; barangArray : TBarangArray);
    var
        i : integer;
    begin
        try
            assign(barangFile, namaFile);
            rewrite(barangFile);
            for i := 1 to barangArray.Neff do
                write(barangFile, barangArray.T[i]);
            close(barangFile);
            writeln('Penulisan ', namaFile, ' berhasil');
        except
            writeln('Penulisan ', namaFile, ' gagal');
        end;
    end;

    procedure WriteRekening(rekeningOnlineArray : TRekeningOnlineArray);
    var
        i : integer;
    begin
        for i := 1 to rekeningOnlineArray.Neff do
            writeln(i, '. ', rekeningOnlineArray.T[i].nomorAkun);
    end;

    procedure DeleteRekening(i : integer; var rekeningOnlineArray : TRekeningOnlineArray);
    begin
        if (i > 0) and (i <= rekeningOnlineArray.Neff) then
        begin
            rekeningOnlineArray.Neff := rekeningOnlineArray.Neff - 1;
            for i := i to rekeningOnlineArray.Neff do
                rekeningOnlineArray.T[i] := rekeningOnlineArray.T[i+1];
        end;
    end;

    function getIndexRekening(nomorAkun : string; rekeningOnlineArray : TRekeningOnlineArray) : integer;
    var
        i : integer = 0;


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

    function getRekening(nasabah : string; rekeningOnlineArray : TRekeningOnlineArray; tabunganMandiri, tabunganRencana, deposito : boolean) : TRekeningOnlineArray;
    var
        temp_rekeningOnlineArray : TRekeningOnlineArray;
        i : integer;
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

    function getKurs(kursAsal, kursTujuan : string; nilai : longint; nilaiTukarAntarMataUangArray : TNilaiTukarAntarMataUangArray) : longint;
    var
        i : integer = 0;
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
    begin
        case t of
            '1' : t := 'DP';
            '2' : t := 'TR';
            '3' : t := 'TM';
            else t:= 'UK';
        end;

        generateNomorAkun := IntToStr(i mod 10) + t + Format('%.2d', [n]) + IntToStr((i * n) mod 10);
    end;

    function isOwner(nomorNasabah : string; indexRekening : integer; rekeningOnlineArray : TRekeningOnlineArray) : boolean;
    begin
        isOwner := rekeningOnlineArray.T[indexRekening].nomorNasabah = nomorNasabah;
    end;
end.
