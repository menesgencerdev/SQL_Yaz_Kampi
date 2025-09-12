/*create table books(book_id int primary key identity,title nvarchar(255)not null,author nvarchar(255)not null,genre nvarchar(50),
price decimal(10,2)check(price>0),stock int check(stock>=0),published_year int check(published_year between 1900 and 2025),
added_at date
);*/
/*insert into books(title,author,genre,price,stock,published_year,added_at)
VALUES
(N'Kayýp Zamanýn Ýzinde', N'M. Proust', N'roman', 129.90, 25, 1913, '2025-08-20'),
(N'Simyacý', N'P. Coelho', N'roman', 89.50, 40, 1988, '2025-08-21'),
(N'Sapiens', N'Y. N. Harari', N'tarih', 159.00, 18, 2011, '2025-08-25'),
(N'Ýnce Memed', N'Y. Kemal', N'roman', 99.90, 12, 1955, '2025-08-22'),
(N'Körlük', N'J. Saramago', N'roman', 119.00, 7, 1995, '2025-08-28'),
(N'Dune', N'F. Herbert', N'bilim', 149.00, 30, 1965, '2025-09-01'),
(N'Hayvan Çiftliði', N'G. Orwell', N'roman', 79.90, 55, 1945, '2025-08-23'),
(N'1984', N'G. Orwell', N'roman', 99.00, 35, 1949, '2025-08-24'),
(N'Nutuk', N'M. K. Atatürk', N'tarih', 139.00, 20, 1927, '2025-08-27'),
(N'Küçük Prens', N'A. de Saint-Exupéry', N'çocuk', 69.90, 80, 1943, '2025-08-26'),
(N'Baþlangýç', N'D. Brown', N'roman', 109.00, 22, 2017, '2025-09-02'),
(N'Atomik Alýþkanlýklar', N'J. Clear', N'kiþisel geliþim', 129.00, 28, 2018, '2025-09-03'),
(N'Zamanýn Kýsa Tarihi', N'S. Hawking', N'bilim', 119.50, 16, 1988, '2025-08-29'),
(N'Þeker Portakalý', N'J. M. de Vasconcelos', N'roman', 84.90, 45, 1968, '2025-08-30'),
(N'Bir Ýdam Mahkûmunun Son Günü', N'V. Hugo', N'roman', 74.90, 26, 1829, '2025-08-31');
select * from books */
--1.	1. Tüm kitapların title, author, price alanlarını fiyatı artan şekilde sıralayarak listeleyin.
--select title,author,price from books order by price asc;
--2.	2. Türü 'roman' olan kitapları A→Z title sırasıyla gösterin.
--select * from books where genre='roman' order by title asc;
--3.	3. Fiyatı 80 ile 120 (dahil) arasındaki kitapları listeleyin (BETWEEN).
--select * from books where price>=80 and price<=120;
--4.	4. Stok adedi 20’den az olan kitapları bulun (title, stock_qty).
--select * from books where stock<20;
--5.	5. title içinde 'zaman' geçen kitapları LIKE ile filtreleyin (büyük/küçük harf durumunu not edin).
--select * from books where title like '%Zaman%';
--6.	6. genre değeri 'roman' veya 'bilim' olanları IN ile listeleyin.
--select * from books where genre in ('roman','bilim');
--7.	7. published_year değeri 2000 ve sonrası olan kitapları, en yeni yıldan eskiye doğru sıralayın.
--select * from books where published_year>2000 order by published_year desc ;
--8.	8. Son 10 gün içinde eklenen kitapları bulun (added_at tarihine göre).
--select * from books where added_at>=DATEADD(Day,-10,GETDATE());
--9.	9. En pahalı 5 kitabı price azalan sırada listeleyin (LIMIT 5).
--select top 5 * from books order by price desc; 
--10.	10. Stok adedi 30 ile 60 arasında olan kitapları price artan şekilde sıralayın.
--select * from books where stock>=30 and stock<=60 order by price asc;