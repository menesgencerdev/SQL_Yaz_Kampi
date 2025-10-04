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
('Spor Ekipmanlar�');  

INSERT INTO Satici (ad, adres) VALUES  
('TeknoD�kkan Ltd.', '�stanbul'),  
('Ev Mobilyalar�', 'Bursa'),  
('Bilgi Yay�nc�l�k', 'Ankara');  

INSERT INTO Musteri (ad, soyad, email, sehir) VALUES  
('Ahmet', 'Ko�', 'ahmet.koc@mail.com', '�stanbul'),  
('Elif', 'Ayd�n', 'elif.aydin@mail.com', 'Ankara'),  
('Murat', '�en', 'murat.sen@mail.com', '�zmir'),  
('Fatma', 'Arslan', 'fatma.arslan@mail.com', 'Antalya'),  
('Can', 'Y�ld�z', 'can.yildiz@mail.com', 'Bursa'),  
('Deniz', 'G�ne�', 'deniz.gunes@mail.com', '�stanbul');  

INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id) VALUES  
(N'Tablet Pro Max', 18000.00, 40, 1, 1),  
(N'Kulakl�k Ultra', 2000.00, 120, 1, 1),  
(N'Ah�ap �al��ma Masas�', 3500.00, 25, 2, 2),  
(N'Tarih Ansiklopedisi', 300.00, 60, 3, 3),  
(N'Ko�u Ayakkab�s�', 1200.00, 150, 4, 2),  
(N'Yoga Mat�', 450.00, 90, 4, 2);  

-- Sipari� 1: Ahmet Ko� (18000 + 2000 = 20000)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(1, 20000.00, 'Kredi Kart�', '2025-05-12');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(1, 1, 1, 18000.00),  
(1, 2, 1, 2000.00);  

-- Sipari� 2: Elif Ayd�n (3500 * 2 = 7000)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(2, 7000.00, 'Nakit', '2025-06-08');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(2, 3, 2, 3500.00);  

-- Sipari� 3: Murat �en (300 * 4 = 1200)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(3, 1200.00, 'Havale', '2025-06-18');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(3, 4, 4, 300.00);  

-- Sipari� 4: Deniz G�ne� (1200 * 1 + 450 * 2 = 2100)
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, tarih) VALUES  
(6, 2100.00, 'Kredi Kart�', '2025-07-25');  

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES  
(4, 5, 1, 1200.00),  
(4, 6, 2, 450.00);  
-- 4. VER� G�NCELLEME VE S�LME ��LEMLER�
-- UPDATE (M��teri e-posta g�ncelleme - Ahmet Ko�)
UPDATE Musteri 
SET email = 'ahmet.koc.yeni@mail.com' 
WHERE id = 1;

-- UPDATE (Stok g�ncelleme: Sipari� 4 i�in toplu stok d���rme - Deniz G�ne�'in sipari�i)
UPDATE Urun
SET stok = Urun.stok - T.toplam_adet
FROM Urun
JOIN (
    SELECT urun_id, SUM(adet) AS toplam_adet
    FROM Siparis_Detay
    WHERE siparis_id = 4
    GROUP BY urun_id
) AS T ON Urun.id = T.urun_id;

-- DELETE (�rnek sipari� detay� silme - Murat �en�in sipari�inden 1 detay sat�r�)
DELETE FROM Siparis_Detay 
WHERE id = 3;

-- TRUNCATE (Gereksiz tablolar� bo�altma)
-- �rn: ge�ici rapor tablosu varsa
-- TRUNCATE TABLE GeciciRaporlar;

-- 5. RAPORLAMA SORGULARI
PRINT N'--- RAPORLAMA SONU�LARI ---'
GO
-- En �ok sipari� veren 5 m��teri
SELECT TOP 5 
    M.ad, M.soyad, COUNT(S.id) AS SiparisSayisi
FROM Musteri M
JOIN Siparis S ON M.id = S.musteri_id
GROUP BY M.ad, M.soyad
ORDER BY SiparisSayisi DESC;

-- En �ok sat�lan �r�nler
SELECT 
    U.ad AS UrunAd�, SUM(SD.adet) AS ToplamSat�lanAdet
FROM Urun U
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY U.ad
ORDER BY ToplamSat�lanAdet DESC;

-- En y�ksek cirosu olan sat�c�lar
SELECT 
    Sa.ad AS SaticiAd�, SUM(SD.fiyat * SD.adet) AS Ciro
FROM Satici Sa
JOIN Urun U ON Sa.id = U.satici_id
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY Sa.ad
ORDER BY Ciro DESC;

-- �ehirlere g�re m��teri say�s�
SELECT 
    sehir, COUNT(id) AS MusteriSayisi
FROM Musteri
GROUP BY sehir;

-- Kategori bazl� toplam sat��lar
SELECT 
    K.ad AS Kategori, SUM(SD.adet * SD.fiyat) AS ToplamSatis
FROM Kategori K
JOIN Urun U ON K.id = U.kategori_id
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY K.ad
ORDER BY ToplamSatis DESC;

-- Aylara g�re sipari� say�s�
SELECT 
    YEAR(tarih) AS Yil, 
    MONTH(tarih) AS Ay, 
    COUNT(id) AS SiparisSayisi
FROM Siparis
GROUP BY YEAR(tarih), MONTH(tarih)
ORDER BY Yil, Ay;

-- Sipari�lerde m��teri, �r�n ve sat�c� bilgisi
SELECT
    S.id AS SiparisID,
    M.ad + ' ' + M.soyad AS MusteriAdSoyad,
    U.ad AS UrunAd�,
    Sa.ad AS SaticiAd�,
    SD.adet,
    SD.fiyat AS SatisFiyati
FROM Siparis S
JOIN Musteri M ON S.musteri_id = M.id
JOIN Siparis_Detay SD ON S.id = SD.siparis_id
JOIN Urun U ON SD.urun_id = U.id
JOIN Satici Sa ON U.satici_id = Sa.id
ORDER BY S.id;

-- Hi� sat�lmam�� �r�nler
SELECT 
    U.ad AS UrunAd�
FROM Urun U
LEFT JOIN Siparis_Detay SD ON U.id = SD.urun_id
WHERE SD.id IS NULL;

-- Hi� sipari� vermemi� m��teriler
SELECT 
    M.ad, M.soyad, M.email
FROM Musteri M
LEFT JOIN Siparis S ON M.id = S.musteri_id
WHERE S.id IS NULL;

-- En �ok kazan� sa�layan ilk 3 kategori
SELECT TOP 3 
    K.ad AS Kategori, SUM(SD.adet * SD.fiyat) AS ToplamKazanc
FROM Kategori K
JOIN Urun U ON K.id = U.kategori_id
JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY K.ad
ORDER BY ToplamKazanc DESC;

-- Ortalama sipari� tutar�n� ge�en sipari�ler
SELECT 
    id, musteri_id, toplam_tutar
FROM Siparis
WHERE toplam_tutar > (SELECT AVG(toplam_tutar) FROM Siparis);

-- En az bir kez Elektronik �r�n sat�n alan m��teriler
SELECT DISTINCT 
    M.ad, M.soyad, M.email
FROM Musteri M
JOIN Siparis S ON M.id = S.musteri_id
JOIN Siparis_Detay SD ON S.id = SD.siparis_id
JOIN Urun U ON SD.urun_id = U.id
JOIN Kategori K ON U.kategori_id = K.id
WHERE K.ad = 'Elektronik';