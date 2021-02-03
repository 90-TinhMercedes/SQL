CREATE DATABASE QLKHO

GO
CREATE TABLE Ton
(
MaVT CHAR(10) PRIMARY KEY not null,
TenVT NVARCHAR(30) not null,
SoLuongT INT
)
GO
CREATE TABLE Nhap
(
SoHDN CHAR(5),
MaVT CHAR(10),
SoLuongN INT,
DonGiaN MONEY,
NgayN DATETIME,
CONSTRAINT pk_Nhap PRIMARY KEY (SoHDN, MaVT),
CONSTRAINT fk_Nhap_MaVT FOREIGN KEY(MaVT) REFERENCES Ton(MaVT) ON DELETE CASCADE ON UPDATE CASCADE
)
GO
DROP TABLE Nhap
GO
CREATE TABLE Xuat
(
SoHDX CHAR(5),
MaVT CHAR(10),
SoLuongX INT,
DonGiaX MONEY,
NgayX DATETIME,
CONSTRAINT pk_Xuat PRIMARY KEY (SoHDX, MaVT),
CONSTRAINT fk_Xuat_MaVT FOREIGN KEY(MaVT) REFERENCES Ton(MaVT) ON DELETE CASCADE ON UPDATE CASCADE
)
GO
DROP TABLE Xuat
GO

Insert into Ton values('VT1', 'Thuoc', 50)
Insert into Ton values('VT2', 'But', 15)
Insert into Ton values('VT3', 'Vo', 17)
Insert into Ton values('VT4', 'Tay', 10)
Insert into Ton values('VT5', 'Sach', 140)
GO
SELECT * FROM Ton


Insert into Nhap values('N1', 'VT5', 2, 100, '5/5/2020') 
Insert into Nhap values('N2', 'VT2', 2, 10, '5/6/2020') 
Insert into Nhap values('N3', 'VT1', 6, 100, '5/7/2020') 

Insert into Xuat values( 'X1', 'VT1', 2, 10, '4/5/2020') 
Insert into Xuat values( 'X2', 'VT4', 2, 10, '9/6/2020')

CREATE VIEW CAU2
AS
select Ton.MaVT,TenVT,sum(SoLuongX*DonGiaX) as 'tien ban'
from Xuat inner join ton on Xuat.MaVT=Ton.MaVT
group by Ton.MaVT,TenVT

SELECT * FROM CAU2


create view CAU3 as
select ton.TenVT,sum(SoLuongx) as 'Tong sl'
from xuat INNER JOIN ton on Xuat.MaVT=Ton.MaVT
group by Ton.TenVT

select * from CAU3

CREATE VIEW CAU4 AS
SELECT Ton.TenVT,sum(SoLuongN) AS 'Tong slN'
FROM Nhap INNER JOIN ton ON Nhap.MaVT=ton.MaVT
GROUP BY Ton.TenVT

select * from CAU4

create view CAU5 AS
select ton.MaVT,sum(SoLuongN)-sum(SoLuongX) + sum(soluongT)as 'Tong ton'
from Nhap INNER JOIN ton on Nhap.MaVT=Ton.MaVT
INNER JOIN Xuat on Ton.MaVT=Xuat.MaVT
group by Ton.MaVT,Ton.TenVT

SELECT * FROM CAU5