Create Database BTCTC

use BTCTC
Create Table Khoa(
MaKhoa Varchar(10) Not Null Primary Key,
TenKhoa Char(30),
DienThoai Char(12))

Create Table Lop(
MaLop Varchar(10) Not Null Primary Key,
TenLop Char(30),
HeDT Char(12),
NamNhapHoc Int,
MaKhoa Varchar(10),
Constraint FK_Lop Foreign Key (MaKhoa) References Khoa(MaKhoa) On Update Cascade On Delete Cascade)

Insert Into Khoa Values('MK01', 'Khoa 01', '0787878')
Insert Into Khoa Values('MK02', 'Khoa 02', '0454545')
Insert Into Khoa Values('MK03', 'Khoa 03', '0898989')

Select * From Khoa

Insert Into Lop Values('ML01', 'Lop 01', 'DH', 2020, 'MK02')
Insert Into Lop Values('ML02', 'Lop 02', 'CD', 2019, 'MK01')
Insert Into Lop Values('ML01', 'Lop 01', 'DH', 2021, 'MK02')

Select * From Lop

-- Create PROC SP_NHAPKHOA(@MaKhoa Varchar(10), @TenKhoa Char(30),
Alter PROC SP_NHAPKHOA(@MaKhoa Varchar(10), @TenKhoa Char(30), @DienThoai Char(12))
As
	Begin
		If(Exists(Select * From Khoa Where TenKhoa = @TenKhoa))
			Print 'Ten khoa ' + @TenKhoa + ' da ton tai.'
		Else 
			Print 'Ten khoa: ' + @TenKhoa + ' khong ton tai'
	End

-- TEST ---
Exec SP_NHAPKHOA 'MK02', 'Khoa 04', '0474747'
Exec SP_NHAPKHOA 'MK02', 'Khoa 01', '0474747'



-- Tạo thủ tục tìm kiếm

Create Proc SP_TIMKHOA(@MaKhoa Varchar(10))
As
	Begin
		If(Not Exists (Select * From Khoa Where MaKhoa = @MaKhoa))
			Print 'Ma khoa ' + @MaKhoa + ' khong ton tai.'
		Else
			Select * From Khoa Where MaKhoa = @MaKhoa
	End

--Test
Select * From Khoa
Exec SP_TIMKHOA 'MK02'
Exec SP_TIMKHOA 'MK05'

--Thủ tục thêm

Create Procedure SP_THEMKHOA(@MaKhoa Varchar(10), @TenKhoa Char(30), @DienThoai Char(12))
As
	Begin
		If(Exists (Select * From Khoa Where MaKhoa = @MaKhoa))
			Print 'Ma khoa ' + @MaKhoa + ' da ton tai.'
		Else
			Insert Into Khoa Values (@MaKhoa, @TenKhoa, @DienThoai)
	End
--Test
Exec SP_THEMKHOA 'MK02', 'Khoa 01', '08898989'
Exec SP_THEMKHOA 'MK01', 'Khoa 01', '08898989'
Select * From Khoa


-- Tạo thủ tục sửa:

Create Proc SP_SUAKHOA(@MaKhoa Varchar(10), @TenKhoa Char(30), @DienThoai Char(12))
As
	Begin
		If(Not Exists(Select * From Khoa Where MaKhoa = @MaKhoa))
			Print 'Ma khoa ' + @MaKhoa + ' khong ton tai'
		Else
			Update Khoa Set TenKhoa = @TenKhoa, DienThoai = @DienThoai
			Where MaKhoa = @MaKhoa
	End

--Test
Select * From Khoa
Exec SP_SUAKHOA 'MK02', 'Ke Toan', '0252525'

-- Tạo thủ tục xoá:

Create Proc SP_XOAKHOA(@MaKhoa Varchar(10))
As
	Begin 
		If(Not Exists (Select * From Khoa Where MaKhoa = @MaKhoa))
			Print 'Ma khoa ' +@MaKhoa + ' khong ton tai.'
		Else
			Delete Khoa Where MaKhoa = @MaKhoa
	End
-- Test
Exec SP_XOAKHOA 'MK05'
Exec SP_XOAKHOA 'MK01'
Select * From Khoa



