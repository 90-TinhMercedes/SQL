CREATE DATABASE BanHang
GO
USE BanHang
GO
CREATE TABLE HangSX
(
MaHangSX CHAR(5) NOT NULL PRIMARY KEY, 
TenHang NVARCHAR(30) NOT NULL,
DiaChi NVARCHAR(30) NOT NULL,
SoDT CHAR(10) NOT NULL,
Email CHAR(20) NOT NULL
)

Create table SanPham ( 
MaSP char(10) not null primary key,
MaHangSX char(5) not null, 
TenSP nvarchar(30) NOT NULL, 
SoLuong int NOT NULL, 
MauSac nvarchar(20) NOT NULL, 
GiaBan money NOT NULL, 
DonViTinh char(10) NOT NULL, 
MoTa nvarchar(20) NOT NULL, 
Constraint FK_SanPham foreign key (MaHangSX) references HangSX(MaHangSX) on update cascade on delete cascade
) 

create table NhanVien(
MaNV char(5) NOT NULL primary key,
TenNV nvarchar (100) NOT NULL,
GioiTinh char (10) NOT NULL,
DiaChi nvarchar(30) NOT NULL,
SoDT char(10) NOT NULL,
Email char(20) NOT NULL,
TenPhong nvarchar(100) NOT NULL,
)

create table PNhap(
SoHDN char(5) NOT NULL primary key,
NgayNhap datetime NOT NULL,
MaNV char(5) NOT NULL,
constraint fk_PNhap foreign key (MaNV) references NhanVien(MaNV) on update cascade on delete cascade,
)

create table Nhap(
SoHDN char(5) NOT NULL,
MaSP char(10) NOT NULL,
SoLuongN int NOT NULL,
DonGiaN money NOT NULL,
constraint key_Nhap primary key(SoHDN,MaSP),
constraint fk_Nhap_MaSP foreign key (MaSP) references SanPham(MaSP) on update cascade on delete cascade,
constraint fk_Nhap_SoHDN foreign key (SoHDN) references PNhap(SoHDN) on update cascade on delete cascade
)

create table PXuat(
SoHDX char(5) NOT NULL primary key,
NgayXuat datetime NOT NULL,
MaNV char(5) NOT NULL,
constraint fk_PXuat_MaNV foreign key (MaNV) references NhanVien(MaNV)
)

create table Xuat(
SoHDX char(5) NOT NULL ,
MaSP char(10) NOT NULL,
SoluongX int NOT NULL,
constraint pk_Xuat PRIMARY KEY (SoHDX, MaSP),
constraint fk_Xuat_SoHDX foreign key (SoHDX) references PXuat(SoHDX) on update cascade on delete cascade,
constraint fk_Xuat_MaSP foreign key (MaSP) references SanPham(MaSP) on update cascade on delete cascade,
)

insert into HangSX values('HSX1', 'Hang 01', 'Cau Giay', '0787878', 'caugiay@gmail.com')
insert into HangSX values('HSX2', 'Hang 02', 'Nam Tu Liem', '0454545', 'namtuliem@gmail.com')
insert into HangSX values('HSX3', 'Hang 03', 'Bac Tu Liem', '0565656', 'bactuliem@gmail.com')
insert into HangSX values('HSX4', 'Hang 04', 'Dong Anh', '0121212', 'donganhy@gmail.com')
insert into HangSX values('HSX5', 'Hang 05', 'Hai Ba Trung', '0323232', 'haibatrung@gmail.com')
insert into HangSX values('HSX6', 'Samsung', 'Hoan Kiem', '0131313', 'samsung@gmail.com')

Select * From HangSX

insert into SanPham values('SP1', 'HSX2', 'Banh Bao', 15, 'Trang', 7000, 'cai', 'hinh tron')
insert into SanPham values('SP2', 'HSX3', 'Banh Chung', 25, 'Xanh', 27000, 'cai', 'hinh vuong')
insert into SanPham values('SP3', 'HSX2', 'Banh Tet', 17, 'Xanh', 25000, 'cai', 'hinh tru')
insert into SanPham values('SP4', 'HSX1', 'Banh Dau Xanh', 13, 'Vang', 15000, 'hop', 'hinh vuong')
insert into SanPham values('SP5', 'HSX4', 'Banh Chocopice', 18, 'Den', 30000, 'hop', 'hinh tron')
insert into SanPham values('SP6', 'HSX6', 'Tai Nghe', 80, 'Den', 1200000, 'chiec', 'hinh tron')
insert into SanPham values('SP7', 'HSX6', 'Smart Phone', 25, 'Trang', 3000000, 'chiec', 'hinh chu nhat')

