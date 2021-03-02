
CREATE DATABASE BanHangVer2
USE BanHangVer2
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
SoLuongN int,
DonGiaN money ,
constraint PK_Nhap primary key(SoHDN,MaSP),
constraint FK_Nhap_MaSP foreign key (MaSP) references SanPham(MaSP) on update cascade on delete cascade,
constraint FK_Nhap_SoHDN foreign key (SoHDN) references PNhap(SoHDN) on update cascade on delete cascade
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

insert into HangSX values('HSX1', 'Hang 01', 'Hùng Yến ', '0787878', 'fibcgjf@gmail.com')
insert into HangSX values('HSX2', 'Hang 02', 'Nam Ha ', '0454545', 'Abc@gmail.com')
insert into HangSX values('HSX3', 'Hang 03', 'Tu  Hoang ', '0565656', 'bactuliem@gmail.com')
insert into HangSX values('HSX4', 'Hang 04', 'Dong Anh', '0121212', 'donganhy@gmail.com')
insert into HangSX values('HSX5', 'Hang 05', 'Hai Ba Trung', '0323232', 'haibaisu@gmail.com')
insert into HangSX values('HSX6', 'Samsung', 'Hoan Kiem', '0131313', 'samsung@gmail.com')

Select * From HangSX

insert into SanPham values('SP1', 'HSX2', 'Banh Bao', 15, 'Trang', 7000, 'cai', 'hinh tron')
insert into SanPham values('SP2', 'HSX3', 'Banh Chung', 25, 'Xanh', 27000, 'cai', 'hinh vuong')
insert into SanPham values('SP3', 'HSX2', 'Banh Tet', 17, 'Xanh', 25000, 'cai', 'hinh tru')
insert into SanPham values('SP4', 'HSX1', 'Banh Dau Xanh', 13, 'Vang', 15000, 'hop', 'hinh vuong')
insert into SanPham values('SP5', 'HSX4', 'Banh Chocopice', 18, 'Den', 30000, 'hop', 'hinh tron')
insert into SanPham values('SP7', 'HSX6', 'Smart Phone', 25, 'Trang', 3000000, 'chiec', 'hinh chu nhat')
insert into SanPham values('SP8', 'HSX1', 'Smart Tivi', 15, 'Xam', 5000000, 'chiec', 'hinh chu nhat')

Select * From SanPham

insert into NhanVien values('NV1', 'Ha Thi Phuong ', 'Nu', 'Cau Giay', '0454545', 'phuongha@gmail.com', 'Thu ngan')
insert into NhanVien values('NV2', 'Bui Thi Hai', 'Nu', 'Hai Ba Trung', '0565656', 'ngochai@gmail.com', 'Thu quy')
insert into NhanVien values('NV3', 'Ha Ngoc Son', 'Nam', 'Kon Tum', '0141414', 'ngocson@gmail.com', 'Bao ve')
insert into NhanVien values('NV4', 'Vu Van Tam', 'Nam', 'Ba Vi', '0898989', 'vantam@gmail.com', 'Thu ngan')
insert into NhanVien values('NV5', 'Nguyen Van Ba', 'Nam', 'Quoc Oai', '0525252', 'vanba@gmail.com', 'Truong phong')
insert into NhanVien values('NV6', 'Vi Hung', 'Nam', 'Thanh Liem', '0484848', 'vihung@gmail.com', 'Truong phong')
insert into NhanVien values('NV7', 'Yen Dung', 'Nu', 'Duy Tien', '0464646', 'yendung@gmail.com', 'Thu Ngan')


Select * From NhanVien

insert into PNhap values('N01', '12/05/2020', 'NV2')
insert into PNhap values('N02', '10/07/2020', 'NV1')
insert into PNhap values('N03', '07/08/2020', 'NV3')
insert into PNhap values('N04', '08/11/2020', 'NV3')
insert into PNhap values('N05', '04/12/2020', 'NV5')
insert into PNhap values('N06', '09/02/2018', 'NV4')
insert into PNhap values('N07', '09/06/2018', 'NV4')
insert into PNhap values('N08', '08/05/2018', 'NV2')
insert into PNhap values('N09', '08/01/2018', 'NV5')
insert into PNhap values('N10', '08/10/020', 'NV6')

Select * From PNhap

insert into Nhap values('N02', 'SP1', 10, 5000)
insert into Nhap values('N05', 'SP2', 11, 7000)
insert into Nhap values('N03', 'SP4', 8, 8000)
insert into Nhap values('N02', 'SP4', 5, 900)
insert into Nhap values('N01', 'SP3', 10, 6000)
insert into Nhap values('N07', 'SP7', 18, 9000)
insert into Nhap values('N06', 'SP1', 17, 7500)
insert into Nhap values('N07', 'SP4', 21, 750)
insert into Nhap values('N08', 'SP3', 25, 35)
insert into Nhap values('N09', 'SP4', 21, 18000)
insert into Nhap values('N07', 'SP5', 8, 45)

