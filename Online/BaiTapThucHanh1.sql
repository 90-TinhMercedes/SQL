Create Database QLSV
Create Table SINHVIEN
(
MaSV Varchar(12) Not Null Primary Key,
Ten Nvarchar(10),
Que Nvarchar(100)
)

Create Table MonHoc
(
MaMH Char(10) Not Null Primary Key,
TenMH Nvarchar(100),
SoTc int
)

Create Table KQ
(
MaSV Varchar(12) Not Null,
MaMH Char(10) Not Null,
diem float
CONSTRAINT pk_KQ PRIMARY KEY (MaSv, MaMH),
CONSTRAINT fk_KQ_MaSV FOREIGN KEY(MaSV) REFERENCES SINHVIEN(MaSV) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_KQ_MaMH FOREIGN KEY(MaMH) REFERENCES MonHoc(MaMH) ON DELETE CASCADE ON UPDATE CASCADE
)

USE QLSV
GO
-- Sử dụng biến
Declare @TENSV NVARCHAR(10)
Select TENSV = TEN From SINHVIEN
Where MASV = 1
Select * From SINHVIEN
Select @SINHVIEN As KQ


-- Hàm tính điểm trung bình cho từng sinh viên
Create FUNCTION dbo.F_diemTB ()
Return Table
As 
Return Select KQ.MASV, Sum(Diem * SoTc)/Sum(SoTc) As DTB
From MonHoc, KQ
Where MonHoc.MaMH = KQ.MaMH
Group By KQ.MaSV
Select * From dbo.F_diemTB