Select * From SanPham

insert into NhanVien values('NV1', 'Bui Ngoc Anh', 'Nu', 'Cau Giay', '0454545', 'ngocanhh@gamil.com', 'Thu ngan')
insert into NhanVien values('NV2', 'Bui Thi Hai', 'Nu', 'Hai Ba Trung', '0565656', 'buihai@gamil.com', 'Thu quy')
insert into NhanVien values('NV3', 'Ha Ngoc Son', 'Nam', 'Kon Tum', '0141414', 'ngocson@gamil.com', 'Bao ve')
insert into NhanVien values('NV4', 'Vu Van Tam', 'Nam', 'Ba Vi', '0898989', 'vantam@gamil.com', 'Thu ngan')
insert into NhanVien values('NV5', 'Nguyen Van Ba', 'Nam', 'Quoc Oai', '0525252', 'vanba@gamil.com', 'Truong phong')

Select * From NhanVien

insert into PNhap values('N01', '12/05/2020', 'NV2')
insert into PNhap values('N02', '10/07/2020', 'NV1')
insert into PNhap values('N03', '07/28/2020', 'NV3')
insert into PNhap values('N04', '08/15/2020', 'NV3')
insert into PNhap values('N05', '09/23/2020', 'NV5')

Select * From PNhap

insert into Nhap values('N02', 'SP1', '10', 5000)
insert into Nhap values('N05', 'SP2', '11', 7000)
insert into Nhap values('N03', 'SP4', '8', 8000)
insert into Nhap values('N02', 'SP4', '5', 9000)
insert into Nhap values('N01', 'SP3', '10', 6000)

Select * From Nhap

insert into PXuat values('X01', '12/07/2020', 'NV3')
insert into PXuat values('X02', '11/08/2020', 'NV4')
insert into PXuat values('X03', '07/22/2020', 'NV2')
insert into PXuat values('X04', '06/18/2020', 'NV5')
insert into PXuat values('X05', '07/23/2020', 'NV1')

Select * From PXuat

insert into Xuat values('X03', 'SP3', '10')
insert into Xuat values('X04', 'SP2', '11')
insert into Xuat values('X02', 'SP1', '8')
insert into Xuat values('X02', 'SP4', '5')
insert into Xuat values('X01', 'SP5', '10')
insert into Xuat values('X05', 'SP6', '15')
insert into Xuat values('X05', 'SP7', '5')
insert into Xuat values('X01', 'SP6', '11000')
insert into Xuat values('X03', 'SP7', '10010')

Select * From Xuat

--cau a
Create View CauA AS
Select HangSX.MaHangSX, TenHang, count (*) AS 'So Luong SP'
From SanPham Inner Join HangSX On SanPham.MaHangSX = HangSX.MaHangSX
Group By HangSX.MaHangSX, TenHang

Select * From CauA

--cau b
Create View CauB AS
Select SanPham.MaSP, TenSP, sum(SoLuongN * DonGiaN) AS 'Tổng tiền nhập'
From Nhap Inner Join PNhap On Nhap.SoHDN = PNhap.SoHDN
		  Inner Join SanPham On SanPham.MaSP = Nhap.MaSP
Where Year(NgayNhap) = 2020
Group By SanPham.MaSP, TenSP

Select * From CauB

--cau c
Create View CauC AS
Select SanPham.MaSP, TenSP, sum(SoLuongX) AS 'Tổng xuất'
From Xuat Inner Join PXuat On Xuat.SoHDX = PXuat.SoHDX
		  Inner Join SanPham On Xuat.MaSP = SanPham.MaSP
		  Inner Join HangSX On HangSX.MaHangSX = SanPham.MaHangSX
Where Year(NgayXuat) = 2020 And TenHang = 'Samsung'
Group By SanPham.MaSP, TenSP
Having Sum(SoluongX) >= 10000

Select * From CauC