Select * From Nhap

insert into PXuat values('X01', '12/07/2020', 'NV3')
insert into PXuat values('X02', '11/08/2020', 'NV4')
insert into PXuat values('X03', '07/03/2020', 'NV2')
insert into PXuat values('X04', '06/12/2020', 'NV5')
insert into PXuat values('X05', '07/08/2020', 'NV1')
insert into PXuat values('X06', '06/09/2018', 'NV1')
insert into PXuat values('X07', '05/12/2018', 'NV2')

Select * From PXuat

insert into Xuat values('X03', 'SP3', 10)
insert into Xuat values('X04', 'SP2', 11)
insert into Xuat values('X02', 'SP1', 8)
insert into Xuat values('X02', 'SP4', 5)
insert into Xuat values('X01', 'SP5', 3610)
insert into Xuat values('X05', 'SP6', 15)
insert into Xuat values('X05', 'SP7', 5)
insert into Xuat values('X01', 'SP6', 11000)
insert into Xuat values('X03', 'SP7', 10010)
insert into Xuat values('X06', 'SP5', 7)
insert into Xuat values('X07', 'SP6', 479)

Select * From Xuat

Create Function fn_TimHang(@MaSP nvarchar(10))
Returns nvarchar(20)
As
Begin
 Declare @ten nvarchar(20)
 Set @ten = (Select TenHang From HangSX Inner join SanPham
 on HangSX.MaHangSX = SanPham.MaHangSX
 Where MaSP = @MaSP)
 Return @ten
End
Select dbo.fn_TimHang('sp01')

-- b
Create Function fn_ThongKeNhapTheoNam(@x int,@y int)
Returns int
As
Begin
 Declare @tongTien int
 Select @tongTien = sum(SoLuongN*DonGiaN)
 From Nhap Inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
 Where Year(NgayNhap) Between @x And @y
 Return @tongTien
End

Select dbo.fn_ThongKeNhapTheoNam(2016,2020)

--c
Create Function fn_ThongKeNhapXuat(@TenSP nvarchar(20),@nam int)
Returns int
As
Begin
 Declare @tongnhap int
 Declare @tongxuat int
 Declare @thaydoi int
 Select @tongnhap = Sum(SoLuongN) From Nhap
 Inner join SanPham on Nhap.MaSP = SanPham.MaSP
 Inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
 Where TenSP = @TenSP And Year(NgayNhap)=@nam
 Select @tongxuat = Sum(SoLuongX) From Xuat
 Inner join SanPham on Xuat.MaSP = SanPham.MaSP
 Inner join PXuat on PXuat.SoHDX=Xuat.SoHDX
 Where TenSP = @TenSP And Year(NgayXuat)=@nam
 Set @thaydoi = @tongnhap - @tongxuat
 Return @thaydoi
End
Select dbo.fn_ThongKeNhapXuat('Galaxy Note 11',2020) as 'Thay Doi'

--d
create Function fn_Tonggiatrinhap(@tungay date, @denngay date)
returns int
as
Begin
 Declare @tongnhap int
 Select @tongnhap = Sum(SoLuongN* DonGiaN) From Nhap
 inner join PNhap 
 on Nhap.SoHDN = PNhap.SoHDN
 where @tungay <= NgayNhap
 and @denngay >= NgayNhap
 return @tongnhap
End

select dbo.fn_tonggiatrinhap('1/1/2016','1/1/2020') as 'TongGTN'

--e
create Function fn_Tonggiatrixuat(@tenhang nvarchar(20), @nam int)
returns int
as
Begin
 Declare @tongxuat int
 Select @tongxuat = Sum(SoLuongX* DonGiaX) From PXuat
 inner join Xuat on PXuat.SoHDX = Xuat.SoHDX
 inner join SanPham on Xuat.MaSP = SanPham.MaSP
 inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX 
 where year(NgayXuat) = @nam
 and TenHang = @tenhang
 return @tongxuat
End
--test e
select dbo.fn_Tonggiatrixuat('A',2020)as 'TongGTX'

-- f
create Function fn_SoNVPhong(@tenphong nvarchar(20))
returns int
as
begin
	Declare @SoNV int
	select @SoNV = count(Manv) from NhanVien
	where TenPhong = @tenphong
	group by TenPhong
	return @SoNV
end

select dbo.fn_SoNVPhong('Kinh Doanh') as 'SoNV'

--g
create fn_SLXuatNgay(@tensp nvarchar(20), @ngayX date)
returns int
as
begin
	Declare @SLX int
	select @SlX = sum(SoLuongX) from PXuat 
	inner join Xuat on PXuat.SoDHX = Xuat.SoHDX
	inner join SanPham on Xuat.MaSP = SanPham.MaSP
	where TenSP = @tensp
	and NgayX = @ngayX
	group by MaSP
end

select fn_SLXuatNgay('Sach SQL','12/6/2020')