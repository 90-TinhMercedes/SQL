create database QLBanHang_Ngay_24022021

use QLBanHang_Ngay_24022021

create table HangSX (
	MaHangSX char(10) not null primary key,
	TenHang nvarchar(50),
	DiaChi nvarchar(50),
	SoDT nvarchar(50),
	Email nvarchar(50)
)

create table SanPham (
	MaSP char(10) not null primary key,
	MaHangSX char(10),
	TenSP nvarchar(50),
	SoLuong int,
	MauSac nvarchar(50),
	GiaBan money,
	DonViTinh nvarchar(50),
	MoTa nvarchar(50),
	constraint FK_SanPham foreign key (MaHangSX) references HangSX (MaHangSX) on update cascade on delete cascade
)

create table NhanVien (
	MaNV char(10) not null primary key,
	TenNV nvarchar(50),
	GioiTinh nvarchar(50),
	DiaChi nvarchar(50),
	SoDT nvarchar(50),
	Email nvarchar(50),
	TenPhong nvarchar(50)
)

create table PNhap (
	SoHDN char(10) not null primary key,
	NgayNhap datetime,
	MaNV char(10),
	constraint FK_PNhap foreign key (MaNV) references NhanVien(MaNV) on update cascade on delete cascade
)

create table Nhap (
	SoHDN char(10),
	MaSP char(10),
	SoLuongN int,
	DonGiaN money,
	constraint PK_Nhap primary key (SoHDN, MaSP),
	constraint FK_Nhap_01 foreign key (SoHDN) references PNhap(SoHDN) on update cascade on delete cascade,
	constraint FK_Nhap_02 foreign key (MaSP) references SanPham(MaSP) on update cascade on delete cascade
)

create table PXuat (
	SoHDX char(10) not null primary key,
	NgayXuat datetime,
	MaNV char(10)
	constraint FK_PXuat foreign key (MaNV) references NhanVien(MaNV) on update cascade on delete cascade
)

create table Xuat (
	SoHDX char(10),
	MaSP char(10),
	SoLuongX int,
	constraint PK_Xuat primary key (SoHDX, MaSP),
	constraint FK_Xuat_01 foreign key (SoHDX) references PXuat(SoHDX) on update cascade on delete cascade,
	constraint FK_Xuat_02 foreign key (MaSP) references SanPham(MaSP) on update cascade on delete cascade
)

insert into HangSX values('HSX01', 'Hang 01', 'Dia Chi 01', '045454545', 'hang01@gmail.com')
insert into HangSX values('HSX02', 'Hang 02', 'Dia Chi 02', '045454545', 'hang02@gmail.com')
insert into HangSX values('HSX03', 'Hang 03', 'Dia Chi 03', '045454545', 'hang03@gmail.com')
insert into HangSX values('HSX04', 'Hang 04', 'Dia Chi 04', '045454545', 'hang04@gmail.com')
insert into HangSX values('HSX05', 'Hang 05', 'Dia Chi 05', '045454545', 'hang05@gmail.com')

insert into SanPham values('SP01', 'HSX01', 'San Pham 01', 500, '7 mau', 25000, 'cai', 'tinh handsome')
insert into SanPham values('SP02', 'HSX02', 'San Pham 02', 200, 'tim', 15000, 'cai', 'tinh handsome')
insert into SanPham values('SP03', 'HSX02', 'San Pham 03', 350, '7 mau', 20000, 'chiec', 'tinh handsome')
insert into SanPham values('SP04', 'HSX01', 'San Pham 04', 150, 'xanh', 31000, 'cai', 'tinh handsome')
insert into SanPham values('SP05', 'HSX01', 'San Pham 05', 210, 'do', 19000, 'chiec', 'tinh handsome')
insert into SanPham values('SP06', 'HSX03', 'San Pham 06', 190, 'lam', 16000, 'cai', 'tinh handsome')


-- Cau a. Hãy xây dựng hàm Đưa ra tên HangSX khi nhập vào MaSP từ bàn phím

create function cauA(@MaSP char(10))
returns nvarchar(50)
as
	begin
		declare @HangSX nvarchar(50)
		set @HangSX = (select TenHang 
		from HangSX inner join SanPham on HangSX.MaHangSX = SanPham.MaHangSX 
		where  SanPham.MaSP = @MaSP)
		return @HangSX
	end

select dbo.cauA('SP06') as 'Ten hang'