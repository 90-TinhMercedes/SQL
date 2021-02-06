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

Select * From Nhap

Insert into Xuat values( 'X1', 'VT1', 2, 10, '4/5/2020') 
Insert into Xuat values( 'X2', 'VT4', 2, 10, '9/6/2020')

Select * From Xuat

CREATE VIEW CAU2
AS
Select Ton.MaVT,TenVT,sum(SoLuongX*DonGiaX) As 'tien ban'
From Xuat inner join ton On Xuat.MaVT=Ton.MaVT
Group By Ton.MaVT,TenVT

SELECT * FROM CAU2


Create View CAU3 As
Select ton.TenVT,sum(SoLuongx) As 'Tong slx'
From xuat INNER JOIN ton On Xuat.MaVT=Ton.MaVT
Group By Ton.TenVT

Select * From CAU3

CREATE VIEW CAU4 AS
SELECT Ton.TenVT, sum(SoLuongN) AS 'Tong So Luong Nhap'
FROM Nhap INNER JOIN ton ON Nhap.MaVT=ton.MaVT
GROUP BY Ton.TenVT

Drop View CAU4

Select * From CAU4

Create View CAU5 AS
Select ton.MaVT, TenVT, sum(SoLuongN)-sum(SoLuongX) + sum(soluongT) As 'Tong ton'
From Nhap INNER JOIN ton On Nhap.MaVT=Ton.MaVT
INNER JOIN Xuat on Ton.MaVT=Xuat.MaVT
Group By Ton.MaVT,Ton.TenVT

SELECT * FROM CAU5