-- Tạo thủ tục thêm, sửa, xoá, tìm kiếm 

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



----------------------------------------------------------------------------



--Bài tập 02 ngày 03/03/2021

Create Database QLBanHangVer03032021
Use QLBanHangVer03032021

Create Table SanPham(
MaSP Char(10) Not Null Primary Key,
MauSac Char(20),
SoLuong Int,
GiaBan Money)

Create Table CongTy(
MaCT Char(10) Not Null Primary key,
TenCT Char(20),
TrangThai Char(20),
ThanhPho Char(20))

Create Table CungUng(
MaCT Char(10),
MaSP Char(10),
SoLuongCungUng Int,
Constraint PK_CungUng Primary Key (MaCT, MaSP),
Constraint FK_CungUngCT Foreign Key (MaCT) References CongTy(MaCT) On Update Cascade On Delete Cascade,
Constraint FK_CungUngSP Foreign Key (MaSP) References SanPham(MaSP) On Update Cascade On Delete Cascade)

-- a. Nhập thông tin

insert into SanPham values('SP1','xanh', 10,25000)
insert into SanPham values('SP2','lam', 17,20000)
insert into SanPham values('SP3','den', 64,47000)

insert into CongTy values ('CT1','Samsung','ready','Ha Nam')
insert into CongTy values ('CT2','Dell','erroe','Hai Phong')
insert into CongTy values ('CT3','Lenovo','ready','Ha Noi')

insert into CungUng values ('CT1','SP1',5)
insert into CungUng values ('CT2','SP2',15)
insert into CungUng values ('CT2','SP1',7)
insert into CungUng values ('CT3','SP3',22)

select * from SanPham
select * from CongTy
select * from CungUng

-- b. Thống kê tổng tiền cung ứng theo từng công ty
Create View ThongKe
As
	Select CungUng.MaCT,TenCT,sum(SoLuongCungUng*GiaBan) as 'Tong tien'
	From CungUng inner join SanPham On CungUng.MaSp= SanPham.MaSP inner join CongTy On CungUng.MaCT=CongTy.MaCT
	Group By CungUng.MaCT,TenCT

Select * From ThongKe

-- c. Danh sách sản phẩm cung ứng của tưng công ty

Create Function DSSP(@TENCT Char(20))
Returns @tam Table (macty Char(10), tencty char(20), masp char(20))
as
	begin
				insert into @tam
				select CongTy.MaCT, CongTy.TenCT, SanPham.MaSP
				from CongTy inner join CungUng on CongTy.MaCT = CungUng.MaCT
					inner join SanPham on CungUng.MaSP = SanPham.MaSP
				where TenCT = @TENCT
				return
	end
select * from DSSP ('Dell')
select * from DSSP ('Samsung')

