CREATE TABLE Musteri (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(50) NOT NULL,
    soyad NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    sehir NVARCHAR(50),
    kayit_tarihi DATE DEFAULT GETDATE()
);
CREATE TABLE Kategori (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE Satici (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(100) NOT NULL,
    adres NVARCHAR(200)
);
CREATE TABLE Urun (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(100) NOT NULL,
    fiyat DECIMAL(10,2) NOT NULL CHECK (fiyat > 0),
    stok INT NOT NULL CHECK (stok >= 0),
    kategori_id INT FOREIGN KEY REFERENCES Kategori(id),
    satici_id INT FOREIGN KEY REFERENCES Satici(id)
);
CREATE TABLE Siparis (
    id INT IDENTITY(1,1) PRIMARY KEY,
    musteri_id INT FOREIGN KEY REFERENCES Musteri(id) NOT NULL,
    tarih DATE DEFAULT GETDATE(),
    toplam_tutar DECIMAL(10,2) NOT NULL,
    odeme_turu NVARCHAR(50) NOT NULL
);
CREATE TABLE Siparis_Detay (
    id INT IDENTITY(1,1) PRIMARY KEY,
    siparis_id INT FOREIGN KEY REFERENCES Siparis(id) NOT NULL,
    urun_id INT FOREIGN KEY REFERENCES Urun(id) NOT NULL,
    adet INT NOT NULL CHECK (adet > 0),
    fiyat DECIMAL(10,2) NOT NULL
);
INSERT INTO Kategori (ad) VALUES  
('Elektronik'),  
('Mobilya'),  
('Kitap'),  
('Spor Ekipmanlarý');  

INSERT INTO Satici (ad, adres) VALUES  
('TeknoDükkan Ltd.', 'Ýstanbul'),  
('Ev Mobilyalarý', 'Bursa'),  
('Bilgi Yayýncýlýk', 'Ankara');  

INSERT INTO Musteri (ad, soyad, email, sehir) VALUES  
('Ahmet', 'Koç', 'ahmet.koc@mail.com', 'Ýstanbul'),  
('Elif', 'Aydýn', 'elif.aydin@mail.com', 'Ankara'),  
('Murat', 'Þen', 'murat.sen@mail.com', 'Ýzmir'),  
('Fatma', 'Arslan', 'fatma.arslan@mail.com', 'Antalya'),  
('Can', 'Yýldýz', 'can.yildiz@mail.com', 'Bursa'),  
('Deniz', 'Güneþ', 'deniz.gunes@mail.com', 'Ýstanbul');  

INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id) VALUES  
(N'Tablet Pro Max', 18000.00, 40, 1, 1),  
(N'Kulaklýk Ultra', 2000.00, 120, 1, 1),  
(N'Ahþap Çalýþma Masasý', 3500.00, 25, 2, 2),  
(N'Tarih Ansiklopedisi', 300.00, 60, 3, 3),  
(N'Koþu Ayakkabýsý', 1200.00, 150, 4, 2),  
(N'Yoga Matý', 450.00, 90, 4, 2);  

-- Sipariþ 1: Ahmet Koç (18000 + 2000 = 20000)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(1, 20000.00, 'Kredi Kartý', '2025-05-12');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(1, 1, 1, 18000.00),  
(1, 2, 1, 2000.00);  

-- Sipariþ 2: Elif Aydýn (3500 * 2 = 7000)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(2, 7000.00, 'Nakit', '2025-06-08');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(2, 3, 2, 3500.00);  

-- Sipariþ 3: Murat Þen (300 * 4 = 1200)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(3, 1200.00, 'Havale', '2025-06-18');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(3, 4, 4, 300.00);  

-- Sipariþ 4: Deniz Güneþ (1200 * 1 + 450 * 2 = 2100)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(6, 2100.00, 'Kredi Kartý', '2025-07-25');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(4, 5, 1, 1200.00),  
(4, 6, 2, 450.00);  
-- 4. VERÝ GÜNCELLEME VE SÝLME ÝÞLEMLERÝ
-- UPDATE (Müþteri e-posta güncelleme - Ahmet Koç)
UPDATE Musteri 
SET email = 'ahmet.koc.yeni@mail.com' 
WHERE id = 1;

-- UPDATE (Stok güncelleme: Sipariþ 4 için toplu stok düþürme - Deniz Güneþ'in sipariþi)
UPDATE Urun
SET stok = Urun.stok - T.toplam_adet
FROM Urun
JOIN (
    SELECT urun_id, SUM(adet) AS toplam_adet
    FROM Siparis_Detay
    WHERE siparis_id = 4
    GROUP BY urun_id
) AS T ON Urun.id = T.urun_id;

-- DELETE (Örnek sipariþ detayý silme - Murat Þen’in sipariþinden 1 detay satýrý)
DELETE FROM Siparis_Detay 
WHERE id = 3;

-- TRUNCATE (Gereksiz tablolarý boþaltma)
-- Örn: geçici rapor tablosu varsa
-- TRUNCATE TABLE GeciciRaporlar;

-- 5. RAPORLAMA SORGULARI
PRINT N'--- RAPORLAMA SONUÇLARI ---'
GO
-- En çok sipariþ veren 5 müþteri
SELECT TOP 5 
    M.ad, M.soyad, COUNT(S.id) AS SiparisSayisi
FROM Musteri M
JOIN Siparis S ON M.id = S.musteri_id
GROUP BY M.ad, M.soyad
ORDER BY SiparisSayisi DESC;

-- En çok satýlan ürünler
SELECT 
    U.ad AS UrunAdý, SUM(SD.adet) AS ToplamSatýlanAdet
FROM Urun U
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY U.ad
ORDER BY ToplamSatýlanAdet DESC;

-- En yüksek cirosu olan satýcýlar
SELECT 
    Sa.ad AS SaticiAdý, SUM(SD.fiyat * SD.adet) AS Ciro
FROM Satici Sa
JOIN Urun U ON Sa.id = U.satici_id
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY Sa.ad
ORDER BY Ciro DESC;

-- Þehirlere göre müþteri sayýsý
SELECT 
    sehir, COUNT(id) AS MusteriSayisi
FROM Musteri
GROUP BY sehir;

-- Kategori bazlý toplam satýþlar
SELECT 
    K.ad AS Kategori, SUM(SD.adet * SD.fiyat) AS ToplamSatis
FROM Kategori K
JOIN Urun U ON K.id = U.kategori_id
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY K.ad
ORDER BY ToplamSatis DESC;

-- Aylara göre sipariþ sayýsý
SELECT 
    YEAR(tarih) AS Yil, 
    MONTH(tarih) AS Ay, 
    COUNT(id) AS SiparisSayisi
FROM Siparis
GROUP BY YEAR(tarih), MONTH(tarih)
ORDER BY Yil, Ay;

-- Sipariþlerde müþteri, ürün ve satýcý bilgisi
SELECT
    S.id AS SiparisID,
    M.ad + ' ' + M.soyad AS MusteriAdSoyad,
    U.ad AS UrunAdý,
    Sa.ad AS SaticiAdý,
    SD.adet,
    SD.fiyat AS SatisFiyati
FROM Siparis S
JOIN Musteri M ON S.musteri_id = M.id
JOIN Siparis_Detay SD ON S.id = SD.siparis_id
JOIN Urun U ON SD.urun_id = U.id
JOIN Satici Sa ON U.satici_id = Sa.id
ORDER BY S.id;

-- Hiç satýlmamýþ ürünler
SELECT 
    U.ad AS UrunAdý
FROM Urun U
LEFT JOIN Siparis_Detay SD ON U.id = SD.urun_id
WHERE SD.id IS NULL;

-- Hiç sipariþ vermemiþ müþteriler
SELECT 
    M.ad, M.soyad, M.email
FROM Musteri M
LEFT JOIN Siparis S ON M.id = S.musteri_id
WHERE S.id IS NULL;

-- En çok kazanç saðlayan ilk 3 kategori
SELECT TOP 3 
    K.ad AS Kategori, SUM(SD.adet * SD.fiyat) AS ToplamKazanc
FROM Kategori K
JOIN Urun U ON K.id = U.kategori_id
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY K.ad
ORDER BY ToplamKazanc DESC;

-- Ortalama sipariþ tutarýný geçen sipariþler
SELECT 
    id, musteri_id, toplam_tutar
FROM Siparis
WHERE toplam_tutar > (SELECT AVG(toplam_tutar) FROM Siparis);

-- En az bir kez Elektronik ürün satýn alan müþteriler
SELECT DISTINCT 
    M.ad, M.soyad, M.email
FROM Musteri M
JOIN Siparis S ON M.id = S.musteri_id
JOIN Siparis_Detay SD ON S.id = SD.siparis_id
JOIN Urun U ON SD.urun_id = U.id
JOIN Kategori K ON U.kategori_id = K.id
WHERE K.ad = 'Elektronik';